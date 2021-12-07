class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.2/gupnp-1.2.4.tar.xz"
  sha256 "f7a0307ea51f5e44d1b832f493dd9045444a3a4e211ef85dfd9aa5dd6eaea7d1"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "42df277f75efd31c355901035cf70f440078d5ef973fe3998ea9e0e53f6ffb61"
    sha256 cellar: :any,                 big_sur:       "40c8a74e84cbf2826c098c04e888989166cbe27a9f387754c69b046b3761e6e9"
    sha256 cellar: :any,                 catalina:      "0cb0e21dccf7a4cd8105303569e1f11409f46be63893eea7523d59eeff5b2398"
    sha256 cellar: :any,                 mojave:        "24070ef84b5cad5ed79d0349b4f1bb41a1097aa20f0c401ab80b1c5646bdd153"
    sha256 cellar: :any,                 high_sierra:   "0f0c2eb53f1182cb2b81ae49ba947d87c4ce1d0f3028c8aa5df2c0dc120e3ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e433a1bdfbe692e3f4626fdea85edae388e1c5bedd88987e6d7949cfc5825f4"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gssdp"
  depends_on "libsoup"
  depends_on "python@3.9"

  def install
    mkdir "build" do
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
      bin.find { |f| rewrite_shebang detected_python_shebang, f }
    end
  end

  test do
    system bin/"gupnp-binding-tool-1.2", "--help"
    (testpath/"test.c").write <<~EOS
      #include <libgupnp/gupnp-control-point.h>

      static GMainLoop *main_loop;

      int main (int argc, char **argv)
      {
        GUPnPContext *context;
        GUPnPControlPoint *cp;

        context = gupnp_context_new (NULL, 0, NULL);
        cp = gupnp_control_point_new
          (context, "urn:schemas-upnp-org:service:WANIPConnection:1");

        main_loop = g_main_loop_new (NULL, FALSE);
        g_main_loop_unref (main_loop);
        g_object_unref (cp);
        g_object_unref (context);

        return 0;
      }
    EOS
    linker_flags = %W[
      -L#{lib}
      -lgupnp-1.2
      -lglib-2.0
      -lgobject-2.0
    ]
    system ENV.cc, "-I#{include}/gupnp-1.2", "-L#{lib}", "-lgupnp-1.2",
           "-I#{Formula["gssdp"].opt_include}/gssdp-1.2",
           "-L#{Formula["gssdp"].opt_lib}", "-lgssdp-1.2",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-L#{Formula["glib"].opt_lib}",
           "-lglib-2.0", "-lgobject-2.0",
           "-I#{Formula["libsoup"].opt_include}/libsoup-2.4",
           "-I" + (OS.mac? ? "#{MacOS.sdk_path}/usr/include/libxml2" : Formula["libxml2"].include/"libxml2"),
           testpath/"test.c", *(linker_flags unless OS.mac?), "-o", testpath/"test"
    system "./test"
  end
end
