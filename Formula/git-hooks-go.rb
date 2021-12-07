class GitHooksGo < Formula
  desc "Git hooks manager"
  homepage "https://git-hooks.github.io/git-hooks"
  url "https://github.com/git-hooks/git-hooks/archive/v1.3.1.tar.gz"
  sha256 "c37cedf52b3ea267b7d3de67dde31adad4d2a22a7780950d6ca2da64a8b0341b"
  license "MIT"
  head "https://github.com/git-hooks/git-hooks.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0162bfccf604080a5c520a02bf84cb006390935f8cc59c0ef4c1f7f08d071cbd"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb65c1d92db2e31b8d3d2447e3c4642a1865658f9d8075a381439ca311b2ddde"
    sha256 cellar: :any_skip_relocation, catalina:      "c297503f6623a3c258c84a887225f3690433a16e97492f7071cc0c3ebee0d073"
    sha256 cellar: :any_skip_relocation, mojave:        "c5323401f5a7f37a895c9b7b579f10e75fccf0f83ba9fa4bfba4782cebeedbb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39cac903ec0c4755e10ede7a6229beff014bdcfc1b6ca51d7f1c2fa6bfc2b73a"
  end

  depends_on "go" => :build

  conflicts_with "git-hooks", because: "both install `git-hooks` binaries"

  def install
    system "go", "build", *std_go_args, "-o", "#{bin}/git-hooks"
  end

  test do
    system "git", "init"
    system "git", "hooks", "install"
    assert_match "Git hooks ARE installed in this repository.", shell_output("git hooks")
  end
end
