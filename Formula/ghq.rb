class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.1.7",
      revision: "7f314194088ffbb61a45dade72ae7a13ef84952c"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "415bcc81a4ccc64b2826f4fcce95e38b0ba4da271a25d747459b4edb5e83ec82"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c10e27ea29c0c826277a547516ed8fc2e764b165656ee64271ae4279c93a5ef"
    sha256 cellar: :any_skip_relocation, catalina:      "ba1e0aa00eca4fb0861473eb7ae100c69ed3491fb4844f469944763a2aaae99c"
    sha256 cellar: :any_skip_relocation, mojave:        "c4811a44a52b77365872099ab762a93ef1088686de096ffa1093be1b597b262a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67e4c7ecfc24e16fda7aa8671f88204472dff60ac19a9213ea43914dc2075286"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
