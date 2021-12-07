class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/8.2.1.tar.gz"
  sha256 "428fb2e708cce3a29f9bbc84ce63f112a2eb44fd1b0d2a88d83c86583ca83ed4"
  license "BSD-3-Clause"
  revision 1 unless OS.mac?
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7ac0a95d90734c8288c8cb423e3c4c6664e817993a7e426ca27c3806e3726c1a"
    sha256 cellar: :any,                 big_sur:       "af1867b20867ccea69da9d21eeb7ec2649b76dbdffc092da138bbe23e4bb1801"
    sha256 cellar: :any,                 catalina:      "d2d543adde373aa91e71598e3cde564ab0607ef2545a4d5873784c505e1b3dcd"
    sha256 cellar: :any,                 mojave:        "68883cd0e3b1ec90239ca124711ba48d4c50f284384248088038ac0545504218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ac891f14e996746194e6a1dcec7bb53ace0e9dd7e145da448f6036d2a9e55f8"
  end

  depends_on "cmake" => :build
  depends_on "ford" => :build
  depends_on "gcc" # for gfortran

  on_linux do
    depends_on "libx11"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE",
                            "-DENABLE_UNICODE:BOOL=TRUE"
      system "make", "install"
    end
  end

  test do
    (testpath/"json_test.f90").write <<~EOS
      program example
      use json_module, RK => json_RK
      use iso_fortran_env, only: stdout => output_unit
      implicit none
      type(json_core) :: json
      type(json_value),pointer :: p, inp
      call json%initialize()
      call json%create_object(p,'')
      call json%create_object(inp,'inputs')
      call json%add(p, inp)
      call json%add(inp, 't0', 0.1_RK)
      call json%print(p,stdout)
      call json%destroy(p)
      if (json%failed()) error stop 'error'
      end program example
    EOS
    system "gfortran", "-o", "test", "json_test.f90", "-I#{include}",
                       "-L#{lib}", "-ljsonfortran"
    system "./test"
  end
end
