class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2021.01.tar.bz2"
  sha256 "b407e1510a74e863b8b5cb42a24625344f0e0c2fc7582d8c866bd899367d0454"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:      "6b4871d6839ee624ddd039dc7e5e59ca7c00d134cf5eb259e1016fba367573eb"
    sha256 cellar: :any, catalina:     "16a44059e70ea3e5b304002930aa64676c0523b4d81cd1dca21de82ceb342f76"
    sha256 cellar: :any, mojave:       "be9e797cbde27d348dfe240985021a162cc390fe9ecff11e8f56666050830dcf"
    sha256 cellar: :any, x86_64_linux: "241df3f1a012e0f382e7e3b3450992a8f2cf7d2ee25fc5a7c4d9e0ab1b6e6843"
  end

  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # Replace keyword not present in make 3.81
    inreplace "Makefile", "undefine MK_ARCH", "unexport MK_ARCH"

    system "make", "sandbox_defconfig"
    system "make", "tools", "NO_SDL=1"
    bin.install "tools/mkimage"
    bin.install "tools/dumpimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
    system bin/"dumpimage", "-V"
  end
end
