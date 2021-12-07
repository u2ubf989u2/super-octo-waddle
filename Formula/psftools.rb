class Psftools < Formula
  desc "Tools for fixed-width bitmap fonts"
  homepage "https://www.seasip.info/Unix/PSF/"
  # psftools-1.1.10.tar.gz (dated 2017) was a typo of 1.0.10 and has since been deleted.
  # You may still find it on some mirrors but it should not be used.
  url "https://www.seasip.info/Unix/PSF/psftools-1.0.14.tar.gz"
  sha256 "dcf8308fa414b486e6df7c48a2626e8dcb3c8a472c94ff04816ba95c6c51d19e"
  license "GPL-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "474daee5c218ce90013ce498fa84dc5486bfdd1ff736535a87bd618fa72f3da9"
    sha256 cellar: :any, big_sur:       "42056401c680e3a2372f2b16c78936b6e06c1cb3f8125f1a7c0fff8d23372de9"
    sha256 cellar: :any, catalina:      "ac3cc35325cd2b565044a9e864bbf4b3c2e34a39f46b267ae3fc753d63857a83"
    sha256 cellar: :any, mojave:        "8e53985d7a48b4f927d94ac27339ba7d293181b90fe33d05f22c71ff1e48c126"
    sha256 cellar: :any, x86_64_linux:  "11c63a9db347aef447157dcb76bca7c6029bb1a0494635cc2e6c46d16af2d3f4"
  end

  depends_on "autoconf" => :build

  resource "pc8x8font" do
    url "https://www.zone38.net/font/pc8x8.zip"
    sha256 "13a17d57276e9ef5d9617b2d97aa0246cec9b2d4716e31b77d0708d54e5b978f"
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # The zip file has a fon in it, use fon2fnts to extrat to fnt
    resource("pc8x8font").stage do
      system "#{bin}/fon2fnts", "pc8x8.fon"
      assert_predicate Pathname.pwd/"PC8X8_9.fnt", :exist?
    end
  end
end
