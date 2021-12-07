class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.10.2.tar.gz"
  sha256 "15300f1470981dd975af8f8f6db26c51d3e5a10bda73f6c267fc1cebef9a4205"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d2ab672db7722e8938e72980ca9a503bc2281bcc91eb207605f1aaa26d3b062"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3e275586ef94ecde79577a2fce45cdfd5666e3ea084cdf646135a8aeaf25eca"
    sha256 cellar: :any_skip_relocation, catalina:      "ab18f36406506f0250b9067024c674bfb36cdfa737b87ec32a9009bacc8e9c40"
    sha256 cellar: :any_skip_relocation, mojave:        "f57c0467bb39ea4e241027cf72d7f1ac616d61654709da809fcffa9df4797f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baedfc991dcbbb8f59b6b4a2f165169998acbc3bb2a007b1c9e4ef11a53cd417"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
