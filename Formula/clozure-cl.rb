class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "https://ccl.clozure.com"
  url "https://github.com/Clozure/ccl/archive/v1.12.tar.gz"
  sha256 "774a06b4fb6dc4b51dfb26da8e1cc809c605e7706c12180805d1be6f2885bd52"
  license "Apache-2.0"
  head "https://github.com/Clozure/ccl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:      "8d92feb08987fc74fb3a105f94ec0e8664b587a31fa7077b95d1f3d5c86f6a7d"
    sha256 cellar: :any_skip_relocation, catalina:     "c3fbe11dec5f77264369a8b95a774599e5247771f4df475faeed1e589cf1033d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9608b9fd4293d7e667a3aff0fbe457646844c336139ca5f5c7291ff43569e5cd"
  end

  depends_on xcode: :build
  depends_on macos: :catalina # The GNU assembler frontend which ships macOS 10.14 is incompatible with clozure-ccl: https://github.com/Clozure/ccl/issues/271

  # Patch to build heap image with linker shipped with Big Sur.  Remove for next version.
  on_macos do
    if MacOS.version >= :catalina
      patch do
        url "https://github.com/Clozure/ccl/commit/553c0f25f38b2b0d5922ca7b4f62f09eb85ace1c.patch?full_index=1"
        sha256 "deb9e35df75d82c1694fec569a246388485fb64ab7bae3addff6ff3650160b04"
      end
    end
  end

  on_linux do
    depends_on "m4"
  end

  resource "bootstrap" do
    on_macos do
      url "https://github.com/Clozure/ccl/releases/download/v1.12/darwinx86.tar.gz"
      sha256 "9434fb5ebc01fc923625ad56726fdd217009e2d3c107cfa3c5435cb7692ba7ca"
    end

    on_linux do
      url "https://github.com/Clozure/ccl/releases/download/v1.12/linuxx86.tar.gz"
      sha256 "7fbdb04fb1b19f0307c517aa5ee329cb4a21ecc0a43afd1b77531e4594638796"
    end
  end

  def install
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("bootstrap")

    on_macos do
      buildpath.install tmpdir/"dx86cl64.image"
      buildpath.install tmpdir/"darwin-x86-headers64"
      cd "lisp-kernel/darwinx8664" do
        system "make"
      end
    end

    on_linux do
      buildpath.install tmpdir/"lx86cl64"
      buildpath.install tmpdir/"lx86cl64.image"
      buildpath.install tmpdir/"x86-headers64"
    end

    ENV["CCL_DEFAULT_DIRECTORY"] = buildpath

    on_macos do
      system "./dx86cl64", "-n", "-l", "lib/x8664env.lisp",
            "-e", "(ccl:xload-level-0)",
            "-e", "(ccl:compile-ccl)",
            "-e", "(quit)"
      (buildpath/"image").write('(ccl:save-application "dx86cl64.image")\n(quit)\n')
      system "cat image | ./dx86cl64 -n --image-name x86-boot64.image"
    end

    on_linux do
      system "./lx86cl64", "-n", "-l", "lib/x8664env.lisp",
            "-e", "(ccl:rebuild-ccl :full t)",
            "-e", "(quit)"
      (buildpath/"image").write('(ccl:save-application "lx86cl64.image")\n(quit)\n')
      system "cat image | ./lx86cl64 -n --image-name x86-boot64"
    end

    prefix.install "doc/README"
    doc.install Dir["doc/*"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/scripts/ccl64"]
    bin.env_script_all_files(libexec/"bin", CCL_DEFAULT_DIRECTORY: libexec)
  end

  test do
    output = shell_output("#{bin}/ccl64 -n -e '(write-line (write-to-string (* 3 7)))' -e '(quit)'")
    assert_equal "21", output.strip
  end
end
