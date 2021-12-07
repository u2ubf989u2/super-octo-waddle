class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.net/"
  url "https://github.com/nzbget/nzbget/releases/download/v21.0/nzbget-21.0-src.tar.gz"
  sha256 "65a5d58eb8f301e62cf086b72212cbf91de72316ffc19182ae45119ddd058d53"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/nzbget/nzbget.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 big_sur:      "0e6628877593d52315c0390d9c92dfef1673806ff99eb4bb76ab7c0ceb9ef13f"
    sha256 catalina:     "ecf6a149b5f521f683f5d2fda434b5dc74191a5bae5e0c0f0879c4c6fbe60510"
    sha256 mojave:       "c61cd9afc8d82e05e1a755552de7f056147023fc1569c51567b9b3f1739c9979"
    sha256 x86_64_linux: "e3f5c2368aad7a350872299396db4e5d990012f755c84fcadaf7ead9ffee5cb4"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    ENV.cxx11

    # Fix "ncurses library not found"
    # Reported 14 Aug 2016: https://github.com/nzbget/nzbget/issues/264
    if OS.mac?
      (buildpath/"brew_include").install_symlink MacOS.sdk_path/"usr/include/ncurses.h"
      ENV["ncurses_CFLAGS"] = "-I#{buildpath}/brew_include"
      ENV["ncurses_LIBS"] = "-L/usr/lib -lncurses"
    else
      ENV["ncurses_CFLAGS"] = "-I#{Formula["ncurses"].opt_include}"
      ENV["ncurses_LIBS"] = "-L#{Formula["ncurses"].opt_lib} -lncurses"
    end

    # Tell configure to use OpenSSL
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-tlslib=OpenSSL"
    system "make"
    ENV.deparallelize
    system "make", "install"
    pkgshare.install_symlink "nzbget.conf" => "webui/nzbget.conf"

    # Set upstream's recommended values for file systems without
    # sparse-file support (e.g., HFS+); see Homebrew/homebrew-core#972
    if OS.mac?
      inreplace "nzbget.conf", "DirectWrite=yes", "DirectWrite=no"
      inreplace "nzbget.conf", "ArticleCache=0", "ArticleCache=700"
    end

    etc.install "nzbget.conf"
  end

  plist_options manual: "nzbget"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/nzbget</string>
          <string>-c</string>
          <string>#{HOMEBREW_PREFIX}/etc/nzbget.conf</string>
          <string>-s</string>
          <string>-o</string>
          <string>OutputMode=Log</string>
          <string>-o</string>
          <string>ConfigTemplate=#{HOMEBREW_PREFIX}/opt/nzbget/share/nzbget/nzbget.conf</string>
          <string>-o</string>
          <string>WebDir=#{HOMEBREW_PREFIX}/opt/nzbget/share/nzbget/webui</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    (testpath/"downloads/dst").mkpath
    # Start nzbget as a server in daemon-mode
    system "#{bin}/nzbget", "-D", "-c", etc/"nzbget.conf"
    # Query server for version information
    system "#{bin}/nzbget", "-V", "-c", etc/"nzbget.conf"
    # Shutdown server daemon
    system "#{bin}/nzbget", "-Q", "-c", etc/"nzbget.conf"
  end
end
