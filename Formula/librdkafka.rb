class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.6.1.tar.gz"
  sha256 "689028b5fdfdce026f396fc2f3bfe9e38947210d9bd22be28c3159cc8c41b57e"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/librdkafka.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ec7240e9422a25af6c9504fbf5bea1fdb2bcb8765f4c6c09cb0b5a0094fb71b3"
    sha256                               big_sur:       "665c15af3ef760e026c0dc441a0c750485228128416775589defbf90f1001644"
    sha256                               catalina:      "193819ab935d16d82da2b143d0509d6aa734ee6c6258868a8dd26d987ecc5c22"
    sha256                               mojave:        "94140b0992f3bdc27792c03e1be2d58215947ea2e22df42f4f0d53bf4a1e9e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da71b7fddade5ab5d4504a7ff5e5813d3f4ad874b6dddf9bc4a5b7b4920b4352"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@1.1"
  depends_on "zstd"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librdkafka/rdkafka.h>

      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; /* random */
        int version = rd_kafka_version();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end
