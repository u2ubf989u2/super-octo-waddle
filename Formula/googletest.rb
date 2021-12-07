class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
  sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b31c1f09e496782c536ece5a805b12e7d5db3250bf89657d55885366c37bb6df"
    sha256 cellar: :any_skip_relocation, big_sur:       "66021a83c2dfe2a3baba769a76babde2f7224e9d6b555d8909995765bc555231"
    sha256 cellar: :any_skip_relocation, catalina:      "f9819a67ff4c54bfde932f1d83d9db44f8ca0e7b65e77dd812d4f71931d3deed"
    sha256 cellar: :any_skip_relocation, mojave:        "58f238b7d2fea41af22c3e4bc6b52d79510c84adba6b6145f548a248a2687f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91c4c78738d6b7c2fd12dfac7528223ba6609bcf389a5d7a7c16ed7cdee5ed90"
  end

  depends_on "cmake" => :build

  conflicts_with "nss", because: "both install `libgtest.a`"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # for use case like `#include "googletest/googletest/src/gtest-all.cc"`
    (include/"googlemock/googlemock/src").install Dir["googlemock/src/*"]
    (include/"googletest/googletest/src").install Dir["googletest/src/*"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtest/gtest.h>
      #include <gtest/gtest-death-test.h>

      TEST(Simple, Boolean)
      {
        ASSERT_TRUE(true);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lgtest", "-lgtest_main", "-pthread", "-o", "test"
    system "./test"
  end
end
