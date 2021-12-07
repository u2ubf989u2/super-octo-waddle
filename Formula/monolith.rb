class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.4.1.tar.gz"
  sha256 "d68980bd5ade841f41e0d35447f9c299c82118eef2d291c2c07063086a18de0d"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "996d71e5f7797a1eb179bd76bac7e31291b6f28c5f23f02768ba79c7277f64e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "d07e07add80e0aa3cc0566975ac855f995aec1468b317a5368f227d691e4e42a"
    sha256 cellar: :any_skip_relocation, catalina:      "0908d3320bd8ecf7ad6ce7851fcd4abe1d7215f16f0a54420560067b4faa27d7"
    sha256 cellar: :any_skip_relocation, mojave:        "c42d906004f7b6b15b9c29ba70424bc77bf428a363b4c28779172e81c50e50a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d660cbc4ad2593fb4dba836ff08250be2d2487c2d2ac0d4ca263009353bd051"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
