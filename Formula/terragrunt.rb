class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.29.1.tar.gz"
  sha256 "f33da3e49d3d6b8cb989a07961c2192026bc9475e2a839070ee013c4dbc19f37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "029ab0b0b365f90bc0f8b2bed6f61eaf2e4628fb95c4b6f638582ffe720e862c"
    sha256 cellar: :any_skip_relocation, big_sur:       "61adb7bd362ed87551c6e760106629433a757cd1258d0d0dac88ad260f47da76"
    sha256 cellar: :any_skip_relocation, catalina:      "d682b0e2a419767aba4ed9b8cda6845890f99aa254347884357c8e55122307fc"
    sha256 cellar: :any_skip_relocation, mojave:        "a23f9088151341d9f0d5384a5d5a9f01f4cb666b3dd9803438b97518757aa74d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d3a29dbd3ce4a2931044b0d13a69045ed32bc652a32b9ef8b48469957cde18d"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
