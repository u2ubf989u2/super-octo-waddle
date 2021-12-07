class Vcprompt < Formula
  desc "Provide version control info in shell prompts"
  homepage "https://hg.gerg.ca/vcprompt"
  url "https://hg.gerg.ca/vcprompt/archive/1.2.1.tar.gz"
  sha256 "fdf26566e2bd73cf734b7228f78c09a0f53d0166662fcd482a076ed01c9dbe36"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://hg.gerg.ca/vcprompt/tags"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_big_sur: "2aaf6bc2c4bd41f4732aab8837c892a0f8f179b8db58ceff29dd38919d7d830d"
    sha256 cellar: :any, big_sur:       "571cb1cb75d76851cfe86e8622a2085e87d1cc292147b246410b61ac40f86dff"
    sha256 cellar: :any, catalina:      "503cb9532dff8fc7eb8fdd11291b26ba3240ce304e4bcb5e9888a35161433ac5"
    sha256 cellar: :any, mojave:        "8be8d7b1126e40a72a85f707b07f922132769cb2c6c26f768fe57ccb9c542fa5"
    sha256 cellar: :any, x86_64_linux:  "e02d78730b41bee820ae2cdb772b1966df04ff890076b5c4185a30642a639839"
  end

  depends_on "autoconf" => :build
  depends_on "sqlite"

  def install
    system "autoconf"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man1}",
                   "install"
  end

  test do
    system "#{bin}/vcprompt"
  end
end
