class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.30/src/nspr-4.30.tar.gz"
  sha256 "8d4cd8f8409484dc4c3d31e180354bfc506573eccf86cd691106a1ef7edc913b"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2fc4d4bfd5f394070d583edd6608b1de7f65ab4840443eddf149c249d1e7e0a9"
    sha256 cellar: :any,                 big_sur:       "f2d71db58997266b9f0aa518ce1bdbd7648d4138e6673a01087f18967023f8ae"
    sha256 cellar: :any,                 catalina:      "f1f0f7f48b791b7d08b59600b9d0e47b26872f3168b506b2b53cd01a632c93d8"
    sha256 cellar: :any,                 mojave:        "3655c56ecc592a029200493c30930b2ecf3f4911ee2af72ac01d4fe1fa88126c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0562a60d93927d3ed3c2027347a94f4d1563601bda229043d14f635390d5a906"
  end

  def install
    ENV.deparallelize
    cd "nspr" do
      args = %W[
        --disable-debug
        --prefix=#{prefix}
        --enable-strip
        --with-pthreads
        --enable-ipv6
        --enable-macos-target=#{MacOS.version}
        --enable-64bit
      ]
      system "./configure", *args
      # Remove the broken (for anyone but Firefox) install_name
      inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", "-install_name #{lib}/$@ " if OS.mac?

      system "make"
      system "make", "install"

      (bin/"compile-et.pl").unlink
      (bin/"prerr.properties").unlink
    end
  end

  test do
    system "#{bin}/nspr-config", "--version"
  end
end
