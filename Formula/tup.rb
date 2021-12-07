class Tup < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/v0.7.10.tar.gz"
  sha256 "c80946bc772ae4a5170855e907c866dae5040620e81ee1a590223bdbdf65f0f8"
  license "GPL-2.0-only"
  head "https://github.com/gittup/tup.git"

  bottle do
    sha256 cellar: :any,                 catalina:     "48009935b0e38be19c1d8a0afbbeef75109a970a57327dad9ecf5929b64b7bf2"
    sha256 cellar: :any,                 mojave:       "155b58771fa74a27b20d4e668324ae97ca4c0f8a150691b8ceecd786064dcae1"
    sha256 cellar: :any,                 high_sierra:  "78c5c8e96892dd07c467f7b86d3312689d33474e7e6a07d4c69905aa60941e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "028d321357ee22e0a8ccde786316b0a4515096d42ec8d37ef83d143559308df9"
  end

  depends_on "pkg-config" => :build

  on_macos do
    disable! date: "2021-04-08", because: "requires FUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    ENV["TUP_LABEL"] = version
    system "./build.sh"
    bin.install "build/tup"
    man1.install "tup.1"
    doc.install (buildpath/"docs").children
    pkgshare.install "contrib/syntax"
  end

  test do
    system "#{bin}/tup", "-v"
  end
end
