class Cgvg < Formula
  desc "Command-line source browsing tool"
  homepage "https://uzix.org/cgvg.html"
  url "https://uzix.org/cgvg/cgvg-1.6.3.tar.gz"
  sha256 "d879f541abcc988841a8d86f0c0781ded6e70498a63c9befdd52baf4649a12f3"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:      "b5d4e1695f676016451d89d502a534d4536449f77ca52091ca49fd0a83909b3c"
    sha256 cellar: :any_skip_relocation, catalina:     "9ba7bdb16162f2ad7cb462cef5ad939ea15f93c759e272bc9fdf8eb9b1ad8df0"
    sha256 cellar: :any_skip_relocation, mojave:       "9f1f8ad71fda5ecf4341a28420e5c1629a4b5285edb5d40fbe13ace1965ea239"
    sha256 cellar: :any_skip_relocation, high_sierra:  "05dcddf73d630ab2f67e00ea63af02f6b29b503c2e938829daa67d7f619fb556"
    sha256 cellar: :any_skip_relocation, sierra:       "12b8a6abb31e2e8d7ba044663b33990884ec24d1b0c0776901480cbecd47113f"
    sha256 cellar: :any_skip_relocation, el_capitan:   "a8232322755cb4c369193dca37fecb968ff689c6463611680e12f216f46507c4"
    sha256 cellar: :any_skip_relocation, yosemite:     "de0c8b890aa68670097790093fdceccfe1d69598c18ea5385069efc2f73a3c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a9fabe57878811418054600d055d15f12daa8a845f577fecea291d1306ddd63d"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test").write "Homebrew"
    assert_match "1 Homebrew", shell_output("#{bin}/cg Homebrew '#{testpath}/test'")
  end
end
