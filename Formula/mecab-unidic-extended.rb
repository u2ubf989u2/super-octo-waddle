class MecabUnidicExtended < Formula
  desc "Extended morphological analyzer for MeCab"
  homepage "https://osdn.net/projects/unidic/"
  # Canonical: https://osdn.net/dl/unidic/unidic-mecab_kana-accent-2.1.2_src.zip
  url "https://dotsrc.dl.osdn.net/osdn/unidic/58338/unidic-mecab_kana-accent-2.1.2_src.zip"
  sha256 "70793cacda81b403eda71736cc180f3144303623755a612b13e1dffeb6554591"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3afff6a9a967b7c92eb79ca6efcaf3289596c331214ba6130989d757cd7757b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "7566096a08a09b4c695c2f59766dc3d8ed5156d87180a3da1d504be9e038a30b"
    sha256 cellar: :any_skip_relocation, catalina:      "2624e794b1f765e78dbd593b50b8ea2b3055ede30192694cfc3ed7f5c4eb8a9b"
    sha256 cellar: :any_skip_relocation, mojave:        "7b297ee9b0d51169a5d5f7dd7047c1aaf18ade6bcaeccf2b570263aa6ab694b2"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8890b4d95d0c3ee114ec48ea95d66c1d8b8a273949a912140fa477ad9265be0b"
    sha256 cellar: :any_skip_relocation, sierra:        "8890b4d95d0c3ee114ec48ea95d66c1d8b8a273949a912140fa477ad9265be0b"
    sha256 cellar: :any_skip_relocation, el_capitan:    "8890b4d95d0c3ee114ec48ea95d66c1d8b8a273949a912140fa477ad9265be0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c14895b68204bd2028de382ab46b5efea0eb4fb218991370930c3a434bff23e0"
  end

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-dicdir=#{lib}/mecab/dic/unidic-extended"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To enable mecab-unidic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
        dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic-extended
    EOS
  end

  test do
    (testpath/"mecabrc").write <<~EOS
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic-extended
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end
