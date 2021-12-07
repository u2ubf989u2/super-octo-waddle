class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.2.2.tar.gz"
  sha256 "99f264fc953d2a9d1b454f62d0991ef3a0004825ebcc95f9fd9bb7cbe1783ba1"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "2547d738d4d5ef11a881a175e5ae7cb70ff4d99f52c8f71fe03cb198608d96a0"
    sha256 big_sur:       "79b4f7f5bdc76ca9aeedea952b13bf49b63c7258fa18e7e2551fb62969060140"
    sha256 catalina:      "da66c1f679aa1eabf98246210c3428cfc956c61ebf0ca14652efb3fe7d3e6df8"
    sha256 mojave:        "41f43474dbf1daac87ad3b0d71b050884687909a01fd7fb252d6aed6efa40794"
    sha256 x86_64_linux:  "40c1aa0306c0c26c0b0c63baafdc98c165244e1b9a1612867a3b1a345ebc6286"
  end

  depends_on "postgresql"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    cp etc/"pgpool.conf.sample", testpath/"pgpool.conf"
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end
