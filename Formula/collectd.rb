class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  url "https://collectd.org/files/collectd-5.12.0.tar.bz2"
  sha256 "5bae043042c19c31f77eb8464e56a01a5454e0b39fa07cf7ad0f1bfc9c3a09d6"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "ae24e993f2be3d7618d2e7fa44862e7874c5b6d10a9891ae26767ec050f36f43"
    sha256 big_sur:       "e4de278042d172443ddee7f7260ef14022a9e9632b8c4d212c27f76ef1eb184c"
    sha256 catalina:      "ea61777a4d32690b2a1ddd53081f0888f7c83066cc9e0e5482f604e61c981fd9"
    sha256 mojave:        "9efc5c99db4239be93afbad141938c697cc36c1442e117d92960a5265cfc57cf"
    sha256 high_sierra:   "850edf925fa233181c03c7157cf6c89fca53906f930c511febd283358242f688"
    sha256 x86_64_linux:  "8044bc6f901ff94f1c70ef6b65b1d85e3b89e1c4fc3d1cffeeee282786c45747"
  end

  head do
    url "https://github.com/collectd/collectd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libtool"
  depends_on "net-snmp"
  depends_on "riemann-client"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "perl"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --disable-java
      --enable-write_riemann
    ]

    system "./build.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/sbin/collectd -f -C #{HOMEBREW_PREFIX}/etc/collectd.conf"

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
            <string>#{sbin}/collectd</string>
            <string>-f</string>
            <string>-C</string>
            <string>#{etc}/collectd.conf</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/collectd.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/collectd.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    log = testpath/"collectd.log"
    (testpath/"collectd.conf").write <<~EOS
      LoadPlugin logfile
      <Plugin logfile>
        File "#{log}"
      </Plugin>
      LoadPlugin memory
    EOS
    begin
      pid = fork { exec sbin/"collectd", "-f", "-C", "collectd.conf" }
      sleep 1
      assert_predicate log, :exist?, "Failed to create log file"
      assert_match "plugin \"memory\" successfully loaded.", log.read
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
