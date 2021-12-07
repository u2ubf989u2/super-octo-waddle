class Lighttpd < Formula
  desc "Small memory footprint, flexible web-server"
  homepage "https://www.lighttpd.net/"
  url "https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.59.tar.xz"
  sha256 "fb953db273daef08edb6e202556cae8a3d07eed6081c96bd9903db957d1084d5"
  license "BSD-3-Clause"

  livecheck do
    url "https://download.lighttpd.net/lighttpd/releases-1.4.x/"
    regex(/href=.*?lighttpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "83be5fc9ff54264e3a2ec2633259eb9121fc5fdc7bdd3f43c3319971bc9a6e97"
    sha256 big_sur:       "71ac008d18b324a770a9f39a5c8194d0526ab85e4491336f059206531f7f0868"
    sha256 catalina:      "bcc720caef8110766bad93f27016cac6443a000ab5de0cb7b231e8f01d3f1129"
    sha256 mojave:        "243daa151b9d0bc1fb6ac914eb807a78f219bbced3ed76f1cfbe1c319189bcbc"
    sha256 x86_64_linux:  "6560b99bcacc176a4240f1f0ee8579a95980bd1d21f1d65807255a0992e478d6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openldap"
  depends_on "openssl@1.1"
  depends_on "pcre"

  # default max. file descriptors; this option will be ignored if the server is not started as root
  MAX_FDS = 512

  def config_path
    etc/"lighttpd"
  end

  def log_path
    var/"log/lighttpd"
  end

  def www_path
    var/"www"
  end

  def run_path
    var/"lighttpd"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sbindir=#{bin}
      --with-openssl
      --with-ldap
      --with-zlib
      --with-bzip2
    ]

    # autogen must be run, otherwise prebuilt configure may complain
    # about a version mismatch between included automake and Homebrew's
    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"

    unless File.exist? config_path
      config_path.install "doc/config/lighttpd.conf", "doc/config/modules.conf"
      (config_path/"conf.d/").install Dir["doc/config/conf.d/*.conf"]
      inreplace config_path+"lighttpd.conf" do |s|
        s.sub!(/^var\.log_root\s*=\s*".+"$/, "var.log_root    = \"#{log_path}\"")
        s.sub!(/^var\.server_root\s*=\s*".+"$/, "var.server_root = \"#{www_path}\"")
        s.sub!(/^var\.state_dir\s*=\s*".+"$/, "var.state_dir   = \"#{run_path}\"")
        s.sub!(/^var\.home_dir\s*=\s*".+"$/, "var.home_dir    = \"#{run_path}\"")
        s.sub!(/^var\.conf_dir\s*=\s*".+"$/, "var.conf_dir    = \"#{config_path}\"")
        s.sub!(/^server\.port\s*=\s*80$/, "server.port = 8080")
        s.sub!(%r{^server\.document-root\s*=\s*server_root \+ "/htdocs"$}, "server.document-root = server_root")

        # get rid of "warning: please use server.use-ipv6 only for hostnames, not
        # without server.bind / empty address; your config will break if the kernel
        # default for IPV6_V6ONLY changes"
        s.sub!(/^server.use-ipv6\s*=\s*"enable"$/, 'server.use-ipv6 = "disable"')

        s.sub!(/^server\.username\s*=\s*".+"$/, 'server.username  = "_www"')
        s.sub!(/^server\.groupname\s*=\s*".+"$/, 'server.groupname = "_www"')
        s.sub!(/^server\.network-backend\s*=\s*"sendfile"$/, 'server.network-backend = "writev"')

        # "max-connections == max-fds/2",
        # https://redmine.lighttpd.net/projects/1/wiki/Server_max-connectionsDetails
        s.sub!(/^server\.max-connections = .+$/, "server.max-connections = " + (MAX_FDS / 2).to_s)
      end
    end

    log_path.mkpath
    (www_path/"htdocs").mkpath
    run_path.mkpath
  end

  def caveats
    <<~EOS
      Docroot is: #{www_path}

      The default port has been set in #{config_path}/lighttpd.conf to 8080 so that
      lighttpd can run without sudo.
    EOS
  end

  plist_options manual: "lighttpd -f #{HOMEBREW_PREFIX}/etc/lighttpd/lighttpd.conf"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/lighttpd</string>
          <string>-D</string>
          <string>-f</string>
          <string>#{config_path}/lighttpd.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{log_path}/output.log</string>
        <key>StandardOutPath</key>
        <string>#{log_path}/output.log</string>
        <key>HardResourceLimits</key>
        <dict>
          <key>NumberOfFiles</key>
          <integer>#{MAX_FDS}</integer>
        </dict>
        <key>SoftResourceLimits</key>
        <dict>
          <key>NumberOfFiles</key>
          <integer>#{MAX_FDS}</integer>
        </dict>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/lighttpd", "-t", "-f", config_path/"lighttpd.conf"
  end
end
