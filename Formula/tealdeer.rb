class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://github.com/dbrgn/tealdeer"
  url "https://github.com/dbrgn/tealdeer/archive/v1.4.1.tar.gz"
  sha256 "eaf42fe17be751985cbf46c170ef623fcbd36028c88c2e70823492a9335a4a8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4007bbd16184eea9bb652cfcec1b7456551400f85de61cf080a98046cf79c5dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f323f75b7d481e86187ac45f9931ad114e1a9d4e7035f04a368d690de77e9e0"
    sha256 cellar: :any_skip_relocation, catalina:      "db4a2fc7dceef4f4f914aaf7b655741e960664b46c61ab2c163f015a74949533"
    sha256 cellar: :any_skip_relocation, mojave:        "9ad3e3ea878b05fd2764cc8e534888b8bf810f88cc4d986de158ed6b33633b42"
    sha256 cellar: :any_skip_relocation, high_sierra:   "80a29641c9b29a3cda69adf5afd2c36b27f84fb8f89a555dbf2a676dddf03b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c655031e2d3305ad18448f62790f90afa5e770b7d1aaa7fcc7ba1bb9c5471a35"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    on_linux do
      ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    end
    system "cargo", "install", *std_cargo_args
    bash_completion.install "bash_tealdeer" => "tldr"
    zsh_completion.install "zsh_tealdeer" => "_tldr"
    fish_completion.install "fish_tealdeer" => "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr -u && #{bin}/tldr brew")
  end
end
