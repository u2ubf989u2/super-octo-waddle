class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.94.0.tar.gz"
  sha256 "4b79e88a73d006ba22fe8f3284f89db172c7f12a6f046dd82058e051f1a27b9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c51a6aef4e0cad28ee84b2cd16ba4eeb1ea989c9bf633fee824b4b6c105154ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "460fa7896c5696917b52b0646dbb93211b71d892a0ff7c376e3bad522073f34d"
    sha256 cellar: :any_skip_relocation, catalina:      "71dab1c46819603fc8deb6af47cd7a852eef75338550305131a537500e9eeedb"
    sha256 cellar: :any_skip_relocation, mojave:        "5e007c7ddfc4caa53fe7e0d471f48039c60ed67dc9e6a0779de94fcf63ac331b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cdc827ccc7a3865738ea1bd381de91bc00aaec1f22f9f8f3b7ccbda2e85ac12"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz -v 2>&1")
    (testpath/"config.toml").write <<~EOS
      proto = "greeter.proto"
      call = "helloworld.Greeter.SayHello"
      host = "0.0.0.0:50051"
      insecure = true
      [data]
      name = "Bob"
    EOS
    assert_match "open greeter.proto: no such file or directory",
      shell_output("#{bin}/ghz --config config.toml 2>&1", 1)
  end
end
