class Flawfinder < Formula
  include Language::Python::Shebang

  desc "Examines code and reports possible security weaknesses"
  homepage "https://dwheeler.com/flawfinder/"
  url "https://dwheeler.com/flawfinder/flawfinder-2.0.15.tar.gz"
  sha256 "0a65cf93b1d380669476e576abbb04ea0766a557ce2bf75d9e71f387fcd74406"
  license "GPL-2.0-or-later"
  head "https://github.com/david-a-wheeler/flawfinder.git"

  livecheck do
    url :homepage
    regex(/href=.*?flawfinder[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "234bf06a99252223cb9acfc14b439b1ab6ed8143caa59cda8a5d8424aad9e743"
    sha256 cellar: :any_skip_relocation, big_sur:       "be0c6b6c0819fece1f9d37f8275deec415c6435f7a5285659e8a310ff602bfa5"
    sha256 cellar: :any_skip_relocation, catalina:      "2bba36ebc01b78e23dae0d7a9696f9fb8714ff82ad6a31cde9499b22e293516b"
    sha256 cellar: :any_skip_relocation, mojave:        "6d371f08132175d2c34d3e20e95febceb469a104a6789dd382de3479303ceba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72f4ff1daa16879cca0dd3c2ebea4fd9152fcd67c8e224f26106b676c76696b0"
  end

  depends_on "python@3.9"

  def install
    rewrite_shebang detected_python_shebang, "flawfinder"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int demo(char *a, char *b) {
        strcpy(a, "\n");
        strcpy(a, gettext("Hello there"));
      }
    EOS
    assert_match("Hits = 2\n", shell_output("#{bin}/flawfinder test.c"))
  end
end
