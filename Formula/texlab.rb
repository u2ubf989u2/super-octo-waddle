class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v2.2.2.tar.gz"
  sha256 "04978b118b455607b5debd0a886f0728ca6c498289d2a0c60d8f83b316dc5ebc"
  license "GPL-3.0"
  head "https://github.com/latex-lsp/texlab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30a8a884b0ee5b2d4199557ee9f2a03f747925fed2cc4846f7d82afe87633ccb"
    sha256 cellar: :any_skip_relocation, big_sur:       "e09837b34a494d6bbf2be7e6e7e97c11ef3b4058f37ed711526ed982bf2c6aa6"
    sha256 cellar: :any_skip_relocation, catalina:      "550652fb9f61859242d41abf46089fe3b4ffffd82880864e2106ae493d66e4f3"
    sha256 cellar: :any_skip_relocation, mojave:        "66cfcb0de8c45b10e15e906195f68736f47ec3165dd6eef48c6fa48c560c966e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e612e4e9f71fd7233786ddd8545ff35a7f7623abd96a03f7f723bd1bd37c1e36"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    begin
      stdin, stdout, _, wait_thr = Open3.popen3("#{bin}/texlab")
      pid = wait_thr.pid
      stdin.write <<~EOF
        Content-Length: 103

        {"jsonrpc": "2.0", "id": 0, "method": "initialize", "params": { "rootUri": null, "capabilities": {}}}

      EOF
      assert_match "Content-Length:", stdout.gets("\n")
    ensure
      Process.kill "SIGKILL", pid
    end
  end
end
