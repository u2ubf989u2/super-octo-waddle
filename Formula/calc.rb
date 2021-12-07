class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://github.com/lcn2/calc/releases/download/v2.12.9.1/calc-2.12.9.1.tar.bz2"
  sha256 "077928f91353f8b612246d4fe5cba381131cd4e2610cfaa6d4e36b321fbb7c8e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "c43d4895b54f115c90efd1c443c7fbe5ede27d4e85c9df03486fa933d74238a7"
    sha256 big_sur:       "8d5a8c3e371edc4c48905bb6f481fdba1eeb7f9123d724283ed92463b620ed51"
    sha256 catalina:      "0c1d5069406431b8a236c9262675493c6a073c76790607898545b0ed3be51316"
    sha256 mojave:        "05dcd21cd49e6bda31893e7390d47c27be3893335b67bbdb2d68001ca06636de"
    sha256 x86_64_linux:  "74455070d05c5c3be48f50de91eac8ec6f533c1df786db39b2d74872d5226151"
  end

  depends_on "readline"

  on_linux do
    depends_on "util-linux" # for `col`
  end

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    args = [
      "BINDIR=#{bin}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man1}",
      "CALC_INCDIR=#{include}/calc",
      "CALC_SHAREDIR=#{pkgshare}",
      "USE_READLINE=-DUSE_READLINE",
      "READLINE_LIB=-L#{Formula["readline"].opt_lib} -lreadline",
      "READLINE_EXTRAS=-lhistory -lncurses",
    ]
    on_macos do
      args << "INCDIR=#{MacOS.sdk_path}/usr/include"
    end
    system "make", "install", *args

    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
