class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.1.1.tar.gz"
  sha256 "314dcfc4b0faa0bb735e5fa84b2406492bf94f7948af43e2b9d2982d69d542ed"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "5bd55068dd42b2aac57ed81c27a991491c1025e419f1a9a04fc8625ee6b052b9"
    sha256 cellar: :any_skip_relocation, catalina:     "20dcda60bff1a19a0aa266ac9171928435ed2f5100ef4737a9d7c0fc68b5e8d7"
    sha256 cellar: :any_skip_relocation, mojave:       "7292d06bb5efcbb61f919249c1c7ee5a1ab3547f2c791dc0ee18b80694baef47"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "654ff648985f7e6a063953104dd6991eef0a2e2215c7686e3e7928914c43878d"
  end

  depends_on "go" => :build

  def install
    time = `date +%Y%m%dT%H%M%S`.chomp
    system "go", "build", *std_go_args, "-ldflags",
           "-X main.Version=#{version} -X main.BuildDate=#{time}", "./cmd/gotop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotop --version").chomp

    system bin/"gotop", "--write-config"
    on_macos do
      assert_predicate testpath/"Library/Application Support/gotop/gotop.conf", :exist?
    end
    on_linux do
      assert_predicate testpath/".config/gotop/gotop.conf", :exist?
    end
  end
end
