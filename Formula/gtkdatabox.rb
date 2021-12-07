class Gtkdatabox < Formula
  desc "Widget for live display of large amounts of changing data"
  homepage "https://sourceforge.net/projects/gtkdatabox/"
  url "https://downloads.sourceforge.net/project/gtkdatabox/gtkdatabox/0.9.3.1/gtkdatabox-0.9.3.1.tar.gz"
  sha256 "d04938d969d5458bd0df1b4fa22f647fb2eeeef75555a71f967e6c039fb4bde5"
  license "LGPL-2.1"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6159b963d83a085b13210a728e559a4f9fdb1a54f6887ed198792772d0c9c222"
    sha256 cellar: :any, big_sur:       "0653f694493bb5cda05df1dde2b340014e5c51e46d7f0c9351092cbc9c9d45fa"
    sha256 cellar: :any, catalina:      "5bbfa821a847ebaad507380489df974dd82fd7ed99fef8966cd8e27549671fe4"
    sha256 cellar: :any, mojave:        "af155aeb3a3df37027681ffb4873d0ab87263a34e1268d8b87e45f76c6824750"
    sha256 cellar: :any, x86_64_linux:  "6d721587bb14fc51c38b15d3e67372d108351094d3ed495a9eaf7340b943f2d8"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkdatabox.h>

      int main(int argc, char *argv[]) {
        GtkWidget *db = gtk_databox_new();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-#{OS.mac? ? "quartz" : "x11"}-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-#{OS.mac? ? "quartz" : "x11"}-2.0
      -lgtkdatabox
      -lpango-1.0
      -lpangocairo-1.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
