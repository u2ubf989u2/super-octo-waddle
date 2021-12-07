class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/3.0.2.tar.gz"
  sha256 "509e5456ed76e143b05adece1180fe78f09f4b8526e0c3cbf0c9f0188207b160"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e17e06249b6fe16ec89c97604f933feae4f2b796ea74b2f7affe932f9c314a41"
    sha256 cellar: :any_skip_relocation, big_sur:       "096cdd06c1d9296e2a823fcb8fd9318261f3e9114cd95c7acdddbbc967445f11"
    sha256 cellar: :any_skip_relocation, catalina:      "f802589e58b5a2b28357418bd919058db4ddc4cadd9f27f4e67f1c892e63a9dd"
    sha256 cellar: :any_skip_relocation, mojave:        "d3916c02853129681d10f5d16772314fbd0243ab9641784fba9484009c0cced7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a9aa6116f4f6fe3d9d3d3035a933246fff0e088d2b1e9ee9a3e462a6abc10f6"
  end

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
