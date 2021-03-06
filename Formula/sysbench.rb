class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.20.tar.gz"
  sha256 "e8ee79b1f399b2d167e6a90de52ccc90e52408f7ade1b9b7135727efe181347f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, big_sur:      "81f4b5aa43833246f85567c964707b1741b85439c7f85e41e9d7bad7b922f7b6"
    sha256 cellar: :any, catalina:     "2ca0e854823e63ecf84b27d81d0ea722aeae784fed39b436fed738fcd4450489"
    sha256 cellar: :any, mojave:       "ec55acf85be8a3cfbd57a72f1d67aad2104e545ec32464010d673c205075c809"
    sha256 cellar: :any, high_sierra:  "84363a4b7267f936a6e168fb4ed30fa21970ff1483bb81a5fba2bbe25d611cfc"
    sha256 cellar: :any, x86_64_linux: "2d342f5909a7f4f29e3743044187205154d02d1549ee0c6d04e7cdf33b8b8e70"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  uses_from_macos "vim" # needed for xxd

  uses_from_macos "vim" # needed for xxd

  def install
    system "./autogen.sh"

    # Fix for luajit build breakage.
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # https://github.com/LuaJIT/LuaJIT/issues/518: set to 10.14 to build on Catalina.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = (DevelopmentTools.clang_build_version >= 1100) ? "10.14" : MacOS.version

    system "./configure", "--prefix=#{prefix}", "--with-mysql"
    system "make", "install"
  end

  test do
    system "#{bin}/sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end
