class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  license "AGPL-3.0-only"

  stable do
    url "https://files.pythonhosted.org/packages/90/b4/f24057503cf7aa318f5e2a778002773612ca0196be1a80f679f06625e71f/sslyze-4.0.4.tar.gz"
    sha256 "1bac42d2d4248169aa042dd608887b9e3e3aba42f7fb2d807251fb04a9d6acf1"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/4.0.0.tar.gz"
      sha256 "b8a00062bf4cc7cf4fd09600d0a6845840833a8d3c593c0e615d36abac74f36e"
    end
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "d4679e0817acb24e97f59577ab84abd33a8a11300ba835d89aaba2e32f33000f"
    sha256 cellar: :any,                 catalina:     "5acc1a5dc3494fd651cb987e4893af3aa0413f180ca62cc806c96f538f756cde"
    sha256 cellar: :any,                 mojave:       "bc861e6c31c30eb914321b65ff758c630357b10031e9f481585a7609df2f9e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ac16578c1b85a03cb040f2a727ec0a48dce99cfa4ece467c4993b8a687a249e5"
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git"
    end
  end

  depends_on "pipenv" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/d4/85/38715448253404186029c575d559879912eb8a1c5d16ad9f25d35f7c4f4c/cryptography-3.3.2.tar.gz"
    sha256 "5a60d3780149e13b7a6ff7ad6526b38846354d11a15e21068e57073e29e19bed"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/66/4e/da7f727a76bd9abee46f4035dbd7a4711cde408f286dae00c7a1f9dd9cbb/tls_parser-1.2.2.tar.gz"
    sha256 "83e4cb15b88b00fad1a856ff54731cc095c7e4f1ff90d09eaa24a5f48854da93"
  end

  def install
    venv = virtualenv_create(libexec, "python3.9")

    res = resources.map(&:name).to_set
    res -= %w[nassl]

    res.each do |r|
      venv.pip_install resource(r)
    end

    resource("nassl").stage do
      nassl_path = Pathname.pwd
      inreplace "Pipfile", 'python_version = "3.7"', 'python_version = "3.9"'
      system "pipenv", "install", "--dev"
      system "pipenv", "run", "invoke", "build.all"
      venv.pip_install nassl_path
    end

    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCAN COMPLETED", shell_output("#{bin}/sslyze --regular google.com")
    refute_match("exception", shell_output("#{bin}/sslyze --certinfo letsencrypt.org"))
  end
end
