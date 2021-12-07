class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.475-with-extensions-src.tgz"
  sha256 "bb6973ae089ea18cfbd3861a5b9d2c8b7e1543a1fdc78ac2d7cd8dbe3443f319"

  # The regex below is intended to avoid releases with trailing "Experimental"
  # text after the link for the archive.
  livecheck do
    url "https://mafft.cbrc.jp/alignment/software/source.html"
    regex(%r{href=.*?mafft[._-]v?(\d+(?:\.\d+)+)-with-extensions-src\.t.+?</a>\s*?<(?:br[^>]*?|/li|/ul)>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "73d173849a883c98a41b7fd0820dbca549a13668e84c7e3e9f046cd5eec0c877"
    sha256 cellar: :any_skip_relocation, big_sur:       "cce002802d3d258caceaa2a20ecbdef0a75d14344f2aa7aa89aff5313a079c3e"
    sha256 cellar: :any_skip_relocation, catalina:      "798be41afbf9531ec0589c935a43e910cca42d66b25eb931d914324a1bfb1ea4"
    sha256 cellar: :any_skip_relocation, mojave:        "5f791516aeaff07e97ebd9966d7321f13436f99a6a232618e2ee2aface522377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61ca903df529e5a29595ea473928d72218fef09711f460d7b0e86ec7b030e0f8"
  end

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} PREFIX=#{prefix} install]
    system "make", "-C", "core", *make_args
    system "make", "-C", "extensions", *make_args
  end

  test do
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    output = shell_output("#{bin}/mafft test.fa")
    assert_match ">1\na\n>2\na", output
  end
end
