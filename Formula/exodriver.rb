class Exodriver < Formula
  desc "Thin interface to LabJack devices"
  homepage "https://labjack.com/support/linux-and-mac-os-x-drivers"
  url "https://github.com/labjack/exodriver/archive/v2.6.0.tar.gz"
  sha256 "d2ccf992bf42b50e7c009ae3d9d3d3191a67bfc8a2027bd54ba4cbd4a80114b2"
  license "MIT"
  head "https://github.com/labjack/exodriver.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "fa9283c7c2a58da585d849ea514ac7f63a1bab2fa7205f24b5c6b7f122218e81"
    sha256 cellar: :any,                 big_sur:       "5fbc6d425b55fc83fc05847a766fa74f33d932c495a4ab7c9b3469441552e489"
    sha256 cellar: :any,                 catalina:      "aa86ed0ef4a6886bf65ba979938202a7bfabf2d844f2ffe14dee2466f3c65e59"
    sha256 cellar: :any,                 mojave:        "9451412a4469cdf44e56eeac4c457a91b3363410859d4d48975ce3223f8b20d2"
    sha256 cellar: :any,                 high_sierra:   "db8ef53e652b1296843207ee4d315b7ce5e7adf35ce5cf07f36d1d3f8dfdd28f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5686297f9c1c8ba86a33c1c050523b885d572e04953d55560fc24e8447fa9af6"
  end

  depends_on "libusb"

  def install
    system "make", "-C", "liblabjackusb", "install",
           "HEADER_DESTINATION=#{include}", "DESTINATION=#{lib}"
    ENV.prepend "CPPFLAGS", "-I#{include}"
    ENV.prepend "LDFLAGS", "-L#{lib}"
    system "make", "-C", "examples/Modbus"
    pkgshare.install "examples/Modbus/testModbusFunctions"
  end

  test do
    output = shell_output("#{pkgshare}/testModbusFunctions")
    assert_match(/Result:\s+writeBuffer:/, output)
  end
end
