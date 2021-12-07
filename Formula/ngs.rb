class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/v0.2.11.tar.gz"
  sha256 "8dea7245f9e3e3188082f5e531a364bae94f8d3f336431d00a49dfc458305a67"
  license "GPL-3.0"
  head "https://github.com/ngs-lang/ngs.git"

  bottle do
    sha256 cellar: :any,                 big_sur:      "0c479302f362f5a29d560cb329fdd23f661029ad21ca572aa77bae7d4d6329ca"
    sha256 cellar: :any,                 catalina:     "d7635955a01a24e1873b3f2b525cb23a1ad0053210da2a651bf04c4a66bc593c"
    sha256 cellar: :any,                 mojave:       "f4592f29a531af5e177e3e3c4f823f61f74101524f52794771bc3c841661b4b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "89653ad6efd71e7b7c81c53b63505cded414e2641622a4213bbcedadf2f21fdb"
  end

  depends_on "cmake" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "gnu-sed"
  depends_on "json-c"
  depends_on "pcre"
  depends_on "peg"

  uses_from_macos "libffi"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    share.install prefix/"man"
  end

  test do
    assert_match "Hello World!", shell_output("#{bin}/ngs -e 'echo(\"Hello World!\")'")
  end
end
