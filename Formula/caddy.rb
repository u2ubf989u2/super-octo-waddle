class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.3.0.tar.gz"
  sha256 "4688b122ac05be39622aa81324d1635f1642e4a66d731e82d210aef78cf2766a"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "506af0d514605b32b5775cf716d241a5de2e96e8c5a99139573753c4476fbb4d"
    sha256 cellar: :any_skip_relocation, big_sur:       "9564b852006d1a2bbad34dffce96a225b26e258fb9bc34a2202fe2b9dceee397"
    sha256 cellar: :any_skip_relocation, catalina:      "e3426aa235903fb0d6d25674114e16f05974f719119bec81b443136f8cc1b347"
    sha256 cellar: :any_skip_relocation, mojave:        "182ffcf9b7bb81f4299897a225848e690605f47126f1a2dd97b69ca5a7f869ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9e47e306a1dbe45059abe36b4ebe74e6a005868be9d2f4e0c3c26aa265bc3e1"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/v0.1.8.tar.gz"
    sha256 "517e800e2c3edfa0bcb5a80092d2cc7dc2f7d1c21a91ec6e77393df127b182f9"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmd/xcaddy/main.go", "build", revision, "--output", bin/"caddy"
    end
  end

  plist_options manual: "caddy run --config #{HOMEBREW_PREFIX}/etc/Caddyfile"

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
            <string>#{opt_bin}/caddy</string>
            <string>run</string>
            <string>--config</string>
            <string>#{etc}/Caddyfile</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>StandardOutPath</key>
          <string>#{var}/log/caddy.log</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/caddy.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port1 = free_port
    port2 = free_port

    (testpath/"Caddyfile").write <<~EOS
      {
        admin 127.0.0.1:#{port1}
      }

      http://127.0.0.1:#{port2} {
        respond "Hello, Caddy!"
      }
    EOS

    fork do
      exec bin/"caddy", "run", "--config", testpath/"Caddyfile"
    end
    sleep 2

    assert_match "\":#{port2}\"",
      shell_output("curl -s http://127.0.0.1:#{port1}/config/apps/http/servers/srv0/listen/0")
    assert_match "Hello, Caddy!", shell_output("curl -s http://127.0.0.1:#{port2}")

    assert_match version.to_s, shell_output("#{bin}/caddy version")
  end
end
