class Libquantum < Formula
  desc "C library for the simulation of quantum mechanics"
  homepage "http://www.libquantum.de/"
  url "http://www.libquantum.de/files/libquantum-1.1.1.tar.gz"
  sha256 "d8e3c4407076558f87640f1e618501ec85bc5f4c5a84db4117ceaec7105046e5"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1788ce1a3fad430fe6579257b4f8144fc72dea392510f170a0c8f0c213d70d80"
    sha256 cellar: :any_skip_relocation, big_sur:       "2d1e30b2ce9d0c775b23a46fb5eee3e19d6a610e800bdf4c740cecc64e18f74f"
    sha256 cellar: :any_skip_relocation, catalina:      "0a58575e3f577ad9f8157546913669bac571462dd34d32e54c37e2935b126bed"
    sha256 cellar: :any_skip_relocation, mojave:        "0c7724330a9a2741d5b52521482fb4c4516d5dc7115538f6131894e4d2b31e10"
    sha256 cellar: :any_skip_relocation, high_sierra:   "1a93bf4fd93f8a68412b622fcf94eddd2fa9a86ada64dd8eb4cca27ccfaa8ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "192997312cfb0f27ba73949f9a156418d6c413a61fe74562e7cef72ece84a21a"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"qtest.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <time.h>
      #include <quantum.h>

      int main ()
      {
        quantum_reg reg;
        int result;
        srand(time(0));
        reg = quantum_new_qureg(0, 1);
        quantum_hadamard(0, &reg);
        result = quantum_bmeasure(0, &reg);
        printf("The Quantum RNG returned %i!\\n", result);
        return 0;
      }
    EOS
    system ENV.cc, "-O3", ("-fopenmp" unless OS.mac?), "-o", "qtest", "qtest.c", "-L#{lib}", "-lquantum"
    system "./qtest"
  end
end
