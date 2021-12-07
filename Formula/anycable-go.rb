class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.0.5.tar.gz"
  sha256 "3fd4bef8732a7db0a0549b9eefd9f1ce2d295e6fa80e203bf68d6ffbcde2385a"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa6fef9beee0168cfd2add48f709ff4212fb2aa6e31839c8a973f0057fc5789b"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e5fde328e13ccb177d0b49f6849f1709513012f1369eed52c54b521cd8c8179"
    sha256 cellar: :any_skip_relocation, catalina:      "ce4661c31905e67fdebc3f40f62bb35dc627bdf81520459814db3013eaea5cc2"
    sha256 cellar: :any_skip_relocation, mojave:        "e906e9164d74a2d04c2e35ff7034e7bb7855d42f112f8b9c36b4b72152c92ca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45f7c42216229126abd7afafc154fb4abd74302d330dd51fdf341213cb33bdf5"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable-go/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable-go/utils.version=#{version}"
    end

    system "go", "build", "-mod=vendor", "-ldflags", ldflags.join(" "), *std_go_args,
                          "-v", "github.com/anycable/anycable-go/cmd/anycable-go"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/anycable-go --port=#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
