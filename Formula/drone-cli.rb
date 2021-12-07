class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
      tag:      "v1.2.4",
      revision: "6f4c96818cf659f3f1bc44498e18ea93313d62ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "5eb1960f5073fe2dbe0cebb658c9b31b905d9b77f9dea41a1e65cb01331875e9"
    sha256 cellar: :any_skip_relocation, catalina:     "b0f855c942279e6f28de3fd52611f6e88f5d9a7feb008f49d1f66a00752f2b25"
    sha256 cellar: :any_skip_relocation, mojave:       "1d6f199fd82f2da5bef17f40640011b69c3c1ba67816c2db6f5bbcbb1da52ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "af2957381fb2fe8dae4ed3d0b2f42d0d012321c58648d701f4592ed5821ddd4d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
           bin/"drone", "drone/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
