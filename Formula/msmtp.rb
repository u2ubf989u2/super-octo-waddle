class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.15.tar.xz"
  sha256 "2265dc639ebf2edf3069fffe0a3bd76749f8b58f4001d5cdeae19873949099ce"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "9e321f6cbb4178c04ead2f89ee357d7a216d886e27e8902780180f7ee583b5e9"
    sha256 big_sur:       "f2f12ecc517a43485ad6b4de45bba8a3a0434f6e568ff40f0dcd9b0ca0aab7b3"
    sha256 catalina:      "905c4115c7457ef7a063a94b0eb7f31e5c9713858b75edf711410b39c4c0991e"
    sha256 mojave:        "beffeb0167849f87a790624c01ab67ad2e007c2c0b0b2e3bd9a7f7522ca1ea29"
    sha256 x86_64_linux:  "fd5f4cc21e6e4a66ce25a31fe939f08ac9c6a7e81dcffd5f5e630a0b76e5fee1"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  on_linux do
    depends_on "libsecret"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-macosx-keyring
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
