class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/3c/2d/9867b195c5c9b427e07cfeeb982c56086c00bca13c560e093e4133775635/cpplint-1.5.4.tar.gz"
  sha256 "c5d70711f06a7a8bfdc09bd7a19c13e114e009a70c8dc16caad1e5f0d2f3cc71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2e90a23cdf7c41fc41541d8ce4716eccae1fb9de74acb4a0c43027532eb8772c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e9294810d16c29dc48b4cfb5c2100c031bed1afa1e2dca8c69914e2ea3b2bb75"
    sha256 cellar: :any_skip_relocation, catalina:      "f6e997327f819be03b1bed333bd633463a752cd97fd381b3e837ad07d4583273"
    sha256 cellar: :any_skip_relocation, mojave:        "a0436c4fb92a6727d44692c399fc572c176c8f85c051e5b98c57ab01ec5f51c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab280136960f724e75765cb84b54295be94ff2680393e64babf0d26c1388524"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources

    # install test data
    pkgshare.install "samples"
  end

  test do
    output = shell_output("#{bin}/cpplint --version")
    assert_match "cpplint #{version}", output.strip

    output = shell_output("#{bin}/cpplint #{pkgshare}/samples/v8-sample/src/interface-descriptors.h", 1)
    assert_match "Total errors found: 2", output
  end
end
