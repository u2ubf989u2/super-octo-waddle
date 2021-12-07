class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/v2021.tar.gz"
  sha256 "872fe7a53f91ababaafc964847639e3644f2b9fab3282ea059788e4e18cbba47"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0b92290fc7fb156b76df56ee8992b272fca29ccbe1ec50e7637df550939fcf0d"
    sha256 cellar: :any_skip_relocation, big_sur:       "6872bf6979572c46b6440b7e3a54caa49661fb98348b4eb3be91022f133dede7"
    sha256 cellar: :any_skip_relocation, catalina:      "fed2600e8edb14f29596c2b89720a1e21d19ae27c0c39bdf565c2320b147f553"
    sha256 cellar: :any_skip_relocation, mojave:        "02ffab1491227b84d0accbf77265ae229ac104f5a3b62a51c8c69371d7f976d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55e7e026f468b790021f91798b79f87a6791608a9e7bc3772c07596eb674ca9c"
  end

  depends_on "ghostscript"
  depends_on "netpbm"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-mktexlsr",
                          "--with-texpath=#{share}/texmf/tex/latex/html"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\usepackage[utf8]{inputenc}
      \\title{Experimental Setup}
      \\date{\\today}
      \\begin{document}
      \\maketitle
      \\end{document}
    EOS
    system "#{bin}/latex2html", "test.tex"
    assert_match "Experimental Setup", File.read("test/test.html")
  end
end
