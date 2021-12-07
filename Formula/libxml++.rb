class Libxmlxx < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/2.42/libxml++-2.42.0.tar.xz"
  sha256 "3d032aede98a033eb5e815b4bfa9fa7b4e745268e6fd1ce8b1d0f70bcaf4736d"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a9dc7eb652f1c83152920bae6d930f8692d443fe180eb77fcaa4e2cd33661a7d"
    sha256 cellar: :any,                 big_sur:       "2fb9806be122c23fdb9968dc3cafcec7b52afb60e6e496c5d1597843b8a4b54a"
    sha256 cellar: :any,                 catalina:      "8f9f3bdd2d4208725f0f76a602bc9e78d593becc10858b51d6c724e7ba1e7cfe"
    sha256 cellar: :any,                 mojave:        "5fb122370076e5963c2be7c455d867e4e36a306b86cbb100433a266a1b621767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc5854dc3e24180bdeba80e7f3b1ca20a7909e2e413cd5b2ab30f4a19ed00086"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glibmm@2.66"

  uses_from_macos "libxml2"

  def install
    ENV.cxx11
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "https://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm@2.66"]
    libsigcxx = Formula["libsigc++@2"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/libxml++-2.6
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/libxml++-2.6/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lsigc-2.0
      -lxml++-2.6
      -lxml2
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
