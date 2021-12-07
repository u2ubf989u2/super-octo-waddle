class Googler < Formula
  include Language::Python::Shebang

  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v4.3.2.tar.gz"
  sha256 "bd59af407e9a45c8a6fcbeb720790cb9eccff21dc7e184716a60e29f14c68d54"
  license "GPL-3.0-or-later"
  head "https://github.com/jarun/googler.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34d74100c542d7674e393c1eeb0ddfc807d2e9e46c130777b16b85ed6a519551"
    sha256 cellar: :any_skip_relocation, big_sur:       "cdb78a7ecc2656018a8ecaedf15230a9bb4e58eb5a9f405b99da297f1423f58d"
    sha256 cellar: :any_skip_relocation, catalina:      "27e27a67d1bca7dd2a05cc8dfb080c89c8871f92df951b95054068667902fa95"
    sha256 cellar: :any_skip_relocation, mojave:        "49f64f0b333b9f65e18d6bc0ba5171e8e52a3df809f8e568207f343cd6823029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6e8740fb3b0d70e162010d97e5418359d33399e80905c6e734f9c292d0fc09f"
  end

  depends_on "python@3.9"

  def install
    rewrite_shebang detected_python_shebang, "googler"
    system "make", "disable-self-upgrade"
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/googler-completion.bash"
    fish_completion.install "auto-completion/fish/googler.fish"
    zsh_completion.install "auto-completion/zsh/_googler"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "Homebrew", shell_output("#{bin}/googler --noprompt Homebrew")
  end
end
