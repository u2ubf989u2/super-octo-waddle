class Mpich < Formula
  desc "Implementation of the MPI Message Passing Interface standard"
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/3.4.1/mpich-3.4.1.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-3.4.1.tar.gz"
  sha256 "8836939804ef6d492bcee7d54abafd6477d2beca247157d92688654d13779727"
  license "mpich2"
  revision 1

  livecheck do
    url "https://www.mpich.org/static/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d57992c74140b8bc0d410bc86a6e67febeb0e6e9805b2ab5608f41f5f26b121b"
    sha256 cellar: :any,                 big_sur:       "7f970d15db426859aadea466f17549bd4add967ad1082d34fc5844b332b4099e"
    sha256 cellar: :any,                 catalina:      "823585ee5005dd4c5298524ff8b6950296f3cbcc6a9c6cc53b3e93252185344f"
    sha256 cellar: :any,                 mojave:        "30ff98a7f4bded67dc55b08ab72a01cac22b747d7b91389d72577a60c4815187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b7acb3d38fa39d9d2dd94c9fe61a17ad7ecbe2efbbb73b8d5e0c16191cc11e1"
  end

  head do
    url "https://github.com/pmodels/mpich.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "gcc" # for gfortran

  conflicts_with "open-mpi", because: "both install MPI compiler wrappers"

  depends_on "libfabric" unless OS.mac?

  if Hardware::CPU.arm?
    # gfortran from 10.2.0 on arm64 does not seem to know about real128 and complex128
    # the recommended solution by upstream is to comment out the declaration of
    # real128 and complex128 in the source code as they do not have the resources
    # to update the f08 binding generation script at the moment
    # https://lists.mpich.org/pipermail/discuss/2021-March/006167.html
    patch :DATA
  end

  def install
    if build.head?
      # ensure that the consistent set of autotools built by homebrew is used to
      # build MPICH, otherwise very bizarre build errors can occur
      ENV["MPICH_AUTOTOOLS_DIR"] = HOMEBREW_PREFIX + "bin"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--enable-fast=all,O3",
                          "--enable-g=dbg",
                          "--enable-romio",
                          "--enable-shared",
                          "--with-pm=hydra",
                          "FC=gfortran-#{Formula["gcc"].any_installed_version.major}",
                          "F77=gfortran-#{Formula["gcc"].any_installed_version.major}",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          # Flag for compatibility with GCC 10
                          # https://lists.mpich.org/pipermail/discuss/2020-January/005863.html
                          "FFLAGS=-fallow-argument-mismatch",
                          "CXXFLAGS=-Wno-deprecated",
                          "CFLAGS=-fgnu89-inline -Wno-deprecated",
                          # Use libfabric https://lists.mpich.org/pipermail/discuss/2021-January/006092.html
                          *("--with-device=ch4:ofi" unless OS.mac?)

    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <mpi.h>
      #include <stdio.h>

      int main()
      {
        int size, rank, nameLen;
        char name[MPI_MAX_PROCESSOR_NAME];
        MPI_Init(NULL, NULL);
        MPI_Comm_size(MPI_COMM_WORLD, &size);
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);
        MPI_Get_processor_name(name, &nameLen);
        printf("[%d/%d] Hello, world! My name is %s.\\n", rank, size, name);
        MPI_Finalize();
        return 0;
      }
    EOS
    system "#{bin}/mpicc", "hello.c", "-o", "hello"
    system "./hello"
    system "#{bin}/mpirun", "-np", "4", "./hello"

    (testpath/"hellof.f90").write <<~EOS
      program hello
      include 'mpif.h'
      integer rank, size, ierror, tag, status(MPI_STATUS_SIZE)
      call MPI_INIT(ierror)
      call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
      call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
      print*, 'node', rank, ': Hello Fortran world'
      call MPI_FINALIZE(ierror)
      end
    EOS
    system "#{bin}/mpif90", "hellof.f90", "-o", "hellof"
    system "./hellof"
    system "#{bin}/mpirun", "-np", "4", "./hellof"
  end
end


__END__
--- a/src/binding/fortran/use_mpi_f08/mpi_f08_types.f90
+++ b/src/binding/fortran/use_mpi_f08/mpi_f08_types.f90
@@ -248,10 +248,8 @@
     module procedure MPI_Sizeof_xint64
     module procedure MPI_Sizeof_xreal32
     module procedure MPI_Sizeof_xreal64
-    module procedure MPI_Sizeof_xreal128
     module procedure MPI_Sizeof_xcomplex32
     module procedure MPI_Sizeof_xcomplex64
-    module procedure MPI_Sizeof_xcomplex128
 end interface
 
 private :: MPI_Sizeof_character
@@ -263,10 +261,8 @@
 private :: MPI_Sizeof_xint64
 private :: MPI_Sizeof_xreal32
 private :: MPI_Sizeof_xreal64
-private :: MPI_Sizeof_xreal128
 private :: MPI_Sizeof_xcomplex32
 private :: MPI_Sizeof_xcomplex64
-private :: MPI_Sizeof_xcomplex128
 
 contains
 
@@ -350,16 +346,6 @@
     ierror = 0
 end subroutine MPI_Sizeof_xreal64
 
-subroutine MPI_Sizeof_xreal128 (x, size, ierror)
-    use,intrinsic :: iso_fortran_env, only: real128
-    real(real128),dimension(..) :: x
-    integer, intent(out) :: size
-    integer, optional,  intent(out) :: ierror
-
-    size = storage_size(x)/8
-    ierror = 0
-end subroutine MPI_Sizeof_xreal128
-
 subroutine MPI_Sizeof_xcomplex32 (x, size, ierror)
     use,intrinsic :: iso_fortran_env, only: real32
     complex(real32),dimension(..) :: x
@@ -380,16 +366,6 @@
     ierror = 0
 end subroutine MPI_Sizeof_xcomplex64
 
-subroutine MPI_Sizeof_xcomplex128 (x, size, ierror)
-    use,intrinsic :: iso_fortran_env, only: real128
-    complex(real128),dimension(..) :: x
-    integer, intent(out) :: size
-    integer, optional,  intent(out) :: ierror
-
-    size = storage_size(x)/8
-    ierror = 0
-end subroutine MPI_Sizeof_xcomplex128
-
 subroutine MPI_Status_f2f08(f_status, f08_status, ierror)
     integer, intent(in) :: f_status(MPI_STATUS_SIZE)
     type(MPI_Status), intent(out) :: f08_status
