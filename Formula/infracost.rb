class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.8.5.tar.gz"
  sha256 "2772bbef46b0cf4c1e05eec093379649d8e1f0a43de2758be7df32cb331244c8"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f274abfc4391462fa4682b33cda70b0451affb0f73370c4c454a777edcc6ae17"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a31d709b77770ee0b12437794adad3df7304473829e831a533416ee0f9b6b28"
    sha256 cellar: :any_skip_relocation, catalina:      "9a31d709b77770ee0b12437794adad3df7304473829e831a533416ee0f9b6b28"
    sha256 cellar: :any_skip_relocation, mojave:        "9a31d709b77770ee0b12437794adad3df7304473829e831a533416ee0f9b6b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70780e2c04dab5e27e69d493e893283552ab320e0d9a99130f3fb408a7fcb2d6"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
