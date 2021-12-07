class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.7.0.tar.gz"
  sha256 "ce4115e3184d0929a90c5e4215d303aa5243e8d49f8576154396098f0c6536fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b9bfd06826a5bc66bcf6616632476c3535f26a9cd5d5955415db1f3b48e9100b"
    sha256 cellar: :any_skip_relocation, big_sur:       "87864462e22abc1dcf9b949c7b9b1106b0e4327fa5aabe94e514a29eeee66a10"
    sha256 cellar: :any_skip_relocation, catalina:      "3838102fe4c61d9dec9d5147f247e1856ec134ebe4a5eb07d12aacf99513a1d9"
    sha256 cellar: :any_skip_relocation, mojave:        "9b4be2cab4a2053e9142af56eeb15c3c91e8fd810f64a073dadf4911c4a59543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "420f675b980785b9872eb40342fb9066cc7051d077f8ed3332bca5c7f70511f0"
  end

  depends_on "go" => :build

  def install
    # raise a quesiton about this setup, https://github.com/pressly/goose/issues/238
    mv "_go.mod", "go.mod"
    mv "_go.sum", "go.sum"

    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
