class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "https://github.com/google/AFL"
  url "https://github.com/google/AFL/archive/v2.57b.tar.gz"
  version "2.57b"
  sha256 "6f05a6515c07abe49f6f292bd13c96004cc1e016bda0c3cc9c2769dd43f163ee"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+b?)$/i)
  end

  bottle do
    sha256 big_sur:      "9a6b82b91f72a781d576a0b79b43869577c2f2c16d8d7e56a8c0830f8f7aa11e"
    sha256 catalina:     "9d9406abfd60163bea04281f6f3746a4f1a1c138c980fa28ace79869b1097052"
    sha256 mojave:       "7c539dbcb692e99baa85a2edbb11f2945d7bc820d14a454a99594ba3e5321638"
    sha256 high_sierra:  "8e64a9a77f39a8803058381cc80396a4ca7e5104c212d5ef1bd3d9513f9753ab"
    sha256 x86_64_linux: "15f973425751a919ef9b319d22d846b43a4fc9d907ca29d0655af2f49a583adc"
  end

  def install
    system "make", "PREFIX=#{prefix}", "AFL_NO_X86=1"
    system "make", "install", "PREFIX=#{prefix}", "AFL_NO_X86=1"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~EOS
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    if which "clang++"
      system bin/"afl-clang++", "-g", cpp_file, "-o", "test"
    else
      system bin/"afl-g++", "-g", cpp_file, "-o", "test"
    end
    assert_equal "Hello, world!", shell_output("./test")
  end
end
