class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.5.1.tar.gz"
  sha256 "9bb39eaad3c4c68d2bcbe21e2f6c4a5274e3a3f385afb2b2ff73ae5fd998da08"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "75a1204a745e603355b01b2d2a1d412df56eb6b99d4b9434433c7e4d79572ed1"
    sha256 big_sur:       "08666d7e1363902f7aa4f33fbf7a1d00fccb0604a04aa504f5a1094b44359a96"
    sha256 catalina:      "48ef4e146e8fbc99def1d058b8cd5aabf62ad1fda020c19f722a52c67c2c1dfb"
    sha256 mojave:        "8ca2d14827c4e8cf86557ca2b486acba0650bb129786ff4fb782d2198c48354b"
    sha256 x86_64_linux:  "08718fafc8c0fa442805c971c771908dc00d38fc38608e717b856301dfa54cfb"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5" unless OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ofx"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
