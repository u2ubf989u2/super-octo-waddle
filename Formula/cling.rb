class Cling < Formula
  desc "C++ interpreter"
  homepage "https://root.cern.ch/cling"
  url "https://github.com/root-project/cling.git",
      tag:      "v0.7",
      revision: "70163975eee5a76b45a1ca4016bfafebc9b57e07"
  license any_of: ["LGPL-2.1-only", "NCSA"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7c100296feb4998222916d3d3f98f22d1584031ec2115c83c562b53bb4025c91"
    sha256 cellar: :any,                 big_sur:       "4f7e4ff0e73858b0fc8f3f3ea004f3118da82108a6087ebdb21973116ff58cee"
    sha256 cellar: :any,                 catalina:      "743a41e996097da4d0d309839045c081dee5e2ec94ccb4839413003f632ffb98"
    sha256 cellar: :any,                 mojave:        "ccc594737e7a0b777ad5360566a0fa13f0584c6cdb0b4023ed0ff59ebac30112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de7bb72540b0410b4f54d9e0d67315e2b649456ee30d4adaedfa76297b187298"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "clang" do
    url "http://root.cern.ch/git/clang.git",
        tag:      "cling-v0.7",
        revision: "354b25b5d915ff3b1946479ad07f3f2768ea1621"
  end

  resource "llvm" do
    url "http://root.cern.ch/git/llvm.git",
        tag:      "cling-v0.6",
        revision: "e0b472e46eb5861570497c2b9efabf96f2d4a485"
  end

  def install
    (buildpath/"src").install resource("llvm")
    (buildpath/"src/tools/cling").install buildpath.children - [buildpath/"src"]
    (buildpath/"src/tools/clang").install resource("clang")
    mkdir "build" do
      system "cmake", *std_cmake_args, "../src",
                      "-DCMAKE_INSTALL_PREFIX=#{libexec}",
                      "-DCLING_CXX_PATH=clang++"
      system "make", "install"
    end
    bin.install_symlink libexec/"bin/cling"
    prefix.install_metafiles buildpath/"src/tools/cling"
  end

  test do
    test = <<~EOS
      '#include <stdio.h>' 'printf("Hello!")'
    EOS
    assert_equal "Hello!(int) 6", shell_output("#{bin}/cling #{test}").chomp
  end
end
