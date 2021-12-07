class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.86.tar.xz"
  sha256 "0b3f595159ad1b216cd729c0504c3a5f6cf780c641f4dc63fc164f3c0382c8f0"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_big_sur: "e7c76f6fc2c5e6c958b925e6fde9737dfec010e3d18fb388e17ad560847fb6a8"
    sha256                               big_sur:       "0ca92c541d6ad2932d6ee01576d2121bbbe3afb46ba7dc26aea2ed6a59750bd7"
    sha256                               catalina:      "816dbd4f4414cd6c3831645e43475d78274568cc0d60bbb092a87027bf38d834"
    sha256                               mojave:        "c6fcb715f5edf7532ce6cd9be976526f77ce5836360eb2a8d5454e0d6cc628fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a661b8ace2b209090cf49d0def5423aacc43d7864d7c25c2d53efbc01ce6d6"
  end

  depends_on "glib" => :build # for gobject-introspection
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "little-cms2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dwith-docs=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <babl/babl.h>
      int main() {
        babl_init();
        const Babl *srgb = babl_format ("R'G'B' u8");
        const Babl *lab  = babl_format ("CIE Lab float");
        const Babl *rgb_to_lab_fish = babl_fish (srgb, lab);
        babl_exit();
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/babl-0.1", testpath/"test.c", "-L#{lib}", "-lbabl-0.1", "-o", "test"
    system testpath/"test"
  end
end
