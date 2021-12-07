class CernNdiff < Formula
  desc "Numerical diff tool"
  # NOTE: ndiff is a sub-project of Mad-X at the moment..
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/5.06.01.tar.gz"
  sha256 "cd2cd9f12463530950dab1c9a26730bb7c38f378c13afb7223fb9501c71a84be"
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41ade2330d98fa812fe2e1e89751a8054ab9e9cc4cd9d173f5d9aee55796f3f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "6cf0cf2abed2d829e8e4f03ef88cbb3f225e42334091bb41bbbce269f7828eb7"
    sha256 cellar: :any_skip_relocation, catalina:      "2c91f51a18d6d7aaa821c6f7e43d624289ef2d12144a35f9eeb995fbf7263d0a"
    sha256 cellar: :any_skip_relocation, mojave:        "3398977b827a2f82dac08a2ec7d7b5289e61189bc7747ff2ab77a8f9ef9e23e1"
    sha256 cellar: :any_skip_relocation, high_sierra:   "87aae51415565cadb2dffdae5dff93b472039b4f1ad90462b282e6fb7c855e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd5ba2fdad8c58a06969bbfd36dbf3d56db03300a4d8804a0748abd19a979de"
  end

  depends_on "cmake" => :build

  def install
    cd "tools/numdiff" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"lhs.txt").write("0.0 2e-3 0.003")
    (testpath/"rhs.txt").write("1e-7 0.002 0.003")
    (testpath/"test.cfg").write("*   * abs=1e-6")
    system "#{bin}/ndiff", "lhs.txt", "rhs.txt", "test.cfg"
  end
end
