class Morse < Formula
  desc "QSO generator and morse code trainer"
  homepage "http://www.catb.org/~esr/morse/"
  url "http://www.catb.org/~esr/morse/morse-2.5.tar.gz"
  sha256 "476d1e8e95bb173b1aadc755db18f7e7a73eda35426944e1abd57c20307d4987"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "cb06d8049d00c1b52a2c6538ea10918a7623541df2304c1f9c154e042fde868d"
    sha256 cellar: :any,                 big_sur:       "a956bb32257136228025435a70344d3322b621be1c932e1f61be3fbc1db3b000"
    sha256 cellar: :any,                 catalina:      "f489bcc53ec31f5473e2116bd8d4f6867e15501cc8400e9992d1949331d18dee"
    sha256 cellar: :any,                 mojave:        "e696b87957c0215da2e9f600f66460c341b4141b4ef86096dd78d9000a5ceafe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4719885c84ff27f4b10d6472b07b3ba17b1084a4608f647196e67706172a0eca"
  end

  depends_on "pkg-config" => :build
  depends_on "pulseaudio"

  def install
    system "make", "all"
    bin.install %w[morse QSO]
    man1.install %w[morse.1 QSO.1]
  end

  test do
    on_linux do
      # Fails in Linux CI with "pa_simple_Write failed"
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end
    assert_match "Could not initialize audio", shell_output("#{bin}/morse -- 2>&1", 1)
  end
end
