class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.3.tar.gz"
  sha256 "c65d70fd9bbfd65d74676c36ce3b234c85ad6b8b576e4358dfb9ec2adb773b50"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f6ba9b6100de3184814d8e0f25d6e1a9103654614a923c1189319d174a1f057"
    sha256 cellar: :any_skip_relocation, big_sur:       "81f7ea6554ebc5cd72909103ffeb23b080b4268a7fa5875b50caa5eb2386a6fd"
    sha256 cellar: :any_skip_relocation, catalina:      "dbef942387e118d4d9e6c17e5b2a2a6f6978bb68df697d3afc1f44aecc8c6b5e"
    sha256 cellar: :any_skip_relocation, mojave:        "d4f87a6e7f6af82f22a52bd01f44167641c2090ca7ebde2a86557b9b02880f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c60abadaaf87b2cdb6ede5d68a29204fab1cca4a02eaedfabe4d759b8f94ba2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
