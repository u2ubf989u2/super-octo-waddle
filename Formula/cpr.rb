class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://whoshuu.github.io/cpr/"
  url "https://github.com/whoshuu/cpr.git",
      tag:      "1.6.2",
      revision: "f4622efcb59d84071ae11404ae61bd821c1c344b"
  license "MIT"
  head "https://github.com/whoshuu/cpr.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6b725644e68fd8fd18ee1624248de28bff8e0c206d566852a4821714fed3099e"
    sha256 cellar: :any,                 big_sur:       "f531320c598e51d6fa215fe35caf9766882349bb1e5d89319ec6a0937202f627"
    sha256 cellar: :any,                 catalina:      "3c3d0ebe3de5371c93a5b1b68b599e9aee2d5abe2e8598a6775b463be05bcddc"
    sha256 cellar: :any,                 mojave:        "608ac5168dd4ca3ab78d84827ccfce0abba0ad9699bef82ffad074a0b51aefc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e847ed5aff9686226c9986e874459b62d668389e41df1102053248a0ccce6cea"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  def install
    args = std_cmake_args + %w[
      -DCPR_FORCE_USE_SYSTEM_CURL=ON
      -DCPR_BUILD_TESTS=OFF
    ]

    system "cmake", ".", *args, "-DBUILD_SHARED_LIBS=ON"
    system "make", "install"

    system "make", "clean"
    system "cmake", ".", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "make"
    lib.install "lib/libcpr.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lcpr", "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
