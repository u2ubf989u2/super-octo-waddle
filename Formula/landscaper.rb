class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      tag:      "v1.0.24",
      revision: "1199b098bcabc729c885007d868f38b2cf8d2370"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Eneco/landscaper.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "bad7cf082826c5d92dd8c09a79b682e1582fcfc3f4e471dde4112393ec7095ce"
    sha256 cellar: :any_skip_relocation, catalina:     "74decffaf180e0e0dd9bfa2312877da01443a3418afe0f485c1b655c4af1da41"
    sha256 cellar: :any_skip_relocation, mojave:       "ff82cdb7be6329f9a4a5ce34bcbb04bc9356ab46fa3ecd30b830cf35df268529"
    sha256 cellar: :any_skip_relocation, high_sierra:  "68302c1748fe4eb063855df24420a8681a54b8ce484f2e030616bd4c4a812d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6f860ab3aeb8f760ef14307e0ae93b680101857070512066ffe955d5ffb1a88b"
  end

  # also depends on helm@2 (which failed to build)
  deprecate! date: "2020-04-22", because: :repo_archived

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "helm@2"
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    ENV["TARGETS"] = "darwin/amd64"
    dir = buildpath/"src/github.com/eneco/landscaper"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "bootstrap"
      system "make", "build"
      bin.install "build/landscaper"
      bin.env_script_all_files(libexec/"bin", PATH: "#{Formula["helm@2"].opt_bin}:$PATH")
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/landscaper apply --dry-run 2>&1", 1)
    assert_match "This is Landscaper v#{version}", output
    assert_match "dryRun=true", output
  end
end
