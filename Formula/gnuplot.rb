class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.1/gnuplot-5.4.1.tar.gz"
  sha256 "6b690485567eaeb938c26936e5e0681cf70c856d273cc2c45fabf64d8bc6590e"
  license "gnuplot"
  revision 2

  bottle do
    sha256 arm64_big_sur: "b716ef439ed271b604f1f62a921f4134e25e10f4145eea6ba5fdb1f10e3369e9"
    sha256 big_sur:       "71b95705ec9b7a5e03668d6491b75e66dbee794b4c7a02f20d54e4dfcbf4fa4e"
    sha256 catalina:      "88f18dff95d0609b0cbf6eb53446869b1639998c69180b34a18c45c8a6bae520"
    sha256 mojave:        "906aa3c73c481c21e252ace7653703f815ed15c71717baa1ff299f4004624368"
    sha256 x86_64_linux:  "80d934a16a475a82d02839d4426999b06f2706196a2ff7e9bd6f3d63a73acbd1"
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt@5"
  depends_on "readline"

  def install
    # Qt5 requires c++11 (and the other backends do not care)
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      --without-tutorial
      --disable-wxwidgets
      --with-qt
      --without-x
      --without-latex
    ]

    system "./prepare" if build.head?
    system "./configure", *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_predicate testpath/"graph.txt", :exist?
  end
end
