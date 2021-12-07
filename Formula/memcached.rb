class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.9.tar.gz"
  sha256 "d5a62ce377314dbffdb37c4467e7763e3abae376a16171e613cbe69956f092d1"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c18d3d914a52d960a1ad33be43e2ebc35faaf3aca9b2db0fb682989cb5c57693"
    sha256 cellar: :any, big_sur:       "147059ed93b823666bfd59911d7c2ccc51081b16a49ac72edf50efe7beedadc7"
    sha256 cellar: :any, catalina:      "b816ef4b112d8a01b0b6c1fbf05b2eb4577640e2712ad6c0ce0e87899e246d9a"
    sha256 cellar: :any, mojave:        "e307cfaa852e8fcda1210aadbfa07cb0331640ec7c930e03ac0cc2e98736d70d"
  end

  depends_on "libevent"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-coverage", "--enable-tls"
    system "make", "install"
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/memcached/bin/memcached"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/memcached</string>
          <string>-l</string>
          <string>localhost</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
      </plist>
    EOS
  end

  test do
    pidfile = testpath/"memcached.pid"
    # Assumes port 11211 is not already taken
    if !OS.mac? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      system bin/"memcached", "-u", ENV["USER"], "--listen=localhost:#{free_port}", "--daemon", "--pidfile=#{pidfile}"
    else
      system bin/"memcached", "--listen=localhost:#{free_port}", "--daemon", "--pidfile=#{pidfile}"
    end
    sleep 1
    assert_predicate pidfile, :exist?, "Failed to start memcached daemon"
    pid = (testpath/"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end
