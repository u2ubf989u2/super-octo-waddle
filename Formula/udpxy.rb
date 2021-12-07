class Udpxy < Formula
  desc "UDP-to-HTTP multicast traffic relay daemon"
  homepage "http://www.udpxy.com/"
  url "http://www.udpxy.com/download/1_23/udpxy.1.0.23-12-prod.tar.gz"
  mirror "https://fossies.org/linux/www/udpxy.1.0.23-12-prod.tar.gz"
  version "1.0.23-12"
  sha256 "16bdc8fb22f7659e0427e53567dc3e56900339da261199b3d00104d699f7e94c"

  livecheck do
    url "http://www.udpxy.com/download/1_23/"
    regex(/href=.*?udpxy[._-]v?(\d+(?:\.\d+)+-\d+)-prod\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f6dd0e52a15d87cbdfc83caaf1fa892344c098add32f94243fa59bef0b6d9831"
    sha256 cellar: :any_skip_relocation, big_sur:       "989ff2e839f119d27e7df16ef1ed0cd439db78caa79be19662df3d548a3fc139"
    sha256 cellar: :any_skip_relocation, catalina:      "48a44c1a8510793fe0e878da79ac3a94953b3c13ecfe2dd4f338cecc17d30406"
    sha256 cellar: :any_skip_relocation, mojave:        "37defc78c8d90754343c9d0c1b69bf1939ba081c42868daa41572551f5d60e4a"
    sha256 cellar: :any_skip_relocation, high_sierra:   "46de795b585d88c658554fb943931885db85d75c7f838d9db6d11d98e46538d0"
    sha256 cellar: :any_skip_relocation, sierra:        "ee35787b2877b8ac1a9fa967e9f8fbf466f8c107e28cc61fee59c26aef9bf44d"
    sha256 cellar: :any_skip_relocation, el_capitan:    "0d4a899340bdee7f4497d68fe3bc59213ad83382d205aa08ada871d9d08c010d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "890386c37032bad683813bad94554b5ef47d5c59fa8e6af7f3d5136f2e02bd98"
  end

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=''"
  end

  plist_options manual: "udpxy -p 4022"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/udpxy</string>
          <string>-p</string>
          <string>4022</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
      </plist>
    EOS
  end
end
