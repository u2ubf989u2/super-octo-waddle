class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.8.tar.gz"
  sha256 "e5ca5aff55204b993a025a77c3f8c0e2ee901ba8059d71bea11de2cc685ec497"
  license "GPL-2.0"
  revision 1 unless OS.mac?

  bottle do
    sha256 cellar: :any, catalina:     "bf4fb90d788651299973a3f48300824ae6b4ec4ce1441dd94d544180f54379bd"
    sha256 cellar: :any, mojave:       "cc9d4950a1b74a27307bac429892fd85ad439f5707f53a66e800a39b23a32fdf"
    sha256 cellar: :any, high_sierra:  "50df08ee8d3cc6f141d8488341f12c32ce478f02dfb8016f533bfeababfe4537"
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  on_macos do
    disable! date: "2021-04-08", because: "requires FUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
