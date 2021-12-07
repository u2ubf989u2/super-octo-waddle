class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.16.0.tar.gz"
  sha256 "eac7ac0dae3b709aea7c7eaa578d09b8f101e590f1c2d83c66926afa233993b0"
  license "MIT"
  head "https://github.com/profclems/glab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "747b4542cac6c9b832c4a43a279b1f9219ba5834a0c8f8e7cd5ac5656152a4c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "942b9de81ad865c128eeb857abc862632bb676caf296589849403d2b1a90e601"
    sha256 cellar: :any_skip_relocation, catalina:      "2d3a42f75e3d788c1699d487e06fda6bb207261d7c4629bd6a00042ceb3792f1"
    sha256 cellar: :any_skip_relocation, mojave:        "71d98335b86d79b40580a4c14c27bda6a4fd4abf4e7fbc1fee0c5d1f236cda1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18cd318b41c022735a9e7fd6f89bb40c941cedf2ecc43015da52b315389f7853"
  end

  depends_on "go" => :build

  def install
    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    (bash_completion/"glab").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=bash")
    (zsh_completion/"_glab").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=zsh")
    (fish_completion/"glab.fish").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=fish")
  end

  test do
    system "git", "clone", "https://gitlab.com/profclems/test.git"
    cd "test" do
      assert_match "Clement Sam", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
