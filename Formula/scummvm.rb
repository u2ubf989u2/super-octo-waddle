class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.2.0/scummvm-2.2.0.tar.xz"
  sha256 "1469657e593bd8acbcfac0b839b086f640ebf120633e93f116cab652b5b27387"
  license "GPL-2.0-or-later"
  head "https://github.com/scummvm/scummvm.git"

  livecheck do
    url "https://www.scummvm.org/frs/scummvm/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["']}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "9d0f4d95f666f1a9d2836c8f6c860de097edfe27c351614d644b75f54b862332"
    sha256 big_sur:       "d6d48c84e84ff5adbed86060489c707700f8bc1059196a522575bc1b1ce8b05c"
    sha256 catalina:      "ee689cfa14ba1a822bba247b79b615beae697c568de135c844121e9d51818303"
    sha256 mojave:        "184c5b6dc8caaa144d9cc5fb1b02e419afee2b70323a9908f0996d697de18a03"
    sha256 x86_64_linux:  "4cb2dcd5f6a819bf3bf330346ce4cb7a7500f0ddaeeac9f7b059567c5e7a0849"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-release",
                          "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}"
    system "make"
    system "make", "install"
    (share+"pixmaps").rmtree
    (share+"icons").rmtree
  end

  test do
    on_linux do
      # Test fails on headless CI: Could not initialize SDL: No available video device
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "#{bin}/scummvm", "-v"
  end
end
