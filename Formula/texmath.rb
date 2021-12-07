class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.2/texmath-0.12.2.tar.gz"
  sha256 "be6fd90af8a6349111e3969f3ff030aeaad5cb236772348d7cbb6fcb52591153"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "1539fd49ad850acc19dd026905a77b8066112ac4fc16e4e4cb258f189207879c"
    sha256 cellar: :any_skip_relocation, catalina:     "e5ce6a5a729671e4ca2ed7df9c08901d8da34437f5a39cfde0fcb15f3dc8ec7a"
    sha256 cellar: :any_skip_relocation, mojave:       "020445b8f86d18b2bc7a5c0a8fbc7a52180bb935dca30216d23ac34903b54fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "04a043c8f5e657429f4b845cb992baa92a58ae81f5cbcefbaced59c48af249e6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "-fexecutable"
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end
