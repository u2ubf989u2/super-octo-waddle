class Pssh < Formula
  include Language::Python::Virtualenv
  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://files.pythonhosted.org/packages/60/9a/8035af3a7d3d1617ae2c7c174efa4f154e5bf9c24b36b623413b38be8e4a/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  license "BSD-3-Clause"
  revision OS.mac? ? 3 : 4

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7e13419d61916a39cc1dfdca7d41e75b83ad569e752e706660a61bf5d27116d"
    sha256 cellar: :any_skip_relocation, big_sur:       "6840ae494e87f8913579af27d25d7324608df3b52769041ca608a22851271688"
    sha256 cellar: :any_skip_relocation, catalina:      "97b41f49d31808abac8379f9d5891be7cecff34bc183a42b0f6fd5ae1d9fe835"
    sha256 cellar: :any_skip_relocation, mojave:        "2755e4052daf1641f2db79119443ea4552da5db3c578ed9dd779c86f96b35a78"
    sha256 cellar: :any_skip_relocation, high_sierra:   "3eab96d7837cfab4b2c28ad5458e1c68ceb0d75c480e87613ca1872e58b2bf55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "042e33021f5ddb9de9af94c985732419408785fec7f5a8535b0cfffaa65affdf"
  end

  depends_on "python@3.9"

  conflicts_with "putty", because: "both install `pscp` binaries"

  # Fix for Python 3 compatibility
  # https://bugs.archlinux.org/task/46571
  patch do
    url "https://github.com/nplanel/parallel-ssh/commit/ee379dc5.patch?full_index=1"
    sha256 "79c133072396e5d3d370ec254b7f7ed52abe1d09b5d398880f0e1cfaf988defa"
  end

  # Fix for Python 3 compatibility
  # https://bugs.archlinux.org/task/51533
  patch do
    url "https://bugs.archlinux.org/task/51533?getfile=14659"
    sha256 "47c1af738d4ba252e9f35c5633da91bae2a2919a7b6b2bf425ee1f090d61c7fe"
  end

  def install
    # Fixes import error with python3, see https://github.com/lilydjwg/pssh/issues/70
    # fixed in master, should be removed for versions > 2.3.1
    inreplace "psshlib/cli.py", "import version", "from psshlib import version"

    virtualenv_create(libexec, "python3") if OS.mac?
    virtualenv_install_with_resources
  end

  test do
    system bin/"pssh", "--version"
  end
end
