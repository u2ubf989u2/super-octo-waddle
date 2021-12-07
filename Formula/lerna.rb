require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-4.0.0.tgz"
  sha256 "64330ffdb7b7d879e40ca2520028958b9d6daff34a32547ced138b5896633bd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e7264f3be53a6d765ed2578342a1e7909d39a99fb28ba431928fdfec6cd2955"
    sha256 cellar: :any_skip_relocation, big_sur:       "53885b6ebfeae441afa66d521667427dea0c4188f4ffb1cfe64e29639987d4a9"
    sha256 cellar: :any_skip_relocation, catalina:      "67e710cabaa7060f1ef2cf6cbafc8734daa93c4c21889a381b7551218e205b34"
    sha256 cellar: :any_skip_relocation, mojave:        "e32988735ca0475d93000c7a2d163289da595263c1d6d416321f9f84f1ce5f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8eec2ee70673451a8e23768860061667b0a1390557a7b936ab55f11cc7a7183"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
