class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.23.0.tar.gz"
  sha256 "25f36948b704e57c47c98a33280df271de7fbfb74753b4984612eabb08fb2ab1"
  license "MIT"
  revision 1 unless OS.mac?
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6b56c146d2bc161c6214878d142cd67bc646ade222b7e45aab1691f7f3987a37"
    sha256 cellar: :any_skip_relocation, big_sur:       "27e8df90701d0399573a59237fdaa2a1c233ebd1e9007686df7e8a0b2b7d3be4"
    sha256 cellar: :any_skip_relocation, catalina:      "7a8f0e71281afa27399fab199e975f0d717c0593526701d2f43eac2f096a41b9"
    sha256 cellar: :any_skip_relocation, mojave:        "a375cfca74cda33d29bc74ed712e0dedb0495c56a1378a25009edcabcbdb44fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a75ee48eb98086e7a06bd0a9eefa84620031e62533daf861572e05b74afae42f"
  end

  depends_on "python@3.9" unless OS.mac?

  def install
    unless OS.mac?
      Dir["*.py"].each do |file|
        next unless File.read(file).include?("/usr/bin/env python")

        inreplace file, %r{#! ?/usr/bin/env python}, "#!#{Formula["python@3.9"].opt_bin/"python3"}"
      end
    end

    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "homebrew"
    system "git", "commit", "--message", "brewing"

    assert_equal "#{testpath.realpath}/homebrew => archive/homebrew",
                 shell_output("#{bin}/git-archive-all --dry-run ./archive").chomp
  end
end
