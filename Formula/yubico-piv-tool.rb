class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.2.0.tar.gz"
  sha256 "74cb2e03c7137c0dd529f35a230b4a598121cb71b10d7e55b91fd0cdefcac457"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a4819de1638f828cbd2e9c5e50f9830a91ed578fb42ae2fbb073d5bc66fbb38c"
    sha256 cellar: :any_skip_relocation, big_sur:       "446b3d63b270dd3bdd27adec31503c02553a0e0d4fb2610082e392e85061d528"
    sha256 cellar: :any_skip_relocation, catalina:      "72474492baf278c59ec478cb24f2c8730ff9f59f0e1963a473a6d7ad94df4e12"
    sha256 cellar: :any_skip_relocation, mojave:        "395ffe7d667fab0964b4544bb9cc4476ddcbc77eedce706c3f4c5fa4524d0e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e51ae0fc97a2ce486043effba4df5550b2036eef5c35815145c9dd3e4cf6e74"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@1.1"
  depends_on "pcsc-lite"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_C_FLAGS=-I#{Formula["pcsc-lite"].opt_include}/PCSC"
      system "make", "install"
    end
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
