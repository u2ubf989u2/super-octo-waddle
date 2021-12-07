class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat30_5_src.tar.gz"
  version "3.0#5"
  sha256 "ea230479b31e207a94b2800d2688d9b798a2353910f871001835723ce472ddb0"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "0b46597446fbf2a89bcf167c1074130adbcd78224c0abf730549dd1276294e06"
    sha256 cellar: :any_skip_relocation, catalina:     "9333c71b38ab368a6cf59aff288a941309f464922323066f060ebdc9767def27"
    sha256 cellar: :any_skip_relocation, mojave:       "45f854d102acb4e041f176049552072b8a34f7b586af655cc28053688b151670"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "33e91b4b277dc24abbc153243b2d84ab4c4127a640ab819b208b20e51ed9a2a4"
  end

  def install
    ENV.cxx11 unless OS.mac?
    makefile = OS.mac? ? "Makefile.mac64" : "Makefile.linux64"
    system "make", "-C", "emu", "-f", makefile
    bin.install "emu/picat" => "picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end
