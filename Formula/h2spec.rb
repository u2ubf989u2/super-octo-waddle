class H2spec < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/summerwind/h2spec"
  url "https://github.com/summerwind/h2spec.git",
    tag:      "v2.6.0",
    revision: "70ac2294010887f48b18e2d64f5cccd48421fad1"
  license "MIT"
  head "https://github.com/summerwind/h2spec.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90d9e00cce2bd7659510bb75cc6735b94d7488207a4aeb665fd9aedae3ed8ca1"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee24c3ab807d25dc92116e1b794d319365b7ad7a801f9ef9089f2992844673aa"
    sha256 cellar: :any_skip_relocation, catalina:      "c585fbaa7e8d101d280edafce5e26b4df57a1ac8ddbd7327f1efdc07d0ac17a0"
    sha256 cellar: :any_skip_relocation, mojave:        "83ba531c3cfffe083ffc687cff9c7ad41eb30c6745994a6eca2bc9f245e7f00e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74f9da5152bf7abfc389c94b8e91c36a67dfe055e016163c1b6df6685add9e93"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_short_head
    ldflags = %W[
      -s -w
      -X main.VERSION=#{version}
      -X main.COMMIT=#{commit}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "./cmd/h2spec"
  end

  test do
    assert_match "1 tests, 0 passed, 0 skipped, 1 failed",
      shell_output("#{bin}/h2spec http2/6.3/1 -h httpbin.org 2>&1", 1)

    assert_match "connect: connection refused",
      shell_output("#{bin}/h2spec http2/6.3/1 2>&1", 1)
  end
end
