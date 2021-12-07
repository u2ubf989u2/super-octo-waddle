class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.7.1.tar.gz"
  sha256 "f22a178eac80ec515712f660e839002225fe836aa129c3505117124e6ee01f52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "317fc1951dd0b9bb6189b655d8113dea778d62f0fc08239ac5087e1d8a03ab97"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4432c4e624ea2fb81a8e9b38c9e735817d52fcedcf85bb7bc659caba9644ed1"
    sha256 cellar: :any_skip_relocation, catalina:      "f6c0ebeba9b77585d6d640e52acf0e8dfc91bd0238c631c71a2928d9a575cc1a"
    sha256 cellar: :any_skip_relocation, mojave:        "801643a559273a9431f6beb66aeee94aa66aa120b8058ae9cae809e221f59f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0370fdce87d9c79857b0c7e79afe17f0fd8df54199aa4e324a0f581df4d3c447"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/cloudskiff/driftctl/build.env=release
      -X github.com/cloudskiff/driftctl/pkg/version.version=v#{version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "bash")
    (bash_completion/"driftctl").write output

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "zsh")
    (zsh_completion/"_driftctl").write output

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "fish")
    (fish_completion/"driftctl.fish").write output
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/driftctl version")
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
