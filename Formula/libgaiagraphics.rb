class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha256 "ccab293319eef1e77d18c41ba75bc0b6328d0fc3c045bb1d1c4f9d403676ca1c"
  revision 7

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/"
    regex(/href=.*?libgaiagraphics[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "735b5cc5e33f5b3bd886ba97093edc71a4ad2dd02703870f4a8d1b309b2dbf45"
    sha256 cellar: :any,                 big_sur:       "71019ebb245fbf75794ffc377be75d4a9731a7cc842a458d630ef7fb9d824741"
    sha256 cellar: :any,                 catalina:      "05b3806c31a6e084eeeec2e44c83b8fb728cd0de4cc22dae14888ff52e290cca"
    sha256 cellar: :any,                 mojave:        "bfaf50e26b9312c1ef7d9b62677e92099339d14393ce855b870fe9288503c5df"
    sha256 cellar: :any,                 high_sierra:   "20a230ae5fccd2d5114e8ab7a128dd57834104461e5a7cbc2f7c7e63075214d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50cd42cffa493dbc5770524319f6950a70519ccd37a588f4432c30761254f293"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "jpeg"
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "proj"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
