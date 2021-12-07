class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.15195",
      revision: "595cc9e2916f5ab8ba9267657a97f3004a5e11eb"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "96c8a6e002803457c6d6ad478c741cae639eafbb01fe55619ffd733daae0fadb"
    sha256 cellar: :any_skip_relocation, catalina:     "dab02bb6bef331726927c1f14715d3934b7c8ae5cd71aced826db1f58bc092e0"
    sha256 cellar: :any_skip_relocation, mojave:       "995339d1c3d67f26a0fdab94f08df59e4b98c008ca44fae7c7466e09ca54446e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6337a5e45b6a59e699161c727e8c0e51c8b4b1c58f6209f9ac0ce3ba0057a251"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/CircleCI-Public/circleci-cli"
    dir.install buildpath.children

    cd dir do
      ldflags = %W[
        -s -w
        -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
        -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
        -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
      ]
      system "make", "pack"
      system "go", "build", "-ldflags", ldflags.join(" "),
             "-o", bin/"circleci"
      prefix.install_metafiles
    end
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
