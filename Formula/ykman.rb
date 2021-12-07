class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/67/4d/824b40d37cafc9ca681ad1fa80981a59d10b4153f146b6bafb943180ea46/yubikey-manager-4.0.2.tar.gz"
  sha256 "998f804a66695feeb3a48ba200320850243aa605d6d4edcb30bea4cc349aea21"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2549b4d49538b1634e2ef40fd70a0df6fb0bc92de29aa736c926e8ef09eb20de"
    sha256 cellar: :any,                 big_sur:       "1395eb2175ef338f3b4d205fd838161c1242ab0a5778cfa07963dd94eba544d6"
    sha256 cellar: :any,                 catalina:      "7679ab9aa2fa8c4f5a220849ef43e1358562c1fabc6f48bd015a4ed0bffbdf1e"
    sha256 cellar: :any,                 mojave:        "d5f30c128ef9df005618d69debe043a08691191ff5a0896a2dd47ce1f630d6d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2ae2f8d968a5c6d27acc86be29835eeadd8dce0202f3962cf89bb177a1127cc"
  end

  depends_on "rust" => :build
  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pcsc-lite"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/80/c3/5077ee98edd23ee00b9f5f889fd65e8dd8dbe7717d663d3b5137e31f07e6/fido2-0.9.1.tar.gz"
    sha256 "8680ee25238e2307596eb3900a0f8c0d9cc91189146ed8039544f1a3a69dfe6e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/98/cd/cbc9c152daba9b5de6094a185c66f1c6eb91c507f378bb7cad83d623ea88/pyOpenSSL-20.0.1.tar.gz"
    sha256 "4c231c759543ba02560fcd2480c48dcec4dae34c9da7d3747c508227e0624b51"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/2b/98/fd2a827eed42ca3dcd7a433ee75a9868bfe3fc1428839a2831ab9dd90c69/pyscard-2.0.0.tar.gz"
    sha256 "b364d9d9186e793c1c4709eb72a4d29e09067d36ca463b2c2abd995bd1055779"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    on_linux do
      # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
      ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC"
    end
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
