class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.8.0",
      revision: "1e42403fc294ae68aa21ba873fa3f2436688d83b"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "6db240c5ca2ef2f73560596994b36bab3a3b00446886197d485d2503cff5a395"
    sha256 cellar: :any_skip_relocation, catalina:     "732d05ccaf76d20ee1e885e9091fe4e9088135d70962867200ba308168082aa3"
    sha256 cellar: :any_skip_relocation, mojave:       "f7d2967a71ee83fce951d1e80494a546fc88db8f670cf185a5ba478b1fa7b9bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c5b3926947f32d639bc72f6ab177c03c6b1257d38a0d2f56975a86b5a204635d"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e533/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.BazeliskVersion=#{version}"

    bin.install_symlink "bazelisk" => "bazel"

    resource("bazel_zsh_completion").stage do
      zsh_completion.install "_bazel"
    end
  end

  test do
    ENV["USE_BAZEL_VERSION"] = Formula["bazel"].version
    assert_match "Build label: #{Formula["bazel"].version}", shell_output("#{bin}/bazelisk version")

    # This is an older than current version, so that we can test that bazelisk
    # will target an explicit version we specify. This version shouldn't need to
    # be bumped.
    ENV["USE_BAZEL_VERSION"] = "0.28.0"
    assert_match "Build label: 0.28.0", shell_output("#{bin}/bazelisk version")
  end
end
