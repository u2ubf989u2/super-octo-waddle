class Wasm3 < Formula
  desc "High performance WebAssembly interpreter"
  homepage "https://github.com/wasm3/wasm3"
  url "https://github.com/wasm3/wasm3/archive/v0.4.9.tar.gz"
  sha256 "4a09c118fae597db046bddad5734cc536a47f9afd333855789bda6955d08a617"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96fc207027c4a0c699ec5aa4dc509f42e30d36a9afe6f22b250955983f872f28"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd097a9b898fdbf3f61a42ee47c361e94ff0f1c506459f8eada6856fb990b236"
    sha256 cellar: :any_skip_relocation, catalina:      "c547d13349dbb14ef56c27a74ee44292a8b8e712333baf59a11aa2781df4fed7"
    sha256 cellar: :any_skip_relocation, mojave:        "9899e01b3ec8dbd3ef1fbcfdf8767028ddd1d19ce1647c46acc390dd9549c24f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe3656df45ba5ccbb3d1d0db6ceedc813da3d83a31fbaa8849e6fae14e29988"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", "."
      bin.install "wasm3"
    end
    # fib32.wasm is used for testing
    prefix.install "test/lang/fib32.wasm"
  end

  test do
    # Run function fib(24) and check the result is 46368
    assert_equal "Result: 46368", shell_output("#{bin}/wasm3 --func fib #{prefix}/fib32.wasm 24 2>&1").strip
  end
end
