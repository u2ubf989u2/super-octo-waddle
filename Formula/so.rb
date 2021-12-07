class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/v0.4.3.tar.gz"
  sha256 "4e82cb8f6d31435eec03a74d0ea4297eb28ce3ee75d4612ca5b2233c27e19c2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a1239eda940abb6aedef2fb2148e70ddad9ccf30e733ea1db043a1f3e35377ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c871ccb23c125efc71cd7fbd422a5c53ee0b66154a91fe28a2fb2a39f38c4c8"
    sha256 cellar: :any_skip_relocation, catalina:      "826d559e0fe079bbec1c8a43cbde4bd44a4d54d2d36d8a0c19e6ff43544d30b0"
    sha256 cellar: :any_skip_relocation, mojave:        "061e084d661c9b1eddca4329492935a3ec1a1f3880399d7a21c63b58c8763be6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c4cdfc4c0a1464c8869981da9aa1d5f65562201446cb19577be7dcc60b035f8"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # try a query
    opts = "--search-engine stackexchange --limit 1 --lucky"
    query = "how do I exit Vim"
    env_vars = "LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm"
    input, _, wait_thr = Open3.popen2 "script -q /dev/null"
    input.puts "stty rows 80 cols 130"
    input.puts "env #{env_vars} #{bin}/so #{opts} #{query} 2>&1 > output"
    sleep 3

    # quit
    input.puts "q"
    sleep 2
    input.close

    # make sure it's the correct answer
    assert_match ":wq", File.read("output")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
