class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.18.0-source.tar.xz"
  sha256 "592d4f6c0fba41bb954eb1a41616661b62b134d5b383e33bd45a081af5d4a59a"
  license "AGPL-3.0"
  head "https://git.ghostscript.com/mupdf.git"

  livecheck do
    url "https://mupdf.com/downloads/archive/?C=M&O=D"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d78a3ae676e2872d42aefa36563a2cacaa2ad04203d6b8d1c8257ccdebcea847"
    sha256 cellar: :any_skip_relocation, big_sur:       "a62ca2ae12f896d22a6fc609fadc96cf729e46206f9a1127f6f21e4846eaa2ba"
    sha256 cellar: :any_skip_relocation, catalina:      "e985551872925ed4b66ce995c551fda59152c1e7f9cf2bdbd205ab749e867e17"
    sha256 cellar: :any_skip_relocation, mojave:        "50f1628c7c396fdfd65eb5ce84541a5b9a695bc6fe003cc7abc732e212762bc3"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2a7a4799ca7e75e948331ce00f5799ae8cb6ae2f23e1143955b9d03d8eccbcd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426ab819775141c038ca1b9139a6c3c8c96e9783985ae864967e7ef4f673ce02"
  end

  conflicts_with "mupdf",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
