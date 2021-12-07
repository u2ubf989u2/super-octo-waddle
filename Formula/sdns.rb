class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.1.7.tar.gz"
  sha256 "f7c809f61483a3235f820ba3ccab1816fc8a9e6174c644eda31840f76017781e"
  license "MIT"
  head "https://github.com/semihalev/sdns.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "21793de02e83d10ac51abae2ba85addcbac395b39ee37fc41ca8847974eec92b"
    sha256 cellar: :any_skip_relocation, big_sur:       "82ae1e7bea85f50fcf84de51fb0fb790faf88d0cefaf8532f587047e8fe842a5"
    sha256 cellar: :any_skip_relocation, catalina:      "b1dd23b40afd486a0343af0b6e2b738d5c4a19869484e01de28889e7abc6ae5b"
    sha256 cellar: :any_skip_relocation, mojave:        "aa9dd1a91d45ddcc4574ca51084f6d57885541d6e495230e2870e60bf1d2395a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab3f04ad735b11e42f8835db12b90e6fe493f2ced65e65a954ce53675819a76c"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/sdns</string>
            <string>-config</string>
            <string>#{etc}/sdns.conf</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/sdns.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/sdns.log</string>
          <key>WorkingDirectory</key>
          <string>#{opt_prefix}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    fork do
      exec bin/"sdns", "-config", testpath/"sdns.conf"
    end
    sleep(2)
    assert_predicate testpath/"sdns.conf", :exist?
  end
end
