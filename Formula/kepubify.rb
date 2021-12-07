class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/v3.1.6.tar.gz"
  sha256 "09b81eff1cf53fb184773cf289c1eee56c3354cf6e1efddb5e308566b31de69f"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b38ad070890e803edf906436df1c6080c741c0af97ceaed978c35b56706783f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "ab32b2f204c1f4ece431637f102377f7eb75d9dd186699aabb6e915d0bab3846"
    sha256 cellar: :any_skip_relocation, catalina:      "02f990a949cebef432e4355e90c5e4685d85f556519392ecb425a0d7e0730add"
    sha256 cellar: :any_skip_relocation, mojave:        "6f5f0a9dff4919fbdd57fece754775014f2528fdd86e0f6a3ed5b30333d14435"
    sha256 cellar: :any_skip_relocation, high_sierra:   "ea8a1abda1b013780b9475fdcd9ee1332fbb33d22e8e41a43bfd4ad7b99bbfd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6f2c71c2f4911e3c95cb516ebf7f91f9bd0500147a86a51e08977bf854bb46e"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    %w[
      kepubify
      covergen
      seriesmeta
    ].each do |p|
      system "go", "build", "-o", bin/p,
                   "-ldflags", "-s -w -X main.version=#{version}",
                   "./cmd/#{p}"
    end

    pkgshare.install "kepub/test.epub"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", pkgshare/"test.epub"
    assert_predicate testpath/"test_converted.kepub.epub", :exist?
  end
end
