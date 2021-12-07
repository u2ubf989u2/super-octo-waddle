class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.26.5.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.26.5/mpg123-1.26.5.tar.bz2"
  sha256 "502a97e0d935be7e37d987338021d8f301bae35c2884f2a83d59c4b52466ef06"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "1517122a2e3ff669d5fedde8f9757ef56c01054c3e9a5a225720bde130c98d9f"
    sha256 big_sur:       "4f7bb57cd2ef5287270702900cd20658e12d3118b2a67c7df675c06587712981"
    sha256 catalina:      "62da1374c12053939a725ae0855da60fde8c211a4597942dd3a6ad3928d43b20"
    sha256 mojave:        "d211e99c0017931bf34f33ecf61b9ac6df5ded0320c2ff8dfc4f92d982ff13c5"
    sha256 x86_64_linux:  "ccfcc64bb0e1dee70531dfe667c5c3ce999940d21c863ba12b66094e02d4e8de"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
    ]

    on_macos do
      args << "--with-default-audio=coreaudio"
    end

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
