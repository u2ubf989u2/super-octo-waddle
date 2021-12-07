class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.74",
    revision: "06016bfcd98fa546f81a0d3bbbc119ffcab0f132"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56c061986eaa752d7ebec1fa0bdef6b3df1fdf021fa95947175fdb80af00e591"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c98f6d2d67dd4b1aa4a99848f66febc922050357550b5781da7b4279add0d79"
    sha256 cellar: :any_skip_relocation, catalina:      "51fd6d3db345843fd9489e31ddf43afbd3d989e68ff985c8169ed6a9460a72f8"
    sha256 cellar: :any_skip_relocation, mojave:        "8ffc51dd1aee1530a84bf3eae52170e790bf3c63c7ba8587e51f06d48ddc7cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dce99e83b6d21046f5b457b1125d4c2972c6afe9a9a48812a21ce07f2c41737a"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "metas"
    system "go", "build", *std_go_args(ldflags: "-X github.com/aliyun/aliyun-cli/cli.Version=#{version}"),
                          "-o", bin/"aliyun", "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
