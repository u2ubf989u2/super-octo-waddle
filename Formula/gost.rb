class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  url "https://github.com/ginuerzh/gost/archive/v2.11.1.tar.gz"
  sha256 "d94b570a7a84094376b8c299d740528f51b540d9162f1db562247a15a89340bf"
  license "MIT"
  head "https://github.com/ginuerzh/gost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f90ea396927ac88ed90a566a8c3c76b7f794886508d8721500f23a6e89c68379"
    sha256 cellar: :any_skip_relocation, big_sur:       "7622f651be0def2be1b80cf0a290f0b42d87deee3107488ae0a13ba4a0cf6799"
    sha256 cellar: :any_skip_relocation, catalina:      "4669c79b11e368446e14667c237c710b05e69b2be23a699fe7e4d9355765c063"
    sha256 cellar: :any_skip_relocation, mojave:        "fe984a0b5d0323ddb2306a078265b246c751c0dc08d0f14cbe0ddb0c00293f13"
    sha256 cellar: :any_skip_relocation, high_sierra:   "6db1c66d9a848ea55930dfb17fc0da9ec64a3e053631a29667026d58a34c2246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "555067d946e79a916ff142c08a2d8cb5fb792a8d7d6985759cb07a691c6fc30f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gost"
    prefix.install "README_en.md"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    fork do
      exec "#{bin}/gost -L #{bind_address}"
    end
    sleep 1
    assert_match "HTTP/2 200", shell_output("curl -I -x #{bind_address} https://github.com")
  end
end
