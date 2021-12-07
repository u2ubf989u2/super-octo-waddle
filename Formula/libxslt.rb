class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "http://xmlsoft.org/sources/libxslt-1.1.34.tar.gz"
  sha256 "98b1bd46d6792925ad2dfe9a87452ea2adebf69dcb9919ffd55bf926a7f93f7f"
  license "X11"
  revision OS.mac? ? 2 : 3

  livecheck do
    url "http://xmlsoft.org/sources/"
    regex(/href=.*?libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7f0dcf602ce806db8ce41b1e8d4ef352823f7343f258cd0519e6ad1885f3c593"
    sha256 cellar: :any_skip_relocation, big_sur:       "61c11bb170d9ba4bd079a2c81887b9d82cb34a3de110117d61d75f7f050b90d3"
    sha256 cellar: :any_skip_relocation, catalina:      "7f1626b1ae090f561ed8d7c2a3c7e9067ad29d68b547d91ff5a2e83d346183bc"
    sha256 cellar: :any_skip_relocation, mojave:        "6c73651ec7791877fe42675f9de291709300a2c3aa0da3e859d139e4121a5a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "161d2de9a11ec44210091735f8c173e0b343f61e2689b17232fec8762e065ac7"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxslt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "libgcrypt"
  depends_on "libxml2"

  def install
    system "autoreconf", "-fiv" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--with-crypto",
                          "--with-libxml-prefix=#{Formula["libxml2"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To allow the nokogiri gem to link against this libxslt run:
        gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xslt-config --version")
    (testpath/"test.c").write <<~EOS
      #include <libexslt/exslt.h>
      int main(int argc, char *argv[]) {
        exsltCryptoRegister();
        return 0;
      }
    EOS
    flags = shell_output("#{bin}/xslt-config --cflags --libs").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags, "-lexslt"
    system "./test"
  end
end
