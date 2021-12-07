class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.20.1.tar.gz"
  sha256 "e973330d717bd0d8af0e4c510a7015e77a467e8bbe321e305118398578434717"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5b32f53978ce16e9c2adfa8026261946a4536b901b662ded443c99a71824e452"
    sha256 cellar: :any,                 big_sur:       "7ffb3d7af88ac5bdda2bf13f68f4e3d7a3243761b4c1097afd1b8962593eccee"
    sha256 cellar: :any,                 catalina:      "3b19b2480ca176ed1ccea49442c202f5ae2988ebbf61a6666d6ab68869a1bb8a"
    sha256 cellar: :any,                 mojave:        "cb3ff1efd4d5d823c75a6128f65574cf8f846e9434269aeac56ce00d61c44704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e08df00a83f2fb0d8089bf6323cf2e4bdfaa1cb8394b5cd174d32db08b27ad1b"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libsodium"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "cargo", "install", *std_cargo_args

    system "#{bin}/sn0int completions bash > sn0int.bash"
    system "#{bin}/sn0int completions fish > sn0int.fish"
    system "#{bin}/sn0int completions zsh > _sn0int"

    bash_completion.install "sn0int.bash"
    fish_completion.install "sn0int.fish"
    zsh_completion.install "_sn0int"

    system "make", "-C", "docs", "man"
    man1.install "docs/_build/man/sn0int.1"
  end

  test do
    (testpath/"true.lua").write <<~EOS
      -- Description: basic selftest
      -- Version: 0.1.0
      -- License: GPL-3.0

      function run()
          -- nothing to do here
      end
    EOS
    system "#{bin}/sn0int", "run", "-vvxf", testpath/"true.lua"
  end
end
