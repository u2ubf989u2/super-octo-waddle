class Tepl < Formula
  desc "GNOME Text Editor Product Line"
  homepage "https://wiki.gnome.org/Projects/Tepl"
  url "https://download.gnome.org/sources/tepl/5.0/tepl-5.0.1.tar.xz"
  sha256 "b1274967609f524484b38775fa9ecb296c6d6616aabd052f286339a289912804"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 arm64_big_sur: "406692c0672208bb43c849ce78f03f8b3322e05e069f296de82f533fa6c32183"
    sha256 big_sur:       "636197976067d2871dd01fdc4405579cec4c98af09838e469b296289e52b3147"
    sha256 catalina:      "3a0303c141c4e71a15fd7233c60d7f1c55db9a8ef3173105de4d0d12ae0d06d8"
    sha256 mojave:        "911f8f12c8f6b0af2cc4126bdc774acd977726cc267b6fc53b92b605c81402f1"
    sha256 x86_64_linux:  "3bd134d72435dc30ccf911d5261a37914a1cab8d8cac3730fd1f33020a96c1a3"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "amtk"
  depends_on "gtksourceview4"
  depends_on "uchardet"

  # Submitted upstream at https://gitlab.gnome.org/GNOME/tepl/-/merge_requests/8
  patch do
    url "https://gitlab.gnome.org/GNOME/tepl/-/commit/a8075b0685764d1243762e569fc636fa4673d244.diff"
    sha256 "b5d646c194955b0c14bbb7604c96e237a82632dc548f66f2d0163595ef18ee88"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tepl/tepl.h>

      int main(int argc, char *argv[]) {
        GType type = tepl_file_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    amtk = Formula["amtk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    gtksourceview4 = Formula["gtksourceview4"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pcre = Formula["pcre"]
    pixman = Formula["pixman"]
    uchardet = Formula["uchardet"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    amtklib = OS.mac? ? "amtk-5.0" : "amtk-5"
    gtksourceviewlib = OS.mac? ? "gtksourceview-4.0" : "gtksourceview-4"
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{amtk.opt_include}/amtk-5
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtksourceview4.opt_include}/gtksourceview-4
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/tepl-#{version.major}
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pcre.opt_include}
      -I#{pixman.opt_include}/pixman-1
      -I#{uchardet.opt_include}/uchardet
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{amtk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtksourceview4.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -l#{amtklib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -ltepl-5
      -l#{gtksourceviewlib}
      -lgtk-3
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
