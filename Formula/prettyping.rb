class Prettyping < Formula
  desc "Wrapper to colorize and simplify ping's output"
  homepage "https://denilsonsa.github.io/prettyping/"
  url "https://github.com/denilsonsa/prettyping/archive/v1.0.1.tar.gz"
  sha256 "48ff5dce1d18761c4ee3c860afd3360266f7079b8e85af9e231eb15c45247323"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "313610e9eeac388834b3425d48c2948b940fdd5ee6d73243a46c604ac8768dfb"
  end

  # Fixes IPv6 handling on BSD/OSX:
  # https://github.com/denilsonsa/prettyping/issues/7
  # https://github.com/denilsonsa/prettyping/pull/11
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6ecea23/prettyping/ipv6.patch"
    sha256 "765ae3e3aa7705fd9d2c74161e07942fcebecfe9f95412ed645f39af1cdda4b0"
  end

  def install
    bin.install "prettyping"
  end

  test do
    system "#{bin}/prettyping", "-c", "3", "127.0.0.1"
  end
end
