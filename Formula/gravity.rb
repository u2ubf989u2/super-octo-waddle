class Gravity < Formula
  desc "Embeddable programming language"
  homepage "https://marcobambini.github.io/gravity/"
  url "https://github.com/marcobambini/gravity/archive/0.8.1.tar.gz"
  sha256 "0db70b08984dc73f989d0f60dbd3e0c6e1027e7c31674f368a8e52843b0f9496"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0cd6b451f1bba749aa8c35b9532accb078d8ba379b9afadbce6b33ea28563ca4"
    sha256 cellar: :any_skip_relocation, big_sur:       "9de1478c092c6d76cc371231f6b8b9c33027b03631f4dcc538c233e695444b02"
    sha256 cellar: :any_skip_relocation, catalina:      "f52cc57b5674778efff24e2fa3717fe9e697b129013fd5d779bc4fe30cea2775"
    sha256 cellar: :any_skip_relocation, mojave:        "e85c05bbd55c03b82dcfa10bc0dedfd23f8c9512a0ec16b087adeaf576d20447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c088827e6514d1deee2a185d912ab614c720d5b08b616c851a60476c101fe07e"
  end

  def install
    system "make"
    bin.install "gravity"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.gravity").write <<~EOS
      func main() {
          System.print("Hello World!")
      }
    EOS
    system bin/"gravity", "-c", "hello.gravity", "-o", "out.json"
    assert_equal "Hello World!\n", shell_output("#{bin}/gravity -q -x out.json")
    assert_equal "Hello World!\n", shell_output("#{bin}/gravity -q hello.gravity")
  end
end
