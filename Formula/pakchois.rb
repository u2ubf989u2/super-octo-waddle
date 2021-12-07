class Pakchois < Formula
  desc "PKCS #11 wrapper library"
  homepage "https://www.manyfish.co.uk/pakchois/"
  url "https://www.manyfish.co.uk/pakchois/pakchois-0.4.tar.gz"
  sha256 "d73dc5f235fe98e4d1e8c904f40df1cf8af93204769b97dbb7ef7a4b5b958b9a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?pakchois[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_big_sur: "86e77a851ff2c0de31cf5e4f2587711b7b1bcc742fb878df1ce69fde836fd864"
    sha256 cellar: :any,                 big_sur:       "fd91b09bb010ac37483a910b0431c6082903ee843a15f4cc767bde57ce0b7267"
    sha256 cellar: :any,                 catalina:      "ca82f2950582bc54e46122eb71ff8e8acdc739772baf53ab2d545755f03303f8"
    sha256 cellar: :any,                 mojave:        "cc98c7b706f27320ee7c673d906b4da22b402afe0d93b4c66f73a8cde86f7929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1383e6f25be65c80cdc38e2911930ee9d1b1560f749fedd975fa4567f73d67c3"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
