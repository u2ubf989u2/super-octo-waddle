class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.44.0-source/maxima-5.44.0.tar.gz"
  sha256 "d93f5e48c4daf8f085d609cb3c7b0bdf342c667fd04cf750c846426874c9d2ec"
  license "GPL-2.0"
  revision 5

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f7bc55c9d97aa2e7c8c7b10fbaa930ffc03ce57a402a31951b5f356e2074d7a"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd29cae8dfb1b0d92031724d3c357bb232550a871f65148f2dc80be02784d167"
    sha256 cellar: :any_skip_relocation, catalina:      "62c001999af18c02e1bf4726188a567092f004544abb47e11056d6ffd9e2a23d"
    sha256 cellar: :any_skip_relocation, mojave:        "dc66f0dc0c5519449d27a4210ac481b75a00927eb37fb574e1501029bae009c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f4cac0b5785683177b58330ba9a5ffed2c8cb1eaeb25b57f9813a37c39c39fd"
  end

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "perl" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--enable-gettext",
           "--enable-sbcl",
           "--with-emacs-prefix=#{share}/emacs/site-lisp/#{name}",
           "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
