class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/v0.7.1.tar.gz"
  sha256 "3a80118fde37b8c07d35b0d40465e68190bdbd6e984ca6fe5c8192c521bb076d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9f76c8377e47263458e8e09ed5e616687b25dc51821296dcefe386eb63f4eb05"
    sha256 cellar: :any, big_sur:       "433cfa09f493996f697e288318dddb9f887caaa505e89f54e6258efca30c31c5"
    sha256 cellar: :any, catalina:      "4c45ed51cac6ceb29ea7d7c6c7461b54b5e7f5ecc708e6fbba4396a26489c743"
    sha256 cellar: :any, mojave:        "d104c74c838f567086230184854a18444c570437434a001adc6ada04ce9a68a9"
    sha256 cellar: :any, x86_64_linux:  "b8190ecf8abee2e48e845472e61c92323fc232413ae057ede2b56a3cef285e42"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  def install
    ENV["LIBTOOL"] = Formula["libtool"].bin
    ENV["PKG_CONFIG"] = Formula["pkg-config"].bin/"pkg-config"

    # for the docs
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-gtk-doc"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <raqm.h>

      int main() {
        return 0;
      }
    EOS

    system ENV.cc, "test.c",
                   "-I#{include}",
                   "-I#{Formula["freetype"].include/"freetype2"}",
                   "-o", "test"
    system "./test"
  end
end
