class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://www.exiv2.org/"
  url "https://www.exiv2.org/builds/exiv2-0.27.3-Source.tar.gz"
  sha256 "a79f5613812aa21755d578a297874fb59a85101e793edc64ec2c6bd994e3e778"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git"

  livecheck do
    url "https://www.exiv2.org/builds/"
    regex(/href=.*?exiv2[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f3b4f6da40ef2fbb4da84cc592a1fd2618f1007b4104451b0afa214f14e53125"
    sha256 cellar: :any, big_sur:       "1d3b44a02c0ebe2ee46ced38a59cf81c60f12a0990debb8b14479431195a572e"
    sha256 cellar: :any, catalina:      "607f8322cba23a92185541c3b8ee245e7ff339becda5364e1ea6c2168015375c"
    sha256 cellar: :any, mojave:        "f4ed492ccb45b869000b2cc514ae507422624f6413057ee158ea80b772e182fb"
    sha256 cellar: :any, high_sierra:   "cd1d11df6b535b1ccfb3458cef28a7662c1e2b7213382e8292abbe00526c7b52"
    sha256 cellar: :any, x86_64_linux:  "347127bfe8140495e9a02a0d3aee991ec20d194a9c301cc8786e719990209029"
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "libssh"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args += %W[
      -DEXIV2_ENABLE_XMP=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_PNG=ON
      -DEXIV2_ENABLE_NLS=ON
      -DEXIV2_ENABLE_PRINTUCS2=ON
      -DEXIV2_ENABLE_LENSDATA=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_WEBREADY=ON
      -DEXIV2_ENABLE_CURL=ON
      -DEXIV2_ENABLE_SSH=ON
      -DEXIV2_BUILD_SAMPLES=OFF
      -DSSH_LIBRARY=#{Formula["libssh"].opt_lib}/#{shared_library("libssh")}
      -DSSH_INCLUDE_DIR=#{Formula["libssh"].opt_include}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      ..
    ]
    mkdir "build.cmake" do
      system "cmake", "-G", "Unix Makefiles", ".", *args
      system "make", "install"
    end
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end
