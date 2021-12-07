class DcosCli < Formula
  desc "Command-line interface for managing DC/OS clusters"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/1.2.0.tar.gz"
  sha256 "d75c4aae6571a7d3f5a2dad0331fe3adab05a79e2966c0715409d6a2be2c6105"
  license "Apache-2.0"
  head "https://github.com/dcos/dcos-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f86f45ed4b5244b46a83cb5bf5bc5ac869dfbae3af926f175bee78a0ebd9b47a"
    sha256 cellar: :any_skip_relocation, big_sur:       "1391a435f38b3a70514d0ef7f0a20f19a2d7027e64cad5c1b413730a89aaec4f"
    sha256 cellar: :any_skip_relocation, catalina:      "3f64db455d356a65dbb8be7bce2346b9b8afec968082bdad1efafb174bbde1b8"
    sha256 cellar: :any_skip_relocation, mojave:        "759770809a74366f84721771b18702a3d27c9e6aa9099f25895200462df17ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac5309e878ba5fdbd922560053d8a730f3d13d90ba428c1676052d38300a7fa1"
  end

  depends_on "go" => :build

  def install
    ENV["NO_DOCKER"] = "1"
    ENV["VERSION"] = version.to_s

    on_macos do
      system "make", "darwin"
      bin.install "build/darwin/dcos"
    end
    on_linux do
      system "make", "linux"
      bin.install "build/linux/dcos"
    end
  end

  test do
    run_output = shell_output("#{bin}/dcos --version 2>&1")
    assert_match "dcoscli.version=#{version}", run_output
  end
end
