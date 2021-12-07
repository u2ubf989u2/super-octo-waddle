class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.7.tar.gz"
  sha256 "d35f74a6d80093764aece7b0a0ad6869799d04316efab077e0f7603835a9f159"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44278bc4332ff3f952272fd8a9ddbc3ea33f540c869e41e168245c942e0c1ef5"
    sha256 cellar: :any_skip_relocation, big_sur:       "e078e2a62bdd3c7d203895cae1c0fcaacf8b26a9dcd40d1f88b760667adc9d1d"
    sha256 cellar: :any_skip_relocation, catalina:      "38ad603da0bc035e5a905f44e22e70335d965a4ca62a2019d08a03cde3fe7f8c"
    sha256 cellar: :any_skip_relocation, mojave:        "7230e2f2ef476b2768a25796c3f20d45654eb8fa33ff171e70d91188df7e6527"
    sha256 cellar: :any_skip_relocation, high_sierra:   "536cc0ae5680a2c6316c569e2989868108f4b6626e496ec99c93e1ea823a7ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9390d1f9bed7b4326230994f6e0960f5b65a4902f3dc613416445063d723d6f2"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/sosedoff/pgweb").install buildpath.children

    cd "src/github.com/sosedoff/pgweb" do
      # Avoid running `go get`
      inreplace "Makefile", "go get", ""

      system "make", "build"
      bin.install "pgweb"
      prefix.install_metafiles
    end
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec bin/"pgweb", "--listen=#{port}",
                          "--skip-open",
                          "--sessions"
      end
      sleep 2
      assert_match "\"version\":\"#{version}\"", shell_output("curl http://localhost:#{port}/api/info")
    ensure
      Process.kill("TERM", pid)
    end
  end
end
