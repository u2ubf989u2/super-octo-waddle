class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.4.2/timew-1.4.2.tar.gz"
  sha256 "c3d3992aa8d2cc3cd86e59d00060fb4a3e16c15babce78451cc9d39a7f5bb2e1"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/timewarrior.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b725f7ad884389a11b3428f43ab9d823e179a5aa679a6506ea0b67eb65007c25"
    sha256 cellar: :any_skip_relocation, big_sur:       "40d7ce6f5802ca1a755f6a722ebcabc68b574632007d95ef109ad99c2e7a4902"
    sha256 cellar: :any_skip_relocation, catalina:      "4c872f73c14a7219179b3f468d5ceb0739b79ace42e69126f9b3549eac9cba94"
    sha256 cellar: :any_skip_relocation, mojave:        "336d8bbaf618d17901774358a58772579318a405e7020c63583538283b1f2165"
    sha256 cellar: :any_skip_relocation, high_sierra:   "c15692ae447c6364eb7c74665e3b9d8acb01be7f31eb0f4ebaf92d7c7dc3f874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "991d4ca3d458e2d6c5ff9843d2f053f12d4dcd1d8f0075a061d20f99e7e045e9"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/".timewarrior/data").mkpath
    (testpath/".timewarrior/extensions").mkpath
    touch testpath/".timewarrior/timewarrior.cfg"
    assert_match "Tracking foo", shell_output("#{bin}/timew start foo")
  end
end
