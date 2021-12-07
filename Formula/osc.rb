class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/0.172.0.tar.gz"
  sha256 "bd4d8c5e081064524972a3f6844798143cc1a0aa3df41f84ee93ec59444e9d8b"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2031fc5819080a21b135068bc14f85cbb9fd6f1974ffedf214480df511e6e4d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d481afd08224785009b0679d26ad2970f87bb27bb547fee9bcdd0bcfec6a85d"
    sha256 cellar: :any_skip_relocation, catalina:      "91728d2288f373343410be0d60848aab70baeacb2d18b6c6eb5c93ff8291c8d9"
    sha256 cellar: :any_skip_relocation, mojave:        "0358596adc5d92f5bf0a3f519f5c1dd611110b23f823532e06288ddffa0631cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3ac7790d65eedd293d2ef56a4537b099b916fd639e834af4386b23d3f8d42c5"
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "curl"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/ff/df/84609ed874b5e6fcd3061a517bf4b6e4d0301f553baf9fa37bef2b509797/M2Crypto-0.36.0.tar.gz"
    sha256 "1542c18e3ee5c01db5031d0b594677536963e3f54ecdf5315aeecb3a595b4dc1"
  end

  def install
    openssl = Formula["openssl@1.1"]
    ENV["SWIG_FEATURES"] = "-I#{openssl.opt_include}"

    inreplace "osc/conf.py", "'/etc/ssl/certs'", "'#{openssl.pkgetc}/cert.pem'"
    virtualenv_install_with_resources
    mv bin/"osc-wrapper.py", bin/"osc"
  end

  test do
    system bin/"osc", "--version"
  end
end
