class Wskdeploy < Formula
  desc "Apache OpenWhisk project deployment utility"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-wskdeploy/archive/1.2.0.tar.gz"
  sha256 "bffe6f6ef2167189fc38893943a391aaf7327e9e6b8d27be1cc1c26535c06e86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "87364286a37d26de6a051ba1d0244de932de11058e041e969ea20400560df8e5"
    sha256 cellar: :any_skip_relocation, big_sur:       "c77d6ad2c5fa8acec45bf9507d840f3de1a125edb5759f6de49427efb454fd38"
    sha256 cellar: :any_skip_relocation, catalina:      "17ff44da88c60d8c8c3a17fd4e2844c90d1bf7fe460928ae21731da5a7f52740"
    sha256 cellar: :any_skip_relocation, mojave:        "375d6f828a4a45d398ba11dcee4c60e64651697ee374917db7f2137b4c98cb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd885153d5211d28548dc999625fd57ded5f29be6fe86a485528a10f6ec2ff78"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.Version=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wskdeploy version")

    (testpath/"manifest.yaml").write <<~EOS
      packages:
        hello_world_package:
          version: 1.0
          license: Apache-2.0
    EOS

    system bin/"wskdeploy", "-v",
                            "--apihost", "openwhisk.ng.bluemix.net",
                            "--preview",
                            "-m", testpath/"manifest.yaml",
                            "-u", "abcd"
  end
end
