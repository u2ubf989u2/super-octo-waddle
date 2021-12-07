class Cwlogs < Formula
  desc "CLI tool for reading logs from Cloudwatch Logs"
  homepage "https://github.com/segmentio/cwlogs"
  url "https://github.com/segmentio/cwlogs/archive/v1.2.0.tar.gz"
  sha256 "3f7b56b49c42c1de0e697fc391abad07b03434cff36b153249dd2af3107e064e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:      "40fdfc79d6533963798aed789fe8026f30d44e87c3e6e9ecd602d531ed1fb7c2"
    sha256 cellar: :any_skip_relocation, catalina:     "975da66abe1ce9ff42eb63453c52acc31aeeffff435a2c0aab9d1bd3008be280"
    sha256 cellar: :any_skip_relocation, mojave:       "d0e1bda71db260a905c5f88da3fce0074ab59576ef6c12948eeae2ae5faf6435"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "93fe2f05d2d458b93b4ab543b35442d00c2af9444f1696e6f05bf6f0c55df97b"
  end

  # https://github.com/segmentio/cwlogs/issues/37
  deprecate! date: "2021-02-21", because: :unmaintained

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV["GO111MODULE"] = "auto"

    path = buildpath/"src/github.com/segmentio/cwlogs"
    path.install Dir["{*,.git}"]

    cd "src/github.com/segmentio/cwlogs" do
      system "govendor", "sync"
      system "go", "build", *std_go_args, "-ldflags", "-X main.Version=#{version}"
    end
  end

  test do
    output = shell_output("#{bin}/cwlogs help")
    assert_match "cloudwatch logs", output
  end
end
