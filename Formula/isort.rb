class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/31/8a/6f5449a7be67e4655069490f05fa3e190f5f5864e6ddee140f60fe5526dd/isort-5.8.0.tar.gz"
  sha256 "0a943902919f65c5684ac4e0154b1ad4fac6dcaa5d9f3426b732f1c8b5419be6"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7851ef1b59b101c768f455196f1a226811ff4f89eed5ce855422cf1a254ecff1"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ae4d37f79fed6ac903ce991e19888864673fef72f544e4e99e994d880437e52"
    sha256 cellar: :any_skip_relocation, catalina:      "95af85973a39cafec59d9f21a50608e09881ae7b5e70926616dcdf7ad70b7a98"
    sha256 cellar: :any_skip_relocation, mojave:        "253112ca0152460c548df9fac3d6607d73090950241d3af59282dabd74b8a607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa7c556576206501c5a8f987542507c9f5d3b65cd38033bffdb32de3c9b3697"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"isort_test.py").write <<~EOS
      from third_party import lib
      import os
    EOS
    system bin/"isort", "isort_test.py"
    assert_equal "import os\n\nfrom third_party import lib\n", (testpath/"isort_test.py").read
  end
end
