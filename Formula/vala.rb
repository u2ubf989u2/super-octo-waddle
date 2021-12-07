class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.52/vala-0.52.3.tar.xz"
  sha256 "037ea1a92bf0f1ab04a71b52a01d50aca1945ad1017b6189d9614f84f5c9b2d9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "3605397486262d57e3b6796b089109ab00571d9d3b600ee02a168cc4dcb9f578"
    sha256 big_sur:       "5ccb07c2adb88e1dd744fd73be423e594ecf22c0767c2d3f7277ee3d4917f513"
    sha256 catalina:      "550e6d05e894e564ea38204a5b5e89a3a7b33cfea89b12db24a88ca38e9827e1"
    sha256 mojave:        "ed18ebc142d30bfab9bf5c6cdd1d3a814d7e7795d0e857c6be9bd241aa11a44a"
    sha256 x86_64_linux:  "c70ff73c0a78e8169f8cdcf89cf0a9f9c7726d294ab4d64c7343aab62738712e"
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<~EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [
      # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      path.to_s,
    ]
    system "#{bin}/valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
