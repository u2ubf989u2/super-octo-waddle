class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.1.0.tar.gz"
  sha256 "fdd19fdd6c524984246d92d9d7d8bfe5638fd86c5fb91ba04fe34345e5410400"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "aac81dafde12fb94101e393ff4ec369afd5bb9f7b558dfbc4258ef9a944a369d"
    sha256 cellar: :any, big_sur:       "c23859794970176661bab424f7fbaa4b5a4f720f182be2ee160afe3b26f248c0"
    sha256 cellar: :any, catalina:      "2cfa428e5dc5b98923cf95d99ef49d6a4dd82e0f00196b55813ef58d63a7de76"
    sha256 cellar: :any, mojave:        "6d1d4d7f5fe99445e49a8d9fca069f0b46a8b3f6e81cc37012df49f6af1bab42"
    sha256 cellar: :any, x86_64_linux:  "e423ac08fc81975f88af7b7d2b08fa0772dbc5a384f69392b73937a2ccc0c978"
  end

  def install
    system "make"

    lib.install Dir["lib/*"]
    include.install Dir["include/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <dpi.h>

      int main()
      {
        dpiContext* context = NULL;
        dpiErrorInfo errorInfo;

        dpiContext_create(DPI_MAJOR_VERSION, DPI_MINOR_VERSION, &context, &errorInfo);

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lodpic", "-o", "test"
    system "./test"
  end
end
