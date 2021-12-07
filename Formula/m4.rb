class M4 < Formula
  desc "Macro processing language"
  homepage "https://www.gnu.org/software/m4"
  url "https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz"
  mirror "https://ftpmirror.gnu.org/m4/m4-1.4.18.tar.xz"
  sha256 "f2c1e86ca0a404ff281631bdc8377638992744b175afb806e25871a24a934e07"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1db2471add366dde3b52f8d2d32e6d118584f91d1390d8efd6c10c41c9d6a45c"
    sha256 cellar: :any_skip_relocation, big_sur:       "0df9083b268f76a3cda0c9f0d2ce84b51d21a8618d578740646fb615b00c7e7b"
    sha256 cellar: :any_skip_relocation, catalina:      "2fdf452c94c6b63ea0a45608c19a4477acaf79853a298d337360971c5d51413b"
    sha256 cellar: :any_skip_relocation, mojave:        "2c0f28d612ba588cd6bf8380c6e286c9d3e585dcd8c4ad198b955c9e8cd1d817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1552dd0379252680e0c32085df6b6ab59aa32f45be389ff18620a073a8f3c78c"
  end

  keg_only :provided_by_macos

  # Fix crash from usage of %n in dynamic format strings on High Sierra
  # Patch credit to Jeremy Huddleston Sequoia <jeremyhu@apple.com>
  if MacOS.version >= :high_sierra
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/edf0ee1e2cf/devel/m4/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
  end

  on_linux do
    # Glibc no longer provides several required symbols since version 2.28.
    # Gnulib, bundled into m4, and the dependent of those removed symbols
    # would no longer compile without an upstream fix applied.
    # - https://github.com/coreutils/gnulib/commit/4af4a4a71827c0bc5e0ec67af23edef4f15cee8e#diff-5bcce8ce55246264586c4aed2a45ff89
    # Patch the copy of gnulib bundled with the m4 1.4.18 distribution.
    # - https://lists.gnu.org/archive/html/bug-m4/2018-08/msg00000.html
    patch do
      url "https://raw.githubusercontent.com/archlinux/svntogit-packages/19e203625ecdf223400d523f3f8344f6ce96e0c2/trunk/m4-1.4.18-glibc-change-work-around.patch"
      sha256 "fc9b61654a3ba1a8d6cd78ce087e7c96366c290bc8d2c299f09828d793b853c8"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Homebrew",
      pipe_output("#{bin}/m4", "define(TEST, Homebrew)\nTEST\n")
  end
end
