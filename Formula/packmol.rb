class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/mcubeg/packmol/archive/20.010.tar.gz"
  sha256 "23285f2a9e2bef0e8253250d7eae2d4026a9535ddcc2b9b383f5ad45b19e123d"
  license "MIT"
  revision OS.mac? ? 1 : 2
  head "https://github.com/mcubeg/packmol.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9715f53e8c9622194f19b3c38278841a0ae9f7f5d85bbc7d0cb9a487f062cded"
    sha256 cellar: :any_skip_relocation, big_sur:       "891b4a635649b6a18cc9f4743ff3c4580dd38deaa6e5b1c17435f0154a528e9b"
    sha256 cellar: :any_skip_relocation, catalina:      "2de3ad79e6630d32fe68ac901ab113ba8ae3370e1976909390bcf4eb76a9a1d9"
    sha256 cellar: :any_skip_relocation, mojave:        "2db13531577dfafcaa3d654a714e0c44503049b968ae3f6622baf3d53933afec"
    sha256 cellar: :any_skip_relocation, high_sierra:   "ccdde7eab41ce8847bc3fcabdb482c68ea3f39c029abe0c146ec9ea370c97bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35c57572b9fecf8b2653d3be1ae8c8bfafb7c77311a98de62253350ab7874082"
  end

  depends_on "gcc" # for gfortran

  resource "examples" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    system "./configure"
    system "make"
    bin.install("packmol")
    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("examples")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end
