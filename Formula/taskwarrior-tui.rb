class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.18.tar.gz"
  sha256 "3d1e5777d0112dfd0be4606a4d96022b10b1e8543ea8dc81436aa9d10a0a6ade"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7edbf385187a88952031a0c9432087856c6d4122d3885be9ebfefaf29276e8dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "645866afcb6b9529fd52d81b48a698f2ecbbd7d22f100ffc50eb478651e4a5c8"
    sha256 cellar: :any_skip_relocation, catalina:      "8f5de2b89e72db980e8ac716521a84a73e3ebed4da28f855d41fc5dc944a9af9"
    sha256 cellar: :any_skip_relocation, mojave:        "868ea7ee96017bf46724bf3396cf6ad117317e73763c1cf8af1d306413574e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e5b41088947a20b51ce3e85f4f7590a2010326904054df82515b9027d4288f3"
  end

  depends_on "pandoc" => :build unless Hardware::CPU.arm?
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    unless Hardware::CPU.arm?
      args = %w[
        --standalone
        --to=man
      ]
      system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
      man1.install "taskwarrior-tui.1"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
