class Libtecla < Formula
  desc "Command-line editing facilities similar to the tcsh shell"
  homepage "https://www.astro.caltech.edu/~mcs/tecla/index.html"
  url "https://www.astro.caltech.edu/~mcs/tecla/libtecla-1.6.3.tar.gz"
  sha256 "f2757cc55040859fcf8f59a0b7b26e0184a22bece44ed9568a4534a478c1ee1a"

  bottle do
    sha256 cellar: :any, big_sur:      "d0f28c06cf9d2d1669298104439c4e194d21df65fc17e9b95e9dec0383aa7fef"
    sha256 cellar: :any, catalina:     "a6bbfa1cee4b62a03186d6fa1a153fceb2b3b9ae5cdf63411d6432c6251c753b"
    sha256 cellar: :any, mojave:       "d39e8711f7a9a5a11433c7c92a2113a97f8846796f93fa7bca1281e06db2e3fe"
    sha256 cellar: :any, high_sierra:  "dffae78362e21bf324ed651a2b80ff924b1bbec60916159863e66c7171072a9c"
    sha256 cellar: :any, sierra:       "21cd696f6e79ae6401dd19f832ac24263f016a62c2d15ec31e25d515bbea5983"
    sha256 cellar: :any, el_capitan:   "3ceb3942ea4ae1434dcc0aea00fa58b6f16787bc1a0067e9497ad4cb050f771a"
    sha256 cellar: :any, yosemite:     "836d6100343197540f079ea7f6b9e5641fd8efc4e331d3492f8be4cd41ced6e9"
    sha256 cellar: :any, x86_64_linux: "d51094034ca406b255ddd2a44c9eeb078ace5502b5bb9b9421e8260a0beb1e10" # glibc 2.19
  end

  uses_from_macos "ncurses"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <locale.h>
      #include <libtecla.h>

      int main(int argc, char *argv[]) {
        GetLine *gl;
        setlocale(LC_CTYPE, "");
        gl = new_GetLine(1024, 2048);
        if (!gl) return 1;
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-ltecla", "-o", "test"
    system "./test"
  end
end
