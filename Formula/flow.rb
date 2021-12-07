class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.150.0.tar.gz"
  sha256 "799e23c1885adeebb2f1fa8595db3a78f0d074fe38314394db960d2de7c53e99"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "119f00bcc233dd70c2ca8c05c85d86f0c0efce921b6a459174ce57e53d1c28b7"
    sha256 cellar: :any_skip_relocation, catalina:     "f5e482fd49d0eecada8cc9496a157057d66aed68e1f187c906ad16ef3296d8f5"
    sha256 cellar: :any_skip_relocation, mojave:       "26d9ac15e260e8b2a6caf55d5d7894cd3149f14879c0c06715dc1c5938ebe09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ea761bc2b87ed1740cddee73445524376d579d1ac55f2f4a805a587b923e9d54"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
