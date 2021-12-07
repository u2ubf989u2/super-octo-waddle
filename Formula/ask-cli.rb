require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.22.4.tgz"
  sha256 "9661eea17000fa5a6d3fd088546175d38ed4da55be7ab723f04e84eb2f7e97ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "188b7e276246c8084ed5e9c9e35e80aceb05b5c4c6ddfba5b4d3c4681ae0aba3"
    sha256 cellar: :any_skip_relocation, big_sur:       "d294fde163d254091d70290b044ef203a8845936a368eb049ebd825b5b875fd9"
    sha256 cellar: :any_skip_relocation, catalina:      "1e9dc2f8c69bb0dfe2bfd78b78f724427d26f0f01e79b7cfe1c3c360e880aa85"
    sha256 cellar: :any_skip_relocation, mojave:        "30a69e559f02cf7fd6bb4f7190bd71703c18885a826eb9c13f7c71777c124193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad51150496f0b74c29af9e763703f6a48047cd3af1566636bd685c3bba7fbd54"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end
