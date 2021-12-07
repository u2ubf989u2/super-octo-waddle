class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/20210124.204813.840499f.tar.gz"
  version "20210124.204813.840499f"
  sha256 "21e6eb6791b63ba1d06c6ffa9cf40ee81cec80da944e8a29c6dbd11d9de50b28"
  license "GPL-2.0-or-later"
  revision 1 unless OS.mac?
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b13b47c39fe2d69a9aef32280da1529e5e70c02b35fbb7add9c2d0ad25dc36fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "7030626fea429aab956442a66f630639ea17c44c05d948ad1c2c91cde5eefb53"
    sha256 cellar: :any_skip_relocation, catalina:      "9fb54fe0aa1faeef942d48c139bb7e003aaf795c8a47b0d9c6d046bafc3b3fb0"
    sha256 cellar: :any_skip_relocation, mojave:        "b58fc8376ed3e18b7207ede4825c34256854b3abc390260f5f6759e0eb329013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ded2675e6ba474d50a966414cc0704442719c41020812a8ce74ac0fd1a5cb118"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", ".", "--config", "Release"
    bin.install "AtomicParsley"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"
    system "#{bin}/AtomicParsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/AtomicParsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
