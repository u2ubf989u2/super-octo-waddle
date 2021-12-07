class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v2.4.0.tar.gz"
  sha256 "e8275b939693f7e0a2e6f8ae6aa453e8edcf8c83a7234546da4e3a83462a42c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "569dd4476c1151631a317cd5505b283108903dd208b570cd3f489df99a927ed0"
    sha256 cellar: :any,                 big_sur:       "84513761d57db3c3dd87a7a587b39fe47f49186c4fa430f5bb87ed4896cc0b2e"
    sha256 cellar: :any,                 catalina:      "a6e9c60644c9aaa3b2f5c250137947a2a5d27ac19db21a1cc444d2be5d6fe8dc"
    sha256 cellar: :any,                 mojave:        "7db8f44385b323aa0fd2ee4efcd1e4939b89ffb93d96288e5d5d978f77f65473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93b3836118712effb2a35f46b5d46e10d06a9509f6e65ef82b401e3056ed50ff"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "protobuf-c"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                         "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
