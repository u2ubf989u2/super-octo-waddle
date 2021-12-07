class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.7.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.7.6.tar.xz"
  sha256 "67d68ce1e22192050525643fc0a7a22297576682bef6a5c51446903f5aeef3cf"
  license "GPL-3.0-or-later"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee20f2693b08afe6bf50abad5e9a6adf60b629360c64fb580f0512283d87846f"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f57b6c53d6595330adf79112e72034895f061769ebc8906a9b5afe9f4f873d0"
    sha256 cellar: :any_skip_relocation, catalina:      "2276ffa48c694379540f63a5241c39b738f1dcb7424aceec54beb2e7be172489"
    sha256 cellar: :any_skip_relocation, mojave:        "0dca09521f16b6e49e2c21ae9dec6069fee065a9ffd4b8191dca66b1957937d6"
    sha256                               x86_64_linux:  "223e8a0d0ccda242cb92668da34874e273f3f51da657d4b40f449b1e7cbd6e64"
  end

  keg_only :provided_by_macos

  uses_from_macos "m4"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-relocatable",
                          "--prefix=/output"
    system "make", "install", "DESTDIR=#{buildpath}"
    prefix.install Dir["#{buildpath}/output/*"]
  end

  test do
    (testpath/"test.y").write <<~EOS
      %{ #include <iostream>
         using namespace std;
         extern void yyerror (char *s);
         extern int yylex ();
      %}
      %start prog
      %%
      prog:  //  empty
          |  prog expr '\\n' { cout << "pass"; exit(0); }
          ;
      expr: '(' ')'
          | '(' expr ')'
          |  expr expr
          ;
      %%
      char c;
      void yyerror (char *s) { cout << "fail"; exit(0); }
      int yylex () { cin.get(c); return c; }
      int main() { yyparse(); }
    EOS
    system "#{bin}/bison", "test.y"
    system ENV.cxx, "test.tab.c", "-o", "test"
    assert_equal "pass", shell_output("echo \"((()(())))()\" | ./test")
    assert_equal "fail", shell_output("echo \"())\" | ./test")
  end
end
