class Freexl < Formula
  desc "Library to extract data from Excel .xls files"
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.6.tar.gz"
  sha256 "3de8b57a3d130cb2881ea52d3aa9ce1feedb1b57b7daa4eb37f751404f90fc22"

  livecheck do
    url :homepage
    regex(%r{current version is <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9ca72ad3d0fadf95435a288506a127a8f9ec814deb91f72c0fbeca4477d28c24"
    sha256 cellar: :any, big_sur:       "5caea83326dab33d791db451df7a9add0f4d833e68f8bff36fdc4838ecd932ad"
    sha256 cellar: :any, catalina:      "4bac859e3460476137f1596a36015e9c0d3e1d2b46a9aa47171cabf7af5f5d71"
    sha256 cellar: :any, mojave:        "68d9f5926df0ca43cfda25423a405b837de81575eec025944f6ec67611422742"
    sha256 cellar: :any, high_sierra:   "959ce4d49a7419b01acf9e66c9d0f77a213c067f723b87d08ac6aaa21d054fe9"
    sha256 cellar: :any, x86_64_linux:  "54cc925c2d21793f5e39435d1153ac763b82a1969394eaf7a7ca35a78cb098a0"
  end

  depends_on "doxygen" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"

    system "make", "check"
    system "make", "install"

    system "doxygen"
    doc.install "html"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "freexl.h"

      int main()
      {
          printf("%s", freexl_version());
          return 0;
      }
    EOS
    if ENV.cc == "clang"
      system ENV.cc, "-L#{lib}", "-lfreexl", "test.c", "-o", "test"
    else
      system ENV.cc, "test.c", "-L#{lib}", "-lfreexl", "-o", "test"
    end
    assert_equal version.to_s, shell_output("./test")
  end
end
