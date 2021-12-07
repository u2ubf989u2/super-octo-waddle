class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.9.2.tar.gz"
  sha256 "0f064d0ea9f3d8bbcd84c5e6a85243738bdb6f49d059f589fd6928c64ea6fb64"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "70bc227889f14cfb1d7efa1ae2bb25deee2c1fb244a9088b4174451136ab11c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "eaae40cb4f0df07de67f3049efc4864d8a40e6472d65a62e2b073fa4cc4d5480"
    sha256 cellar: :any_skip_relocation, catalina:      "0177d63b6d2b85713ddc8f5154a903ec9d8adbe68e863997276fd25c57872a3e"
    sha256 cellar: :any_skip_relocation, mojave:        "91cf4c35f36accf188f03398da452570ce8879b629822c104e5c4db85e4eb44e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e36dbcf390075272846cbe1c1290ee649e547d732cd29ceecc3bc025d9fff0ff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
