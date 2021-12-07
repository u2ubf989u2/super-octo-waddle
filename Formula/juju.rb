class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.0",
      revision: "ac860f7db4296273ea2cf213115ec2c229d57a07"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c57ceec3604ef0177eeb1d1fed932b6f7e30d99e225357ff37f8cda8d33d4455"
    sha256 cellar: :any_skip_relocation, big_sur:       "1fff503c36d80ce03b564c4a39d510fa0c76f0ac1fce8b3902b38adb7315faed"
    sha256 cellar: :any_skip_relocation, catalina:      "22f65322460f322ce57a5ee7b3fc71bb373d9c3e0f1e86a283237d56812186ae"
    sha256 cellar: :any_skip_relocation, mojave:        "bee2ed3d9783827e441293f90611b28660d60b7010f056aa8c5c5de2ceff76be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbf4172399d740bd78f108f6995a852985922041b3285a9cf6aaec49a2ac88fb"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args,
                 "-ldflags", ld_flags.join(" "),
                 "./cmd/juju"
    system "go", "build", *std_go_args,
                 "-ldflags", ld_flags.join(" "),
                 "-o", bin/"juju-metadata",
                 "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
