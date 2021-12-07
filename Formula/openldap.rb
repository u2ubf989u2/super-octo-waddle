class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.58.tgz"
  sha256 "57b59254be15d0bf6a9ab3d514c1c05777b02123291533134a87c94468f8f47b"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "978f2896e8daf4c88521af38226decc28f066c4205d1298b8048bf0c034c6061"
    sha256 big_sur:       "a80cfbc1ab79fd40e646d0160ce4335f01fe41b13c0921e824af05ce3a656c3c"
    sha256 catalina:      "12b35571227819700575901d20a25cbcf605ba9ffbf89e8034223da045ff4706"
    sha256 mojave:        "3b93e3df9bd07b336e68f8a8a2ac80c07d305af3860a03733a95d84065b4770a"
    sha256 x86_64_linux:  "4f56a02ab2b61f2e8af7cf7ebab84a92190b7ad476d8904515c260d186ffd71c"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  on_linux do
    depends_on "groff" => :build
    depends_on "util-linux"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-bdb=no
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-hdb=no
      --enable-memberof
      --enable-ppolicy
      --enable-proxycache
      --enable-refint
      --enable-retcode
      --enable-seqmod
      --enable-translucent
      --enable-unique
      --enable-valsort
    ]

    system "./configure", *args
    system "make", "install"
    (var/"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
