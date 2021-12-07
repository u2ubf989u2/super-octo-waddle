class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.5.0.tar.gz"
  sha256 "766fa180c0d95cdbaaf0383c0f1f5b9129643a30166155cdab30922ebfbbee7d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "33245ce1d84b826a7d28e1e6e6c281225a5d3d71339551fccaa0ffd344d139f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "eceda9d279a8f8eeece5564e667bd3e4ca1f9d3494f49096afd69e6dba1f19f4"
    sha256 cellar: :any_skip_relocation, catalina:      "a9dff2fe576fee17ff9fc8b1f2d2b65acbdae08d188aaf6903b7ec87cc64c0f4"
    sha256 cellar: :any_skip_relocation, mojave:        "ae8fcb7bbecff876d782688690af627e5bca8840e92d296f355bef5f248c5f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a7697e3ba5cc3b38537e436aae1774ed252e02d4be2f4bcab79904a2ba56bc0"
  end

  depends_on "go" => :build
  depends_on "shadowsocks-libev" => :test

  def install
    system "go", "build", *std_go_args
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/clash/bin/clash"

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
                <string>#{opt_bin}/clash</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>KeepAlive</key>
            <true/>
            <key>StandardOutPath</key>
            <string>#{var}/log/clash.log</string>
            <key>StandardErrorPath</key>
            <string>#{var}/log/clash.log</string>
          </dict>
      </plist>
    EOS
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks-libev.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{ss_port},
          "password":"test",
          "timeout":600,
          "method":"chacha20-ietf-poly1305"
      }
    EOS
    server = fork { exec "ss-server", "-c", testpath/"shadowsocks-libev.json" }

    clash_port = free_port
    (testpath/"config.yaml").write <<~EOS
      mixed-port: #{clash_port}
      mode: global
      proxies:
        - name: "server"
          type: ss
          server: 127.0.0.1
          port: #{ss_port}
          password: "test"
          cipher: chacha20-ietf-poly1305
    EOS
    system "#{bin}/clash", "-t", "-d", testpath # test config && download Country.mmdb
    client = fork { exec "#{bin}/clash", "-d", testpath }

    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{clash_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
