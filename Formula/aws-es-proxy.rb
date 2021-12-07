class AwsEsProxy < Formula
  desc "Small proxy between HTTP client and AWS Elasticsearch"
  homepage "https://github.com/abutaha/aws-es-proxy"
  url "https://github.com/abutaha/aws-es-proxy/archive/v1.2.tar.gz"
  sha256 "5b213e4a37b175238f2587b4eb85681fb6ec8d972dafc0cd8e6680881b9dbbd2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37e07ca5ebf1c86eb72d08cd90df85771c5ab8b496f269bcdc06a0bc526d15fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "c04f0887348bdf1fd322eae80681657ccb57beef3449b62c2e10092f4e1a0964"
    sha256 cellar: :any_skip_relocation, catalina:      "4ea34f837d16948e94a2e612c9d257e553b37f60c305172ea8e34798347f2dbe"
    sha256 cellar: :any_skip_relocation, mojave:        "cc4f13aa9d1aee4a1667a60e5a5a161ae78289fb9a587d12597c379e5c0a9b05"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a3804611f47815c7ba21ea108cb0e077fbfe59c2f52b85c1f778758babbb5a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "847bdfd4c851e6e01c2633763f91891c9fce735238be2c9f0ccca55df7dcd4e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    prefix.install_metafiles
  end

  def caveats
    <<~EOS
      Before you can use these tools you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_CREDENTIAL_FILE="<Path to the credentials file>"
    EOS
  end

  test do
    address = "127.0.0.1:#{free_port}"
    endpoint = "https://dummy-host.eu-west-1.es.amazonaws.com"

    fork { exec "#{bin}/aws-es-proxy", "-listen=#{address}", "-endpoint=#{endpoint}" }
    sleep 2

    output = shell_output("curl --silent #{address}")
    assert_match endpoint, output
    assert_match "no such host", output
  end
end
