class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.8.tar.gz"
  sha256 "ed59dedde11d5134c96456707a0984c3f23a86a63b979e1fc70b9c6d0ad241cd"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d07b4d1e5b238273889abbfe99109eb203cf6585200e6d3daf1b0128fa84b85"
    sha256 cellar: :any_skip_relocation, big_sur:       "d961e39a305f6f9b189b04c1956c3a271853bd939495856b1932cb22b620ec5b"
    sha256 cellar: :any_skip_relocation, catalina:      "9190f9c9b6081905b0d0dc2a6603b2afc89e0040fd5129cab50f0a511d780b9f"
    sha256 cellar: :any_skip_relocation, mojave:        "1054c0231d29146d71c3aac2a33ae398e7256ab0e356daf0ba8ef4c7d0f59457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e08762b352e94d6adfac4bcec192e79e8a91d1b0aa231ea118dc005b7916decf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
