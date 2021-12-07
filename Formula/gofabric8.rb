class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.176.tar.gz"
  sha256 "78e44fdfd69605f50ab1f5539f2d282ce786b28b88c49d0f9671936c9e37355a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:      "4d4236c764b54c4699ceaf07831bb6fcd5709e99b343c8a2b5288ff3faa40f94"
    sha256 cellar: :any_skip_relocation, catalina:     "6400faecf5cfe3dfa54a04839869d327cc3f71d586aa5740d9f63e1e1f13c5f4"
    sha256 cellar: :any_skip_relocation, mojave:       "6fefb818e47769d4c0811db307d5000aa7d3d48bcdae42e24b0a27272e01641f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "eea1c25113ff1206605e91ce87a817bb3eece380f9788a1385332c74827cd364"
  end

  deprecate! date: "2020-11-27", because: :repo_archived

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/fabric8io/gofabric8"
    dir.install buildpath.children

    cd dir do
      system "make", "install", "REV=homebrew"
      prefix.install_metafiles
    end

    bin.install "bin/gofabric8"
  end

  test do
    Open3.popen3("#{bin}/gofabric8", "version") do |stdin, stdout, _|
      stdin.puts "N" # Reject any auto-update prompts
      stdin.close
      assert_match "gofabric8, version #{version} (branch: 'unknown', revision: 'homebrew')", stdout.read
    end
  end
end
