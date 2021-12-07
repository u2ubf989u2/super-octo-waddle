class Mpfi < Formula
  desc "Multiple precision interval arithmetic library"
  homepage "https://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "https://gforge.inria.fr/frs/download.php/file/37331/mpfi-1.5.3.tar.bz2"
  sha256 "2383d457b208c6cd3cf2e66b69c4ce47477b2a0db31fbec0cd4b1ebaa247192f"
  license "GPL-3.0"

  livecheck do
    url "https://gforge.inria.fr/frs/?group_id=157"
    regex(/href=.*?mpfi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "294ebea233e52a6a0153e535a031e3bbea8bd4b36c4323c9d715512d77defc41"
    sha256 cellar: :any, big_sur:       "fa207c29103a5e5d770b7235edf6b8c40b301ba8fbd19856c1793f787b9b1dfc"
    sha256 cellar: :any, catalina:      "950fb479ad3748345f0410a7ce02d70527d9757d0c20ea1ed73d8f3f4e1c512c"
    sha256 cellar: :any, mojave:        "55d8819c0310e6b8bc66742f7ab5881b9b552a9c60eaf940595ed08e8a320a56"
    sha256 cellar: :any, high_sierra:   "d4464bdbbb2861861fa92e471f75e1b658e7c5f5814028a6c57f74c76092b013"
    sha256 cellar: :any, sierra:        "50d3b78c1ef6837198a0320dbbe0852ad524f83bc2e12460bfbdc188bd1da76a"
    sha256 cellar: :any, x86_64_linux:  "9d948d4b378594da197972541f316203868402c5aab7b8b32aa5b83bdad0bd07"
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpfi.h>

      int main()
      {
        mpfi_t x;
        mpfi_init(x);
        mpfi_clear(x);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-L#{lib}", "-lmpfi",
                   "-L#{Formula["mpfr"].lib}", "-lmpfr",
                   "-L#{Formula["gmp"].lib}", "-lgmp"
    system "./test"
  end
end
