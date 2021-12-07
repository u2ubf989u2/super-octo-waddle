class Atasm < Formula
  desc "Atari MAC/65 compatible assembler for Unix"
  homepage "https://atari.miribilist.com/atasm/"
  url "https://atari.miribilist.com/atasm/atasm107d.zip"
  version "1.07d"
  sha256 "24a165506346029fbe05ed99b22900ae50f91f5a8c5d38ebad6a92a5c53f3d99"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5e039ac5553f6b2dc4e02871041ce1cc7fb4030f90d6601c381ff3060f9c8f2a"
    sha256 cellar: :any_skip_relocation, big_sur:       "88e14d4779b2bd0437988d9525b5a5f7cca8ce76334bc89780a19acb539de225"
    sha256 cellar: :any_skip_relocation, catalina:      "8f142806b05036e541ef3fec3009d481423f451cbcd99e6be68ae5095cfa205e"
    sha256 cellar: :any_skip_relocation, mojave:        "7a2437b5a0adf8047fc75a20fb669d2d80b15d261eab0ec0ad5c7d74b9123a2b"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b9eb26201949590ab8fce80ee3feabe7f0be2f611e7c60b6b456c8d78480680c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fed5da64215e63255a1a33dfe370205e21c66e194c957e26610411da56517a2"
  end

  uses_from_macos "zlib"

  def install
    cd "src" do
      system "make", "prog"
      bin.install "atasm"
      system "sed -e 's,%%DOCDIR%%,/usr/local/share/doc/atasm,g' < atasm.1.in > atasm.1"
      man1.install "atasm.1"
    end
    doc.install "examples"
  end

  test do
    cd "#{doc}/examples" do
      system "#{bin}/atasm", "-v", "test.m65", "-o/tmp/test.bin"
    end
  end
end
