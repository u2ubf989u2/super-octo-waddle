class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.11.0.tar.gz"
  sha256 "95ebb3ac0215bf43d6cdf17d320e22601a3a7228d979e5a6cbaf8c4082f9ad22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "492bd653adbb35233590493af812a2d2e6f087707185670374b5f4b28d0a90a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "534badd4c595a32338bfa1627cf8530b5eec96ac24388e5b6080e57e89f3bd19"
    sha256 cellar: :any_skip_relocation, catalina:      "d8ef7bc535c99083c1e2426ddb99fa107a8b287f389bfd5b882c9239762e17a7"
    sha256 cellar: :any_skip_relocation, mojave:        "6bd79dcc54fe7c42a7834cbde657b4b96edf2fa5a8121536b7f17fe9a6a8cfe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee976541eb70fbe75288b9267bcc7e595d70fc978d0bfdf3732c7c83430f2fc3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.Version=#{version}"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
