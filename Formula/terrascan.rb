class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://www.accurics.com/products/terrascan/"
  url "https://github.com/accurics/terrascan/archive/v1.5.1.tar.gz"
  sha256 "0ef2490c711fc089e05a926ba1935be62f60bd20b7226906e207382aaae48f84"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "420232aa61cfa954e467fe5eb7a666a8f9c3758600ec635daf3d89126ea4c9ce"
    sha256 cellar: :any_skip_relocation, big_sur:       "3258a5aa80903392c95fc08ddf1f78e0a785b7800777e4de1df76d6e139af1cb"
    sha256 cellar: :any_skip_relocation, catalina:      "68b802211d0c7bec0def0c699d9960ea51d93ae1bc3248b3d40aab633fc510f6"
    sha256 cellar: :any_skip_relocation, mojave:        "f0082583149595cee580f8d7af1b33006ce5579073e552ed9e18dfd5f9caab21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d88288901559793384855c992be76622cf4879310fe996e5c58b6f34eaaec22a"
  end

  depends_on "go" => :build

  # Fixes version, remove in next release.
  patch do
    url "https://github.com/accurics/terrascan/commit/d8fd9c4bae5b12ffbe8d7c7e1a1d67042dfd8edf.patch?full_index=1"
    sha256 "994c4bc35899286edf48baad868b7482e5dc1090ad8a7dceffe25e4df438ca2f"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/terrascan"
  end

  test do
    (testpath/"ami.tf").write <<~EOS
      resource "aws_ami" "example" {
        name                = "terraform-example"
        virtualization_type = "hvm"
        root_device_name    = "/dev/xvda"

        ebs_block_device {
          device_name = "/dev/xvda"
          snapshot_id = "snap-xxxxxxxx"
          volume_size = 8
        }
      }
    EOS

    expected = <<~EOS
      \tPolicies Validated  :\t158
      \tViolated Policies   :\t0
      \tLow                 :\t0
      \tMedium              :\t0
      \tHigh                :\t0
    EOS

    assert_match expected, shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")

    assert_match "version: v#{version}", shell_output("#{bin}/terrascan version")
  end
end
