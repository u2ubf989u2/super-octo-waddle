class SdlSound < Formula
  desc "Library to decode several popular sound file formats"
  homepage "https://icculus.org/SDL_sound/"
  url "https://icculus.org/SDL_sound/downloads/SDL_sound-1.0.3.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/s/sdl-sound1.2/sdl-sound1.2_1.0.3.orig.tar.gz"
  sha256 "3999fd0bbb485289a52be14b2f68b571cb84e380cc43387eadf778f64c79e6df"
  revision 1

  livecheck do
    url "https://icculus.org/SDL_sound/downloads/"
    regex(/href=.*?SDL_sound[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2da102c4035e6cd0138668695cbee5eed9f730077a78e7221e73cb2a047d915c"
    sha256 cellar: :any,                 big_sur:       "8a2c07271bbc94a345cd8951ed897e9d12edda47d713c247a77e3186780247fc"
    sha256 cellar: :any,                 catalina:      "b8ac8b382c94d4a92032a8bc9c93d777fac1367851bd3df382089f747c347f05"
    sha256 cellar: :any,                 mojave:        "3661daa8d14b8b8ab613a5fb449ad6b3f758739eb3b69700b23c0ccdc49068b6"
    sha256 cellar: :any,                 high_sierra:   "c571e007bcbb022e6fd0042e506ce6cd47a26d814de06f348b13231fc95a1581"
    sha256 cellar: :any,                 sierra:        "0e692b6c08600d6d7014fc582b5a351e8a4eea42ce95d231ef39a0c07c41c71b"
    sha256 cellar: :any,                 el_capitan:    "fd93d8be366bfe3f16839f50d11ab1149cc725c6bf6248befe90feae25c0e052"
    sha256 cellar: :any,                 yosemite:      "8f06d7c6c18c8a5192aebf5672c20f9f3b27bbd3109459ef96110d935c00f87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3017fd9a630ffce338eb378471a7d2e9c61012ad9022818b2f5ded89fc234b6d"
  end

  head do
    url "https://hg.icculus.org/icculus/SDL_sound", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl"

  def install
    if build.head?
      inreplace "bootstrap", "/usr/bin/glibtoolize", "#{Formula["libtool"].opt_bin}/glibtoolize"
      system "./bootstrap"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
