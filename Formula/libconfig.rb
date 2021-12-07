class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "https://hyperrealm.github.io/libconfig/"
  url "https://github.com/hyperrealm/libconfig/archive/v1.7.2.tar.gz"
  sha256 "f67ac44099916ae260a6c9e290a90809e7d782d96cdd462cac656ebc5b685726"
  license "LGPL-2.1-or-later"
  head "https://github.com/hyperrealm/libconfig.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "4f8ed5fc70f9240873fa41d407fb56b21b3d528609c3c66246faee586196a8d9"
    sha256 cellar: :any, big_sur:       "3b66cbc5fae338f422386f6a2eecd650a64391da8d2f7fba259af614729844da"
    sha256 cellar: :any, catalina:      "5133affbfe2df2eccf05017748542e521e70a8db8763c8d8e39e00aec78fe3f8"
    sha256 cellar: :any, mojave:        "b1c005fc0d3a811efcef915d8e84d9cc2828d6c35c5649f71fab3c714b2ae1ea"
    sha256 cellar: :any, high_sierra:   "5762b7106a3e4ecc470193cd8abcfd40de090c456d42b413e545402246d73f69"
    sha256 cellar: :any, x86_64_linux:  "ba42db3b1ba5f0638460c4b6218532ba17d0e34dd0c144554a399aa924aad3a8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "texinfo" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libconfig.h>
      int main() {
        config_t cfg;
        config_init(&cfg);
        config_destroy(&cfg);
        return 0;
      }
    EOS
    system ENV.cc, testpath/"test.c", "-I#{include}",
           "-L#{lib}", "-lconfig", "-o", testpath/"test"
    system "./test"
  end
end
