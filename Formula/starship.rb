class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.53.0.tar.gz"
  sha256 "42353977aba8cf711591381d713814140d9bb602015e8d6c589ef1a42d116ae1"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e0869388fe25d181da663363e4cda5085399ba250bf1bd33e9366c0ea40c5e38"
    sha256 cellar: :any_skip_relocation, big_sur:       "12f1ff2524fb52afc6be976905975d2b684145a1bd65d4802faad10696925a21"
    sha256 cellar: :any_skip_relocation, catalina:      "af8151d2b68793c7f9b4a65d6acb061444468227148b3e7a9ecb5032b7879dbf"
    sha256 cellar: :any_skip_relocation, mojave:        "720ff7cd94703500f7f7286ea11e2f38bed529f3545270e280bf277c780fc3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83d6aa6b01a8dd162a92fc5ff66e084447d9486bf8538bd53b6cfddf2d99d621"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", "--features", "notify-rust", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/starship", "completions", "bash")
    (bash_completion/"starship").write bash_output

    zsh_output = Utils.safe_popen_read("#{bin}/starship", "completions", "zsh")
    (zsh_completion/"_starship").write zsh_output

    fish_output = Utils.safe_popen_read("#{bin}/starship", "completions", "fish")
    (fish_completion/"starship.fish").write fish_output
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
