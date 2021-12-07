class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "https://fatsort.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fatsort/fatsort-1.6.3.622.tar.xz"
  version "1.6.3"
  sha256 "481c94ea08f6faaafe67594726d70fb3e3d5ac9672745f0034e55134ea5256fc"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/fatsort[._-]v?(\d+(?:\.\d+)+)\.\d+\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ac151e8d4d374de18d64c637985193f3dcab67930841653466d9986e65312fb3"
    sha256 cellar: :any_skip_relocation, big_sur:       "b4db250147cd55cb86be66c73986c621529c11f855e0cb6be129f92b96b22504"
    sha256 cellar: :any_skip_relocation, catalina:      "c3e2a36f45f08826087b89279cb36c9156024d4ecc0e02a1218dd28d27c6d8b7"
    sha256 cellar: :any_skip_relocation, mojave:        "3f70bababd3108670a3752056ed24b76187df9d82beae1581645b91945cdde2d"
    sha256 cellar: :any_skip_relocation, high_sierra:   "fdecaa643274a1e780ff530801c88cb92a66a49639ced214b29c4703389e0dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41c6196ad862c2cd1c94d5a45ff884a984bec2a4d426bffa50145d56b806cc84"
  end

  depends_on "help2man"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "src/fatsort"
    man1.install "man/fatsort.1"
  end

  test do
    system "#{bin}/fatsort", "--version"
  end
end
