class YarnCompletion < Formula
  desc "Bash completion for Yarn"
  homepage "https://github.com/dsifford/yarn-completion"
  url "https://github.com/dsifford/yarn-completion/archive/v0.17.0.tar.gz"
  sha256 "cc9d86bd8d4c662833424f86f1f86cfa0516c0835874768d9cf84aaf79fb8b21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fa61ffe0566b918f54f590d3767cc467f5218f2911b3b5b7f6491d8d5a7e06f0"
  end

  depends_on "bash"

  def install
    bash_completion.install "yarn-completion.bash" => "yarn"
  end

  test do
    assert_match "complete -F _yarn yarn",
      shell_output("#{Formula["bash"].opt_bin}/bash -c 'source #{bash_completion}/yarn && complete -p yarn'")
  end
end
