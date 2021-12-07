class Choose < Formula
  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"
  license "MIT"
  revision 3
  head "https://github.com/geier/choose.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c8408b41107e7824596b3c28b2f63f98c910a7452ff676805a7ec5e77ba505bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "108d84aff61c4374011202cab8203770cdee57c0445ad40735c1f41513140606"
    sha256 cellar: :any_skip_relocation, catalina:      "086ebca8f9bff4d065e788c9076bfe204b958f96b8da0cce142f3c890c38cb75"
    sha256 cellar: :any_skip_relocation, mojave:        "bef5f7490cf4a45398bfdef4867163957675227e74bab1494ea0da56cda2cda6"
    sha256 cellar: :any_skip_relocation, high_sierra:   "f860816e00292d161ed6f6617cef47c3297eb91e9231f3c125ce12b16ad7d220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "577698dec911d21f1fcf290d25546930531d37f4b4fb9f05f25422cf8384bf0b"
  end

  depends_on "python@3.9"

  conflicts_with "choose-gui", because: "both install a `choose` binary"
  conflicts_with "choose-rust", because: "both install a `choose` binary"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/45/dd/d57924f77b0914f8a61c81222647888fbb583f89168a376ffeb5613b02a6/urwid-2.1.0.tar.gz"
    sha256 "0896f36060beb6bf3801cb554303fef336a79661401797551ba106d23ab4cd86"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    resource("urwid").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end

    bin.install "choose"

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    # There isn't really a better test than that the executable exists
    # and is executable because you can't run it without producing an
    # interactive selection ui.
    assert_predicate bin/"choose", :executable?
  end
end
