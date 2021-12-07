class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.2.tar.xz"
  sha256 "f7516ba9d8689343594356f0e5e1a5f0da34adfbc89023437735872bb5024c5f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ae1263956351e0cc6482a31d4950008804c2a1bd72567d06759fcf81884271c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca1fed65658b4bc72775636b6cb21e30dd0ff3e0521b80eda2ed37119f89838d"
    sha256 cellar: :any_skip_relocation, catalina:      "e923cad6e80e57326467d08fecdda7150bb3a6a05c8d1d1b33dac1ef54b19e70"
    sha256 cellar: :any_skip_relocation, mojave:        "9418bd6b173a0af13f89d10487129b7bfcd5690eb58fb3a1e253f5eadf03acdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7be2f92c6d75badaaeff1f0b82502afc4e1617590c217f6a8b8155c9092003a7"
  end

  keg_only (OS.mac? ? :provided_by_macos : "this formula conflicts with util-linux")

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
