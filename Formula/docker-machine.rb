class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
      tag:      "v0.16.2",
      revision: "bd45ab13d88c32a3dd701485983354514abc41fa"
  license "Apache-2.0"
  head "https://github.com/docker/machine.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8ed6a73a1d30c911811e8f6fb0e61e41bc3be4aea62bc2b77f7b6dca50b517a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "720ea8bbbfdc6b9d0701f02014e09f6a46e6785bcbdb36ebe3e95bddd0849dfa"
    sha256 cellar: :any_skip_relocation, catalina:      "e27501077ccc67fc468ca8e2881366a9fc23260296ed93a3f436b4d12f41ec43"
    sha256 cellar: :any_skip_relocation, mojave:        "0cfe7d344bd6c2b3bc0d1c1de472c430162a45dd54454b268e82750094b9cf9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbf1391f6ba7ecc6b90de8878297cf695cb700cae687e24b298004c8e108b14e"
  end

  depends_on "automake" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker/machine").install buildpath.children
    cd "src/github.com/docker/machine" do
      system "make", "build"
      bin.install Dir["bin/*"]
      bash_completion.install Dir["contrib/completion/bash/*.bash"]
      zsh_completion.install "contrib/completion/zsh/_docker-machine"
      prefix.install_metafiles
    end
  end

  plist_options manual: "docker-machine start"
  service do
    run [opt_bin/"docker-machine", "start", "default"]
    environment_variables PATH: std_service_path_env
    run_type :immediate
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output(bin/"docker-machine --version")
  end
end
