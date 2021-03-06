class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/zhangn1985/ykdl"
  url "https://github.com/zhangn1985/ykdl/archive/v1.7.0.tar.gz"
  sha256 "44e9d946c0e311a5469319a200af5bc5a6e461efa0f117f6a9608f820f22ecb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b5b6fcdfe59c2296f42ae8f2f0a634bba9d952a3d7af4b411a2fc8a238cc112c"
    sha256 cellar: :any_skip_relocation, big_sur:       "39f6e7ed8a11ec0a6eab3cb3e3236d261aa2490fc9e5697c75ecfc37ae33bead"
    sha256 cellar: :any_skip_relocation, catalina:      "797ce1b9f6002a6153019355f957013c078fbe3a36a709293b32a717ff78c30d"
    sha256 cellar: :any_skip_relocation, mojave:        "163c3593145fc6f85b00be215f20c5393219147af348c4c90dc34c942e5966f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac52590515b8ee0d125dc28dab4f69f2820a63d7274d87c5feab2965523824e"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To merge video slides, run `brew install ffmpeg`."
  end

  test do
    system bin/"ykdl", "--info", "https://v.youku.com/v_show/id_XNTAzNDM5NTQ5Mg==.html"
  end
end
