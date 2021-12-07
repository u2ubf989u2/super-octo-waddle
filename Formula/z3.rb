class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.10.tar.gz"
  sha256 "12cce6392b613d3133909ce7f93985d2470f0d00138837de06cf7eb2992886b4"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "05119bd5f8a125823a9809ec6cc5bed54b426a7778832f3022b91edbde24b2d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b644db19e5e4b40ab46040c845141cf484ed7a61a4405e26a2e7ee849e7fc8e"
    sha256 cellar: :any_skip_relocation, catalina:      "97099b1c125112e2a7b783dc7a568e34e1b43b8bce16fc6bb5697c7fd69da514"
    sha256 cellar: :any_skip_relocation, mojave:        "c16751c07a66eb9aaeaa0d2aa1b59182ac3ee37dfcd475286260637d69260e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19ea87f80855a286e50301dd10bb7679e0de044fbf373e74dbd9f09b880be8d9"
  end

  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.9" => :build

  def install
    python3 = Formula["python@3.9"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    system python3, "scripts/mk_make.py",
                     "--prefix=#{prefix}",
                     "--python",
                     "--pypkgdir=#{lib}/python#{xy}/site-packages",
                     "--staticlib"

    cd "build" do
      system "make"
      system "make", "install"
    end

    system "make", "-C", "contrib/qprofdiff"
    bin.install "contrib/qprofdiff/qprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/c/test_capi.c",
      "-I#{include}", "-L#{lib}", "-lz3", "-o", testpath/"test"
    system "./test"
  end
end
