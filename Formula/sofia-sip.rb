class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.3.tar.gz"
  sha256 "6f9cc7ed674e2214809e390728da0df646f94e5b991cff9f393217176de9d7e4"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "140bf310b37cc869a010b610d5fa96932f3110804f347901ffd149cf5a2de5e8"
    sha256 cellar: :any,                 big_sur:       "8af7baa5cb43c43281212108323663c4905ec5f0413e194d833d320986dbf1df"
    sha256 cellar: :any,                 catalina:      "99edefb3cd8c43b53e160eb74dca06fbb2d1d9b75d1363d7b81b8e9eba263cc9"
    sha256 cellar: :any,                 mojave:        "166390e2e233d0378d1dc7777a515bb18ad112ea78eef627abca8562b4110511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b23c87ff2ff2431a0d14fcc090f6349fb6705bc9ec43b889e95bb65d8a3792eb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end
