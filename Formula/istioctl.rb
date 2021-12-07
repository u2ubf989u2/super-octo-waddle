class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.9.4",
      revision: "13fb8ac89420d8cc5b3f895adc614233e805a61c"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "174f562463f3ca3109e12390971dfced94cb5c6c3002816c643e03e1db0db650"
    sha256 cellar: :any_skip_relocation, all:          "61d774242dc049cdb93a8d65ad2485bdea34d3433ff994162d574b791472d7f0"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    system "make", "gen-charts", "istioctl", "istioctl.completion"
    dirpath = nil
    on_macos do
      dirpath = "darwin_amd64"
    end
    on_linux do
      dirpath = "linux_amd64"
    end
    cd "out/#{dirpath}" do
      bin.install "istioctl"
      bash_completion.install "release/istioctl.bash"
      zsh_completion.install "release/_istioctl"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
