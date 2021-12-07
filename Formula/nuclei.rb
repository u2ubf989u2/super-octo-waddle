class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.3.5.tar.gz"
  sha256 "c270d68e5ad72e1bcc608c83d8748ff3ad8d11870f358b157ce646424cd7e0bb"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb90965e077390177ad1a774a07b67818020b471e320bf502c89950c26067dcf"
    sha256 cellar: :any_skip_relocation, big_sur:       "840c6ba7a0fe8e842136a0fe027d3c2bfcbbdf2946d9831e71940caf1ad9873a"
    sha256 cellar: :any_skip_relocation, catalina:      "2b0c6d5e2a0a97e1886a5830acbf022b7c70ba396e7833c974767febfa6413f3"
    sha256 cellar: :any_skip_relocation, mojave:        "8506cc9bf34a9bd2d9ef82ae136632f521685d24587f4a0d6fc8a40ef89a8ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55719178fdda844898c16ab3fac09b817e6b28f45c903d7bf9515824987499a"
  end

  depends_on "go" => :build

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args, "main.go"
    end
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      id: homebrew-test

      info:
        name: Homebrew test
        author: bleepnetworks
        severity: INFO
        description: Check DNS functionality

      dns:
        - name: \"{{FQDN}}\"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - \"IN\tA\"
    EOS
    system "nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
