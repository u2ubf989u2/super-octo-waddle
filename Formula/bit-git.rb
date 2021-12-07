class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v1.1.1.tar.gz"
  sha256 "17e089162b8c0264e51024779a78f54b4eb413bfafdfba7d785725bf6a850a54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a008cd0a889dd9ac99e11bbe4bc90f1b4a579d9a38494db3a8257a99e7c39526"
    sha256 cellar: :any_skip_relocation, big_sur:       "b64b8e0e366172d44311f618702951e40fc24c76f9927178077e19d3c6003dcb"
    sha256 cellar: :any_skip_relocation, catalina:      "78da2a44bb8b9c55439cfdfd7aa3bcc0307bdefe67565767d1fec8a7d4485bea"
    sha256 cellar: :any_skip_relocation, mojave:        "2404691728cd5bc9c10bb5cfdba8d2f83989c3507b97e110904ec88132284154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef1ce97d93693a9d65d01a47b4b357982adacd3562cf93fdf2410d0f4a8cfc07"
  end

  depends_on "go" => :build

  conflicts_with "bit", because: "both install `bit` binaries"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=v#{version}"
    bin.install_symlink "bit-git" => "bit"
  end

  test do
    system "git", "init", testpath/"test-repository"

    cd testpath/"test-repository" do
      (testpath/"test-repository/test.txt").write <<~EOS
        Hello Homebrew!
      EOS
      system bin/"bit", "add", "test.txt"

      output = shell_output("#{bin}/bit status").chomp
      assert_equal "new file:   test.txt", output.lines.last.strip
    end
  end
end
