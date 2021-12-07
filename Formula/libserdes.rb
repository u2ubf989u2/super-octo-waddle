class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
      tag:      "v6.1.1",
      revision: "a50fed317403fdef64b95c061614a5148597f401"
  license "Apache-2.0"
  head "https://github.com/confluentinc/libserdes.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "93737f13723933bcef81bc54dfe0c4da9a07d3d31f4450e6f4ff17784be3e51f"
    sha256 cellar: :any,                 big_sur:       "62e1fba2c412a56dee9f044e3bbcd1e917858cd7a7e88e02fe49197f47f1f5e4"
    sha256 cellar: :any,                 catalina:      "57027493f3315dbb0d8ef5ef041f49418447f98c344cc7735d71293483e9f875"
    sha256 cellar: :any,                 mojave:        "89237b1bf673797ad2c1f837e4608c749c262ae9f10bf0621137c50319f97acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71e15c5ad9698075a6165ab491dfaf3eab7adbe41b32c7aab886110c175daf12"
  end

  depends_on "avro-c"
  depends_on "jansson"

  uses_from_macos "curl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <err.h>
      #include <stddef.h>
      #include <sys/types.h>
      #include <libserdes/serdes.h>

      int main()
      {
        char errstr[512];
        serdes_conf_t *sconf = serdes_conf_new(NULL, 0, NULL);
        serdes_t *serdes = serdes_new(sconf, errstr, sizeof(errstr));
        if (serdes == NULL) {
          errx(1, "constructing serdes: %s", errstr);
        }
        serdes_destroy(serdes);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lserdes", "-o", "test"
    system "./test"
  end
end
