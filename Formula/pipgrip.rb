class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/57/d2/dd1e78d9d1de7bcfd27c09494d57ab3020778da662bb15e4f905342dd714/pipgrip-0.6.7.tar.gz"
  sha256 "784280e2dedf72b7676839f645dcfd29075d8d808d89d8cd52b8f70dbd46a2de"
  license "BSD-3-Clause"
  revision 1 unless OS.mac?

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1152cc9a5ff6ac31cca1a13d230b7f6b94bb21720d007735f1d32cfdbf5907f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "13b01f35d30b10a0caeb39c486d2bc7bf4d652736de3e28fa2684ac881e83a98"
    sha256 cellar: :any_skip_relocation, catalina:      "26d79927450050d2db8ca89c4144e3be93405ff096df8466cd91f422d1e9c914"
    sha256 cellar: :any_skip_relocation, mojave:        "98fbc2f6d513292d4d072375836d4502e3ba39d848cf5bee45309ea78c01d7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf4494619a2583871d705accb5eff61fbc01569e5f2a25d4655e7729c5e9a27"
  end

  depends_on "python@3.9"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/36/d3/f56bbbb9e03812de99be566a4c8ed90a0202b9aebd4528b2ad98900b9063/pkginfo-1.7.0.tar.gz"
    sha256 "029a70cb45c6171c329dfc890cde0879f8c52d6f3922794796e06f577bb03db4"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/ed/46/e298a50dde405e1c202e316fa6a3015ff9288423661d7ea5e8f22f589071/wheel-0.36.2.tar.gz"
    sha256 "e11eefd162658ea59a60a0f6c7d493a7190ea4b9a85e335b33489d9f17e0245e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end
