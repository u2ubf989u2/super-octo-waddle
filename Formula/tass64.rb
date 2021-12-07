class Tass64 < Formula
  desc "Multi pass optimizing macro assembler for the 65xx series of processors"
  homepage "https://tass64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tass64/source/64tass-1.55.2200-src.zip"
  sha256 "067d0a54cb3c473b26aa5d69ea3f1f956be7cccc9044f1117fc20cb84aa63880"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf68212ef8aa0d63b5390a0108d00a61dad254fa630af42dca211368484647f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c9cac57b73b6e69b31534935f72bc832f9ee85618063bd93dde2fa932183330"
    sha256 cellar: :any_skip_relocation, catalina:      "afefda676ae81f3340850d132e17fa408505d79da25fd50c42c3042ca3b4f7f2"
    sha256 cellar: :any_skip_relocation, mojave:        "4a1a224e806b0f9827ffe1f4e5e8ce792e616e6b2e829c278fad5c8a5ee958af"
    sha256 cellar: :any_skip_relocation, high_sierra:   "1aa51c3d25cf651f7d4725d89a022ab2510963684dc3b3ebe4845b488b3bb5d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e17d9d9b9708340f0a3852c3cc9cc2852c5603c4f494f7ce30e875553be01a7"
  end

  def install
    system "make", "install", "CPPFLAGS=-D_XOPEN_SOURCE", "prefix=#{prefix}"

    # `make install` does not install syntax highlighting definitions
    pkgshare.install "syntax"
  end

  test do
    (testpath/"hello.asm").write <<~'EOS'
      ;; Simple "Hello World" program for C64
      *=$c000
        LDY #$00
      L0
        LDA L1,Y
        CMP #0
        BEQ L2
        JSR $FFD2
        INY
        JMP L0
      L1
        .text "HELLO WORLD",0
      L2
        RTS
    EOS

    system "#{bin}/64tass", "-a", "hello.asm", "-o", "hello.prg"
    assert_predicate testpath/"hello.prg", :exist?
  end
end
