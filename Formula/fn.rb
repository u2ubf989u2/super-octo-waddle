class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.6.tar.gz"
  sha256 "5197345f6708641d780875cc376d48f38e2d2a03a8fcabc018b011586cc54bf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "641e859eedb95898359e93332b849faee1c36510482de8573503bbe21fc5beff"
    sha256 cellar: :any_skip_relocation, big_sur:       "d81671b629a5e2030d74bf6a9eba319d504721499b1717a2524afcde9e5eedc2"
    sha256 cellar: :any_skip_relocation, catalina:      "12595b598c27f1429406db90c896dcf793b4687f503969b9e549bb870c41dbae"
    sha256 cellar: :any_skip_relocation, mojave:        "9fbbb58bd4f6a4437b0e0fb9b4578a509cf6baf0f4b0b13bc7ba8e020cab341e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75707c5fccc75b0b4bcd911385a4e0987b52762b9ef6f046698cb65885e8c159"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", "#{bin}/fn"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system "#{bin}/fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_predicate testpath/"func.go", :exist?, "expected file func.go doesn't exist"
    assert_predicate testpath/"func.yaml", :exist?, "expected file func.yaml doesn't exist"
    port = free_port
    server = TCPServer.new("localhost", port)
    pid = fork do
      loop do
        socket = server.accept
        response =
          '{"id":"01CQNY9PADNG8G00GZJ000000A","name":"myapp",' \
           '"created_at":"2018-09-18T08:56:08.269Z","updated_at":"2018-09-18T08:56:08.269Z"}'
        socket.print "HTTP/1.1 200 OK\r\n" \
                    "Content-Length: #{response.bytesize}\r\n" \
                    "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end
    sleep 1
    begin
      ENV["FN_API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "Successfully created app:  myapp"
      output = shell_output("#{bin}/fn create app myapp")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
