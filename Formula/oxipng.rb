class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v4.0.3.tar.gz"
  sha256 "431cb2e2eaabb3ebe06661ad84bc883bda5500ef559608487c91842a0ae76ea1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "264f1ab92ac0dc6595d395a52fb32c0fe0711a9592d80d2e7c00584ce5f15e63"
    sha256 cellar: :any_skip_relocation, big_sur:       "9de887c99b435d7f3c8a5567b0ea9bd68b2eb3a9e7095fc6f68261325aeefc4f"
    sha256 cellar: :any_skip_relocation, catalina:      "84295509fae9c40435518c4fa5ba2e2b8ed45b271e70a2ecefb21de5c091e177"
    sha256 cellar: :any_skip_relocation, mojave:        "9278cd1e4ce418514c4c34b3898371c360ed770ed583c6b9acfbd39c447c5103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5e78da03e5652036e26858f46af3b710b9e1a6a65e42b07a75feafc73d57ca1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
