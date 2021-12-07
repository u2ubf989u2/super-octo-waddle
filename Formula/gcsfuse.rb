class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.32.0.tar.gz"
  sha256 "b509f55de799aba6bbc1f81d6e4c1495b09644872211e5fd8805b5e0e174ed84"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:     "59df52ee1b44a532d2ebe8c83d0c9d2d3706da8510c9daf0b53d46c3aa156664"
    sha256 cellar: :any_skip_relocation, mojave:       "a97edf4dbfa9e41d2e9d4de092507c9d5199de2324b0d95f454c50893d977889"
    sha256 cellar: :any_skip_relocation, high_sierra:  "e0f04b45a7fe6583e424fc81a7c34dace7b01e215739758930b6baab14d3d50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b629482617acea1454f3d4878e2d00092250aea89012b5aa0afe920a33dd8172"
  end

  depends_on "go" => :build

  on_macos do
    disable! date: "2021-04-08", because: "requires FUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    # Build the build_gcsfuse tool. Ensure that it doesn't pick up any
    # libraries from the user's GOPATH; it should have no dependencies.
    ENV.delete("GOPATH")
    system "go", "build", "./tools/build_gcsfuse"

    # Use that tool to build gcsfuse itself.
    gcsfuse_version = build.head? ? Utils.git_short_head : version
    system "./build_gcsfuse", buildpath, prefix, gcsfuse_version
  end

  test do
    system "#{bin}/gcsfuse", "--help"
    system "#{sbin}/mount#{OS.mac? ? "_" : "."}gcsfuse", "--help"
  end
end
