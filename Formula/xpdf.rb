class Xpdf < Formula
  desc "PDF viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://dl.xpdfreader.com/xpdf-4.03.tar.gz"
  sha256 "0fe4274374c330feaadcebb7bd7700cb91203e153b26aa95952f02bf130be846"
  license "GPL-2.0"
  revision 1

  livecheck do
    url "https://www.xpdfreader.com/download.html"
    regex(/href=.*?xpdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "052d966e5649b652bb61db7ff96386e5ca543fd65fb06818ab002b2f1138086b"
    sha256 cellar: :any,                 big_sur:       "2c74e3ae45d2666271efb5a3a913db86a300110d2e89acb97f27b4e6d5c2af7f"
    sha256 cellar: :any,                 catalina:      "af0d633049cdccbb05a15b92e1dddb2951ea6d2994a2bee343400681bfbf1a2d"
    sha256 cellar: :any,                 mojave:        "d5a0e1f2c8d6897bda1290648814b351ffebf0aadbbe856b19f7088d2673baf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93191c2d19e3890f3e90cccd091837fb377da37c539dd7a2644d79f6c6a4b24f"
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "qt@5"

  conflicts_with "pdf2image", "pdftohtml", "poppler",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
