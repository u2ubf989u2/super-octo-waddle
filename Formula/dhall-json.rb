class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.6/dhall-json-1.7.6.tar.gz"
  sha256 "1644aa4d5a5f200dbf39a794ea8c560c081f7502a0747544c6e7401ceeb385ba"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "d1dd64ef3b551cb9bd3ec4de1ddc336457ca588421b2b5dab1f6ecbc609fd4b0"
    sha256 cellar: :any_skip_relocation, catalina:     "b75a7ef02eefee86b173f6e8c7b6eff5e3247a319b86a2d3f37abc86e7230cee"
    sha256 cellar: :any_skip_relocation, mojave:       "004e35525351878b319875287e858d58b4f0acad0839fc3a00122364c8048c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6ee951f3ceb1eee7ee5009d91dce6f68ca52f8de1a1dc401d5df09cb5153a798"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
