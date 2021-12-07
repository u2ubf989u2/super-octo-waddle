class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/ac/4c/8756bfb6ac7434bda33b29bb8d6abaa8e8ca9a21f927beff6e4b2a6a2686/nicotine-plus-3.0.3.tar.gz"
  sha256 "7d59088cfae08539ddcb7d40c65fb267f746af0712b044b24c396a4f7224b568"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76c6b9d080f170125331b549cbb496eb3639a757cdcd6b4056ec5a98afeeb533"
    sha256 cellar: :any_skip_relocation, big_sur:       "0997da63eb74d5138330ef9bd0f82635971b29742f13e2d01e2c0f73fd8d64c3"
    sha256 cellar: :any_skip_relocation, catalina:      "872762c2cc58bee642e35770637471bc78533c379a15935e62e0d90406767fd2"
    sha256 cellar: :any_skip_relocation, mojave:        "7c97cf043c4ad24779b9e8f2ac571bcc728044822b482fefaa8f29be663b1cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ee27ba412cbf136a3dc1d621f399244a29920ffd2b7fd87d4bd41b202c24a9b"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nicotine -v")
    pid = fork do
      exec bin/"nicotine", "-s"
    end
    sleep 3
    Process.kill("TERM", pid)
  end
end
