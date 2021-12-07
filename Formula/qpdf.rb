class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.3.1/qpdf-10.3.1.tar.gz"
  sha256 "d3e6b862098c6357d04390fd30d08c94aa2cf7a3bb2dcabd3846df5eb57367d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9301aec752ffa0a1ad9f4d6bb10dfdce0025d7e2a2704a73a3972934b689759e"
    sha256 cellar: :any,                 big_sur:       "f554c67b93485a55d02140bc21176c85725cc18c61f74008d6883a6484248146"
    sha256 cellar: :any,                 catalina:      "1840d900bae9754ba862d0a287fbf22da64065dab24bcd0370b813b1324fe83a"
    sha256 cellar: :any,                 mojave:        "b8a925330f9f9633c3345b44add91491631a949b05fd0c0ab2e89d0e7d5c6144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "368cdb65e18e021e43487c6419c0a567b6902e9c83df688c1eedb06e48869b34"
  end

  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
