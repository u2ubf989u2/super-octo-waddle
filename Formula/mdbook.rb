class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.7.tar.gz"
  sha256 "5adbea6d60a7d4ec13dcf13b451336ce7127c2e872ea0d8482e9bb73f6f61dfd"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "07408068a08c94678cb5da3406a52417e3d6d5061dfdb06d953f5d06f7b15c8e"
    sha256 cellar: :any_skip_relocation, big_sur:       "f309c7528d07359561169bf3336177da55962aeaa9a4c0caa5b362353511b797"
    sha256 cellar: :any_skip_relocation, catalina:      "c8e6c03d6587fd70e2bbdf53a7d034677fdd9d4020d777376ebb357ae8707bba"
    sha256 cellar: :any_skip_relocation, mojave:        "8b5bbca6bd46d0ff37b4849eab4fd94f23bae63433879e20f565c37fa29b3769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6214c8773808e76196222abf30703408a72b0a28c7d31c52eb9dad1b6a1dda8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system "#{bin}/mdbook", "build"
  end
end
