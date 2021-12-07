require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-3.2.1.tgz"
  sha256 "0e2222d593069c1d10c20e7954426c7b70a5c7c2d38a2ae8310c232a03e730c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1917b69a1707715ba84f5996a6aeb0657396fa519e9f4779a7c9d0286f258dc3"
    sha256 cellar: :any_skip_relocation, big_sur:       "3dd729e08d336c0beabb3a61334fdf730727abb79c1ee36d9459d7237fc27ce1"
    sha256 cellar: :any_skip_relocation, catalina:      "224cc9e37aff1c57337f28354eb9a0e56271740d1a1c7b58da4b00a432bc0dfe"
    sha256 cellar: :any_skip_relocation, mojave:        "c2d991caef7824c847786f66bfc7127caa0db131dd114b472858921110355d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd5a2b51e4e89e849164d91063e4fff81f8db6e01b71efd0637adc088b34c329"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    magnet_uri = <<~EOS.gsub(/\s+/, "").strip
      magnet:?xt=urn:btih:9eae210fe47a073f991c83561e75d439887be3f3
      &dn=archlinux-2017.02.01-x86_64.iso
      &tr=udp://tracker.archlinux.org:6969
      &tr=https://tracker.archlinux.org:443/announce
    EOS

    expected_output_raw = <<~EOS
      {
        "xt": "urn:btih:9eae210fe47a073f991c83561e75d439887be3f3",
        "dn": "archlinux-2017.02.01-x86_64.iso",
        "tr": [
          "https://tracker.archlinux.org:443/announce",
          "udp://tracker.archlinux.org:6969"
        ],
        "infoHash": "9eae210fe47a073f991c83561e75d439887be3f3",
        "name": "archlinux-2017.02.01-x86_64.iso",
        "announce": [
          "https://tracker.archlinux.org:443/announce",
          "udp://tracker.archlinux.org:6969"
        ],
        "urlList": []
      }
    EOS
    expected_json = JSON.parse(expected_output_raw)
    actual_output_raw = shell_output("#{bin}/webtorrent info '#{magnet_uri}'")
    actual_json = JSON.parse(actual_output_raw)
    assert_equal expected_json["tr"].to_set, actual_json["tr"].to_set
    assert_equal expected_json["announce"].to_set, actual_json["announce"].to_set
  end
end
