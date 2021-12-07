class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v0.8.3",
      revision: "6fa4a5791cd70ec5eb2f0abaa0c09b7993c2fd34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf164602266e8f82f9ddb8ec2491cf75b4b6adebc5cf3d95ace5f5b853963a8e"
    sha256 cellar: :any_skip_relocation, big_sur:       "6aa5977df9b542dad5fe9acc8720e68e56f8a354a840bfadc9fccc0516403333"
    sha256 cellar: :any_skip_relocation, catalina:      "09a93bca5d2d5cd90202d908d27faae8471288e4a37f506164784cbe2ddcade2"
    sha256 cellar: :any_skip_relocation, mojave:        "dc831b364288ee772128a380990d5b0db3b0330b2cd83fb6da53147c848e324f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a917ca14c367a1d78e43590bcc39660ac6f1b6d25ff60d527d09c1f98d9dd41"
  end

  depends_on "go" => :build

  def install
    ENV["VERSION"] = "v"+version
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version: v#{version};", shell_output("#{bin}/osm version 2>&1")
  end
end
