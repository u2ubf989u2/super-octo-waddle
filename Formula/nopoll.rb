class Nopoll < Formula
  desc "Open-source C WebSocket toolkit"
  homepage "https://www.aspl.es/nopoll/"
  url "https://www.aspl.es/nopoll/downloads/nopoll-0.4.6.b400.tar.gz"
  version "0.4.6.b400"
  sha256 "7f1b20f1d0525f30cdd2a4fc386d328b4cf98c6d11cef51fe62cd9491ba19ad9"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e83bf8232d6018d6b7df08407aeeb44ba8ef4b0d740b0b1b849b303ef50ce27c"
    sha256 cellar: :any, big_sur:       "ebfbacc4b27be046d30500356f15c6752ffc4d083e723017aa7ca5baa6fd9651"
    sha256 cellar: :any, catalina:      "e2cb3119545fe042968b9df9d19a94cc5c02f9f3ab04fcdd91bc1a8670dfa496"
    sha256 cellar: :any, mojave:        "dcd358fc9a1f1e106aae15d59b1190956f0ac4e7f52673d24833edca3c1146cb"
    sha256 cellar: :any, high_sierra:   "16bde638c91fd329d946b5854cd44291cbf516af2888e7880c5fa47dcb777936"
    sha256 cellar: :any, sierra:        "dd12a792cc0cb95a56cce2037d22b4c1141b85da48d2c511f6495914351ce2f0"
    sha256 cellar: :any, x86_64_linux:  "1128029c6204cc31215dfc949fe819bb17a34cf16dddcf28020250d79f21ff18"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nopoll.h>
      int main(void) {
        noPollCtx *ctx = nopoll_ctx_new();
        nopoll_ctx_unref(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/nopoll", "-L#{lib}", "-lnopoll",
           "-o", "test"
    system "./test"
  end
end
