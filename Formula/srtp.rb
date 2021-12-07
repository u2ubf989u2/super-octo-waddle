class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.3.0.tar.gz"
  sha256 "94093a5d04c5f4743e8d81182b76938374df6d393b45322f24960d250b0110e8"
  license "BSD-3-Clause"
  head "https://github.com/cisco/libsrtp.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "60ba6d403720966a354577c14dbacaa27980f292eb71dec3d32472e0aa2aa659"
    sha256 cellar: :any, big_sur:       "c7d718635bf47976fd6458c37a3373be978e0254811d5249477a83bf4b885388"
    sha256 cellar: :any, catalina:      "b96d4c3bb159a6f43d5bdd9cc0be0d8deecb06c95df19f2d9cc1f517ffc64ad6"
    sha256 cellar: :any, mojave:        "4bbad999b46dd545aa32882e968d441f5d5e709dc8549ef79e3885dd49fcb964"
    sha256 cellar: :any, high_sierra:   "5c70c41484064bbe25c31a19fc2cffc5cbea3de27e837a039b17767aeb1b57b8"
    sha256 cellar: :any, x86_64_linux:  "6127178b734c7c1a686398eafcaf619219d31d80cc5db73edb477c7a044135ed"
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "test"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
    libexec.install "test/rtpw"
  end

  test do
    system libexec/"rtpw", "-l"
  end
end
