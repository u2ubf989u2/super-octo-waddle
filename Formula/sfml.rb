class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-2.5.1-sources.zip"
  sha256 "bf1e0643acb92369b24572b703473af60bac82caf5af61e77c063b779471bb7f"
  license "Zlib"
  revision 1
  head "https://github.com/SFML/SFML.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "ef472896cd55333ffe21c531b3edb055e487f5a675174feacfa6e02269877a6d"
    sha256 cellar: :any, big_sur:       "3b8efaafe447f0f3a218eb81a65d92715c35e3a703373256031cb0c3d9d21084"
    sha256 cellar: :any, catalina:      "12898a75c1d21de54fef1ca9c42c2d115d30ffcc9d7b10546c9c8d7428b467fa"
    sha256 cellar: :any, mojave:        "c45c383d9e0049ad94cbadb1f5bdd7b870bb01a9cdc8804f495e3ac48e8955d3"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"

  # https://github.com/Homebrew/homebrew/issues/40301

  def install
    # error: expected function body after function declarator
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_rf Dir["extlibs/*"] - ["extlibs/headers"]

    system "cmake", ".", *std_cmake_args,
                         "-DCMAKE_INSTALL_RPATH=#{rpath}",
                         "-DSFML_MISC_INSTALL_PREFIX=#{share}/SFML",
                         "-DSFML_INSTALL_PKGCONFIG_FILES=TRUE",
                         "-DSFML_BUILD_DOC=TRUE"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "Time.hpp"
      int main() {
        sf::Time t1 = sf::milliseconds(10);
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}/SFML/System", "-L#{lib}", "-lsfml-system",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
