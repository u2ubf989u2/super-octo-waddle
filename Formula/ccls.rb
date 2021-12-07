class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20210330.tar.gz"
  sha256 "28c228f49dfc0f23cb5d581b7de35792648f32c39f4ca35f68ff8c9cb5ce56c2"
  license "Apache-2.0"
  revision OS.mac? ? 1 : 2
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256                               arm64_big_sur: "4b2edaf5fa08c9846ca7bc5cc20d36cbf6c6299af4df34527fbd511bbdebb5d7"
    sha256                               big_sur:       "cde35a76dbcadb48c962ded6e8e42e232e2a9084d46f01671b4a372a71dcc6cc"
    sha256                               catalina:      "86b111c8e74d39fb31558870c8b11b45625fab9573bbced33600319c53448530"
    sha256                               mojave:        "f8c02843ad68842a00b2b1d7015f3e73577b2717eef55c5c614231f0a4b57212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b3e1a27b3d63ce0e6e29efd0e496de63aecde88d582b675dc567914b561b938"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on macos: :high_sierra # C++ 17 is required

  depends_on "gcc" unless OS.mac? # C++17 is required

  fails_with gcc: "5"

  def install
    # https://github.com/Homebrew/brew/issues/6070
    ENV.remove %w[LDFLAGS LIBRARY_PATH HOMEBREW_LIBRARY_PATHS], "#{HOMEBREW_PREFIX}/lib" unless OS.mac?

    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ccls", "-index=#{testpath}"
  end
end
