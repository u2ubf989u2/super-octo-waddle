class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.1/hamlib-4.1.tar.gz"
  sha256 "b4d4b9467104d1f316c044d002c4c8e62b9f792cbb55558073bd963203b32342"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "69ca3e44a728006591fbfd52e8941f630b60a5f78491f5c7a7b00e73d5c09d3a"
    sha256 cellar: :any,                 big_sur:       "9ceda629c590e4f94150d19b65d41ad60692c36e95a15f3a402a7b77b77264ec"
    sha256 cellar: :any,                 catalina:      "8438ca728e483627d35c770a76a07d814336e469619e1b7f9baa3f8a3659d0cf"
    sha256 cellar: :any,                 mojave:        "af9e82439e617309d3d5f979347d0ffd5c3b65768ffc5f93f8031fd74ee71178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee444856e77017b50b0105a4b22757c8ebff45db20871c43c40abdcb7e70d55d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
