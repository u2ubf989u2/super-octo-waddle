class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.3.3",
      revision: "000292ce6d99ed658f6f9aebabc6e9b330696e7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b5365cde699802720656bfa80f19f09f49825fd0f3156a7ce6c5a4cd5ccaf84d"
    sha256 cellar: :any_skip_relocation, big_sur:       "42a3ec388bf05959fbd05c6b918cad2fba99a2a1812e9916e7ae9cd92dfb7af8"
    sha256 cellar: :any_skip_relocation, catalina:      "b27e1a0394848b9840c09198bda4cae9bc57314ce833082f701336c434bbd4c8"
    sha256 cellar: :any_skip_relocation, mojave:        "2a65f86dc8a2d9576c64a94f2296c481880482739d80dca988abf6a96e1ccf34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f905fc6d7cd5b3a28da23db9f9d36f944ba906322f76cbe933dce95c34f7638"
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "numpy"
  depends_on "scipy"

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "demo"
  end

  test do
    cp_r (pkgshare/"demo"), testpath
    cd "demo/data" do
      cp "../CLI/binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end
