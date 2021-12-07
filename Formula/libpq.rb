class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/12/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v13.2/postgresql-13.2.tar.bz2"
  sha256 "5fd7fcd08db86f5b2aed28fcfaf9ae0aca8e9428561ac547764c2a2b0f41adfc"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/?C=M&O=A"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_big_sur: "be102bcef1030289e73fe3643c9fd575471df27f4b958e1155abb7a76f21107c"
    sha256 big_sur:       "eae0a60decded85f7b0af6c880f81d746fc0f0e285eba091b75763e63da946ca"
    sha256 catalina:      "9bf464e2cd8c0c8b07ba1ed8e203427103921ba051fb0db4965c880b0d085339"
    sha256 mojave:        "51f2ac5acb1e614e6bc005fb2e975040bf72937f4ac1c70edcaeec3a0d396621"
    sha256 x86_64_linux:  "e7fddc8796dec99b174bb78458cc456bf1651f89265245813ff711b6d9c22535"
  end

  keg_only "conflicts with postgres formula"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-gssapi",
                          "--with-openssl",
                          "--libdir=#{opt_lib}",
                          "--includedir=#{opt_include}"
    dirs = %W[
      libdir=#{lib}
      includedir=#{include}
      pkgincludedir=#{include}/postgresql
      includedir_server=#{include}/postgresql/server
      includedir_internal=#{include}/postgresql/internal
    ]
    system "make"
    system "make", "-C", "src/bin", "install", *dirs
    system "make", "-C", "src/include", "install", *dirs
    system "make", "-C", "src/interfaces", "install", *dirs
    system "make", "-C", "src/common", "install", *dirs
    system "make", "-C", "src/port", "install", *dirs
    system "make", "-C", "doc", "install", *dirs
  end

  test do
    (testpath/"libpq.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <libpq-fe.h>

      int main()
      {
          const char *conninfo;
          PGconn     *conn;

          conninfo = "dbname = postgres";

          conn = PQconnectdb(conninfo);

          if (PQstatus(conn) != CONNECTION_OK) // This should always fail
          {
              printf("Connection to database attempted and failed");
              PQfinish(conn);
              exit(0);
          }

          return 0;
        }
    EOS
    system ENV.cc, "libpq.c", "-L#{lib}", "-I#{include}", "-lpq", "-o", "libpqtest"
    ENV.prepend_path "LD_LIBRARY_PATH", lib unless OS.mac?
    assert_equal "Connection to database attempted and failed", shell_output("./libpqtest")
  end
end
