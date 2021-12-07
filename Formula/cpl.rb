class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.1.3.tar.gz"
  sha256 "04109613819b97273045102bd7acf52d13ee7f9217779f17ae2a170c491965c5"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.eso.org/sci/software/cpl/download.html"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f6509e4835df16a6e1e6b1c1b6106d6e051ee68d218e2c0de1dfaf6de861a6d8"
    sha256 cellar: :any,                 big_sur:       "e7c7251df2f10b6c835b71e9ade9f13c785e93dbf4a394336155ac33eff4eb5c"
    sha256 cellar: :any,                 catalina:      "a65a33c7ea760f22e9754185fb4626c61d6797eb048517bda1c45114dacce152"
    sha256 cellar: :any,                 mojave:        "c387e361d054fd4e735ecb36b6007619f993d005344edd435c40db47407a1287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8555de1fcdc3cae1148dc3ca44c137456f59b322aa5aeadcb92ad9c773f91d16"
  end

  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "wcslib"

  conflicts_with "gdal", because: "both install cpl_error.h"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                          "--with-fftw=#{Formula["fftw"].prefix}",
                          "--with-wcslib=#{Formula["wcslib"].prefix}",
                          # Needed for 7.1.2's ./configure to work under Xcode 12:
                          "CC=#{ENV.cc} -Wno-implicit-function-declaration"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <cpl.h>
      int main(){
        cpl_init(CPL_INIT_DEFAULT);
        cpl_msg_info("hello()", "Hello, world!");
        cpl_end();
        return 0;
      }
    EOF
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lcplcore", "-lcext", "-o", "test"
    system "./test"
  end
end
