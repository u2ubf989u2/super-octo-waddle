class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.112.1",
      revision: "851f36f0007cd1dc8e4630fed6f37700bc7938f6"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e986bedca9a271669545fecd35a2224b3aaf50faadf020281659b2cbe411dffc"
    sha256 cellar: :any,                 big_sur:       "088abcb908132790f9f8bff57ccee0e9e659a863f474fee2eb7da81a26f6bbad"
    sha256 cellar: :any,                 catalina:      "89bccbcfddbcb9735dc7db19b540ac0bc2773d790bcbfb681d8ff71be92997f6"
    sha256 cellar: :any,                 mojave:        "3f6bb967afe237c31277641d6fdd54b48b4fa41932b010f675438caccdf0507d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ef6bbc438d1c2db2d8fcfdf4eb089605861594701574e7ed77e53182abf66be"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkg-config" => :build
    depends_on "ragel" => :build
  end

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end
