class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.9.0.tar.gz"
  sha256 "2b3e73f44741de1b22194a6f0090f8decf7155bffb43a67eb2801357b915b7db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b87769a43f961d015269b8e831a7603d66b4ea108fd35f59d91d683e4e6f6d08"
    sha256 cellar: :any_skip_relocation, big_sur:       "76c3f46ff28e6d77d0729ce61b1f48bd066ecff9a273371fe0063a3de233e448"
    sha256 cellar: :any_skip_relocation, catalina:      "0fa844540412203afe72fa34b057603845c363f52387e3ce80ec83ee1e1b06b3"
    sha256 cellar: :any_skip_relocation, mojave:        "ce2df3629c139b1266ebee47d57b0d539cf5faa9d056d51b4d0b1e4a756abcf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e35145d9d548fc94c67eb37baf9ba1ae5afa9b79efd9b7a84168a88c000cc907"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/tools/cli/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
