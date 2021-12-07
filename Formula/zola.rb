class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.13.0.tar.gz"
  sha256 "84c20cf5c851a465266c5cc343623752102c53929f6da31b2a4ce747a87c5c23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3578486fdec183e82c51c5c489e9a78f9f997cbc05ebcb541fc60059163a9b44"
    sha256 cellar: :any_skip_relocation, big_sur:       "d4ecc13ce735449bbba5e83c57617ce03b939e69493e9e65d2c23a294ff6ea2e"
    sha256 cellar: :any_skip_relocation, catalina:      "aaccf8b7fe4e9256c38021902dcffca291d02de1ac662ce0219a1fca0e8fac0a"
    sha256 cellar: :any_skip_relocation, mojave:        "d883c9f8439ee6226f1392f1350ce974b4312367e026c1ae756fd7c1765d5bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "947d58f5dbd59c37cf328c4a8a96b2c2ce5e2b461343b2c6161c70805d571f92"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    on_linux do
      ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    end
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/zola.bash"
    zsh_completion.install "completions/_zola"
    fish_completion.install "completions/zola.fish"
  end

  test do
    system "yes '' | #{bin}/zola init mysite"
    (testpath/"mysite/content/blog/index.md").write <<~EOS
      +++
      +++

      Hi I'm Homebrew.
    EOS
    (testpath/"mysite/templates/page.html").write <<~EOS
      {{ page.content | safe }}
    EOS

    cd testpath/"mysite" do
      system bin/"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.</p>",
      (testpath/"mysite/public/blog/index.html").read.strip
  end
end
