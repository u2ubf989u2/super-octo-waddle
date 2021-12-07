class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.5/fltk-1.3.5-source.tar.gz"
  sha256 "8729b2a055f38c1636ba20f749de0853384c1d3e9d1a6b8d4d1305143e115702"
  revision 3 unless OS.mac?

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "b93b7b3bea5d4d231c4d4c6041d9184a7711a02426b91339480b268a3ffe2bf7"
    sha256 big_sur:       "a4f58ab4ac8e0b54a89caccc30f6ff453d845621f3287218f4a4953ae3eca6da"
    sha256 catalina:      "d0ff3728a8da506e399b094b0e2a94ffef5a32805308d73fd2fb5fd0e402c88b"
    sha256 mojave:        "3ea6ccc2fec9151f3ed0f20761794b9fe0477d168dbc4e83ba88b3f3d16c530b"
    sha256 high_sierra:   "6edac0b91f19783376ec95c84819405a6f029d7d2bf8ac636d421682fc064e34"
    sha256 sierra:        "e2bd28a348c8fbf948f2400d3df29ba786a2ca9cc3f87b3727477fb49ebf57f0"
    sha256 x86_64_linux:  "2e583dabf2f12f57e91742d0bb69914bc2f09ad1a75acd66d07afea418ab9107"
  end

  depends_on "jpeg"
  depends_on "libpng"

  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxft"
    depends_on "libxt"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <FL/Fl.H>
      #include <FL/Fl_Window.H>
      #include <FL/Fl_Box.H>
      int main(int argc, char **argv) {
        Fl_Window *window = new Fl_Window(340,180);
        Fl_Box *box = new Fl_Box(20,40,300,100,"Hello, World!");
        box->box(FL_UP_BOX);
        box->labelfont(FL_BOLD+FL_ITALIC);
        box->labelsize(36);
        box->labeltype(FL_SHADOW_LABEL);
        window->end();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lfltk", "-o", "test"
    system "./test"
  end
end
