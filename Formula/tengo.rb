class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.7.0.tar.gz"
  sha256 "c0fed80496757f6641b5f60dd5d160292ce2f85d963f5ff862cead95df216344"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3d202d97283a438d794342dbe1493da490d8037a39bdaca4390def38b3aafe0"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4135fd4371df7996b6212d4f389773c867a5709436d7ee81d65cac06399789e"
    sha256 cellar: :any_skip_relocation, catalina:      "3ee279cb8c0fc8ca23feb76bc82e1744995904847006090423b303e3f07f5bc1"
    sha256 cellar: :any_skip_relocation, mojave:        "bdc1d71d25be76a26f038353cb2824a8f7bdfe2e53122ae19e0723439db0d1f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acd6d0d5c63956c8bb7958e926114f426ca419cc658df7a2465c36870cee1a22"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tengo"
  end

  test do
    (testpath/"main.tengo").write <<~EOS
      fmt := import("fmt")

      each := func(seq, fn) {
          for x in seq { fn(x) }
      }

      sum := func(init, seq) {
          each(seq, func(x) { init += x })
          return init
      }

      fmt.println(sum(0, [1, 2, 3]))   // "6"
      fmt.println(sum("", [1, 2, 3]))  // "123"
    EOS
    assert_equal shell_output("#{bin}/tengo #{testpath}/main.tengo"), "6\n123\n"
  end
end
