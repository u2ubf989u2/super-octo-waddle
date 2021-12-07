class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/2.1.0.tar.gz"
  sha256 "f5c2d73a191fe37e1144dca19977e99d2f306ce92ce799acdbf2992524dd4aa2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd082607eef75ac3382d280c358cf19db42ad11d464ded8a2845734de378937c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4480f59a021edb031a3ef02b5cccae62719dad12f6ae7fc2413b75088be466ac"
    sha256 cellar: :any_skip_relocation, catalina:      "9223a3f962e2af3897cefb9e221a529be7701e964005d55436f7de9d97d1b573"
    sha256 cellar: :any_skip_relocation, mojave:        "bfab245c62dd4a37da0c275d8b4642ee86b5912153465da1e312a510fce60b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c9b21647ffb06a962db3d9eca864e678d6f3767139035b96ba95e25e75d014"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    mkdir testpath/"repo" do
      system "git", "init"
    end

    (testpath/"repo/.git/rebase-merge/git-rebase-todo").write <<~EOS
      noop
    EOS

    expected_git_rebase_todo = <<~EOS
      noop
    EOS

    env = { "GIT_DIR" => testpath/"repo/.git/" }
    executable = bin/"interactive-rebase-tool"
    todo_file = testpath/"repo/.git/rebase-merge/git-rebase-todo"

    _, _, pid = PTY.spawn(env, executable, todo_file)
    Process.wait(pid)

    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal expected_git_rebase_todo, todo_file.read
  end
end
