class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "https://pallini.di.uniroma1.it/"
  url "https://pallini.di.uniroma1.it/nauty27r1.tar.gz"
  version "27r1"
  sha256 "76ca5d196e402c83a987f90c28ff706bcc5a333bb4a8fbb979a62d3b99c34e77"

  livecheck do
    url :homepage
    regex(/href=.*?nauty[._-]?v?(\d+(?:\.\d+)*(?:r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6d7980d67e772addbc5220e4536a1193580253ae2a52fbc7182d12eb73573c6b"
    sha256 cellar: :any_skip_relocation, big_sur:       "8714e05e1d050933e8571cca1c388a088d11170757fa5b1ae3fe5be7f490f6b5"
    sha256 cellar: :any_skip_relocation, catalina:      "5d118260b6fdabceb476c1421e4b4dd41d3027943b623ff7a4dc81baf6e284b9"
    sha256 cellar: :any_skip_relocation, mojave:        "2fa3783663f6e67d9a6e42c492c68412fdeeff7201d81e557b75927ff50b78f1"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a5333c52eecb023c23be9638ebd916606db43f8f7ef1d7ada4877ca00355d65a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b43c456103ecf2c1200ede8adbc6ab728527ceb711148edd848950a3917440"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"

    bin.install %w[
      NRswitchg addedgeg amtog assembleg biplabg catg complg converseg
      copyg countg cubhamg deledgeg delptg directg dreadnaut dretodot
      dretog edgetransg genbg genbgL geng gengL genquarticg genrang
      genspecialg gentourng gentreeg hamheuristic labelg linegraphg
      listg multig newedgeg pickg planarg ranlabg shortg showg
      subdivideg twohamg underlyingg vcolg watercluster2
    ]

    (include/"nauty").install Dir["*.h"]

    lib.install "nauty.a" => "libnauty.a"

    doc.install "nug27.pdf", "README", Dir["*.txt"]

    # Ancillary source files listed in README
    pkgshare.install %w[sumlines.c sorttemplates.c bliss2dre.c blisstog.c poptest.c dretodot.c]
  end

  test do
    # from ./runalltests
    out1 = shell_output("#{bin}/geng -ud1D7t 11 2>&1")
    out2 = shell_output("#{bin}/genrang -r3 114 100 | #{bin}/countg --nedDr -q")

    assert_match "92779 graphs generated", out1
    assert_match "100 graphs : n=114; e=171; mindeg=3; maxdeg=3; regular", out2

    # test that the library is installed and linkable-against
    (testpath/"test.c").write <<~EOS
      #define MAXN 1000
      #include <nauty.h>

      int main()
      {
        int n = 12345;
        int m = SETWORDSNEEDED(n);
        nauty_check(WORDSIZE, m, n, NAUTYVERSIONID);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/nauty", "-L#{lib}", "-lnauty", "-o", "test"
    system "./test"
  end
end
