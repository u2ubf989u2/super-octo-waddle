class Codemod < Formula
  include Language::Python::Virtualenv

  desc "Large-scale codebase refactors assistant tool"
  homepage "https://github.com/facebook/codemod"
  url "https://files.pythonhosted.org/packages/9b/e3/cb31bfcf14f976060ea7b7f34135ebc796cde65eba923f6a0c4b71f15cc2/codemod-1.0.0.tar.gz"
  sha256 "06e8c75f2b45210dd8270e30a6a88ae464b39abd6d0cab58a3d7bfd1c094e588"
  license "Apache-2.0"
  revision OS.mac? ? 4 : 5
  version_scheme 1
  head "https://github.com/facebook/codemod.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd163a10ae30dfc11ed64e45e746472360361c084339fb3c426fd97734cbf1c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "66c432f6fc86bd65b2596215ac6e8a30bb813c70cf9585783a564c06e075a72f"
    sha256 cellar: :any_skip_relocation, catalina:      "e0a2e42e92636a4b0ccb54fdfa45ca5e73870315357d57c5c673d7710e3ffb7a"
    sha256 cellar: :any_skip_relocation, mojave:        "07b7c3807d776ca2991a321f32846a9613d0af356f69482f2653a5c30b7304df"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b7b6b35729c1e0e990f4dc2d09c197d6c07cd8fbdacaa3d81decfe16e8856cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76f441b50d78411faa44ddfaa082e3d04b96bbcc20dc9f44ca6510227b5c1fde"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    # work around some codemod terminal bugs
    ENV["TERM"] = "xterm"
    ENV["LINES"] = "25"
    ENV["COLUMNS"] = "80"
    (testpath/"file1").write <<~EOS
      foo
      bar
      potato
      baz
    EOS
    (testpath/"file2").write <<~EOS
      eeny potato meeny miny moe
    EOS
    system bin/"codemod", "--include-extensionless", "--accept-all", "potato", "pineapple"
    assert_equal %w[foo bar pineapple baz], File.read("file1").lines.map(&:strip)
    assert_equal ["eeny pineapple meeny miny moe"], File.read("file2").lines.map(&:strip)
  end
end
