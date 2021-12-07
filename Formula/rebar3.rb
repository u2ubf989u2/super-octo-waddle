class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.14.4.tar.gz"
  sha256 "8d78ed53209682899d777ee9443b26b39c9bf96c8b081fe94b3dd6693077cb9a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8f036ba3f725ef43b4a7ee18f5e1384411d9916a477dc88e1298b85b3867e6e3"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e2b1a22dce3f1bebc7b8825b6a1454ac4f37c68f85b821df52a56a908b46f38"
    sha256 cellar: :any_skip_relocation, catalina:      "e484c9b86f0997d0f060989ab437ef02168693fde15ae4ac45700f354f604046"
    sha256 cellar: :any_skip_relocation, mojave:        "72082c4fe351b34cf778f4e3acd59381c8c8d66477cfb495be84bd22532b1b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "967a40c04ca5062cac60ae03fb986d8546c975d01ee6042f619c761350143ca2"
  end

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "priv/shell-completion/bash/rebar3"
    zsh_completion.install "priv/shell-completion/zsh/_rebar3"
    fish_completion.install "priv/shell-completion/fish/rebar3.fish"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
