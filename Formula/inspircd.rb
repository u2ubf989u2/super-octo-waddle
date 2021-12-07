class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.9.0.tar.gz"
  sha256 "5bda0fc3d41908cda4580de39d62e8be4840da45f31e072cfca337b838add567"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "5d2dbc888bc7aba0351d25899c9d380ee22d4516e739a1edbfea816346e793ea"
    sha256 big_sur:       "03ea201f04b20128300f42ae72a5d5ca210dd83ecc9f9d855a81322501fc92a1"
    sha256 catalina:      "23c294085fe76ce18f6ee9af8716d72c3b116733aa576f0e45126e0c022f13db"
    sha256 mojave:        "d319dc9f7e5574a95f751b7823ead8b4f07440846ec79b10d239f28027065c70"
    sha256 x86_64_linux:  "6fb932d60cedd2482cc66bc2775b55494e2a848ec97f8e83d751845efdcf5b3a"
  end

  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "gnutls"
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "openldap"

  skip_clean "data"
  skip_clean "logs"

  def install
    system "./configure", "--enable-extras",
                          "argon2 ldap mysql pgsql regex_posix regex_stdlib ssl_gnutls sslrehashsignal"
    system "./configure", "--disable-auto-extras",
                          "--distribution-label", "homebrew-#{revision}",
                          "--prefix", prefix
    system "make", "install"
  end

  test do
    assert_match("ERROR: Cannot open config file", shell_output("#{bin}/inspircd", 2))
  end
end
