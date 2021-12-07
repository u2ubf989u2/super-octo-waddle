class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.14.1.tar.gz"
  sha256 "68e60eff0f225e774577e3ca99b2393c0f4291052bfe8abcf316c0294bc4cc37"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "91e84f5352deca91658b6330887a9a45e44b18c0aab8f3c072845f5aff190e15"
    sha256 cellar: :any_skip_relocation, big_sur:       "d8dec01655d7cfe3b913c342155b4bc30285f4f153d51a19eba04158f9b479c9"
    sha256 cellar: :any_skip_relocation, catalina:      "8ba89d27ea59b8a1c941a70f02456b883cd87a34a8fd8b919471516c7f0618e8"
    sha256 cellar: :any_skip_relocation, mojave:        "52323c711f72f07a71783462b381131e1c73de1f800477857ce604c98913d5fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49427952144532e39991f0e208c93e9d184173046935b42d958cb318cfde311e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
