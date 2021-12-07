class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "https://github.com/Unidata/UDUNITS-2/archive/v2.2.27.6.tar.gz"
  sha256 "74fd7fb3764ce2821870fa93e66671b7069a0c971513bf1904c6b053a4a55ed1"
  revision 1

  bottle do
    sha256 arm64_big_sur: "11fbb852b729b417f5c3cca75fcf53b30e5e662638ddac30c59c699e04ae7c75"
    sha256 big_sur:       "98494853cf3c9763f511e3f4d1daddd29cbcf8c8a91c4716ed5951e081753bad"
    sha256 catalina:      "b325949e293c7e881bb468893a84e75283587af9ccd21595874eec515d778b9c"
    sha256 mojave:        "4994ec2de43dcff6c6b74b3d7ec053cac4ad475b8c4b95207e7c8b999b43f884"
    sha256 x86_64_linux:  "697aec45dd5b1f4f7822325c3b714698a4a67fb052c026c02738034492a94b4b"
  end

  depends_on "cmake" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "texinfo" => :build
  uses_from_macos "expat"
  uses_from_macos "flex"
  uses_from_macos "texinfo"

  unless OS.mac?
    patch :p1 do
      url "https://github.com/Unidata/UDUNITS-2/commit/0bb56200221ad960bc2da11fc0b4a70ec3c5d7c9.patch?full_index=1"
      sha256 "8b84fabe21d2da252e6bdd2dd514230d73579ca034d4d83e42f40527dc72fe0c"
    end
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "lib/libudunits2.a"
    end
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end
