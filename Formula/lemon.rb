class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://sqlite.org/2021/sqlite-src-3350200.zip"
  version "3.35.2"
  sha256 "6af39632ed596ff3294f35caff4d671745f81894135f9789ceecf696dfc38703"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a287b615e9706e1819125b9ab9648bc437f9e932f378af9c023b23f428020b4b"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ce45a0aa918930d58d30cf6a4c729aecb403ee11016449c95f869eafc5acccc"
    sha256 cellar: :any_skip_relocation, catalina:      "0ce20136a56424d8cc07162171d4a46701a713bcead271d241db135b274d53d3"
    sha256 cellar: :any_skip_relocation, mojave:        "21b0c4309efc6b7c2be0b580806b403034e8c978081f2340a5d887d095f1963d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a1cd944208dc02d3e17ca0ef73c57951d348bee552500a72c18e992f7d39f4e"
  end

  def install
    pkgshare.install "tool/lempar.c"

    # patch the parser generator to look for the 'lempar.c' template file where we've installed it
    inreplace "tool/lemon.c", "lempar.c", "#{pkgshare}/lempar.c"

    system ENV.cc, "-o", "lemon", "tool/lemon.c"
    bin.install "lemon"

    pkgshare.install "test/lemon-test01.y"
    doc.install "doc/lemon.html"
  end

  test do
    system "#{bin}/lemon", "-d#{testpath}", "#{pkgshare}/lemon-test01.y"
    system ENV.cc, "lemon-test01.c"
    assert_match "tests pass", shell_output("./a.out")
  end
end
