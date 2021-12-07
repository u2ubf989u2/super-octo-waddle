class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.2.4.tar.gz"
  sha256 "cab10a689c09689175774c78d7c38e594539c18d4581610bb7927d299d0435d8"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b494228f9839518b1cbdfc997fbe2a532be09455c2015cd0d943009fc9e5059"
    sha256 cellar: :any_skip_relocation, big_sur:       "358a7e5a10551dd48ded79d50e587d41ae2910eb700241cba5e1272759923f82"
    sha256 cellar: :any_skip_relocation, catalina:      "c317ad8439c40c66664c00fb4a3b30ed945c86712381ce29b842a2c9bf64ad0d"
    sha256 cellar: :any_skip_relocation, mojave:        "08ad18eec7fb8b813b03b3b9e19d0557edd17bcdb2b373bd80087769efd619f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "953e1134186e97c14622679c739d92ea964b8f3dbb9b88cb61ee3465599e6dd0"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-ldflags",
                          "-w -s -extldflags '-static' -X main.version=#{version}",
                          "-o", "#{bin}/shfmt", "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt  --version")

    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
