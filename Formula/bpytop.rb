class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/cf/18/a53f8d2393ca8856a9a3e7e6130d6803048d21e7bac60ae6979249436d25/bpytop-1.0.65.tar.gz"
  sha256 "de16412efec4bde588466bfed2166908240b59d941c48fc6b9623e2fde0e05ef"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "471158987db84139fbb888e989599ae5b68ffc104cf4f4c08f1f87668d965f40"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba07592d2c5919430d8f785056aa75fdfc1b70bbe945ace18e34bd0b281183e2"
    sha256 cellar: :any_skip_relocation, catalina:      "ebad941c78c5deb061cb7db5a576366cbf1152e29c5cc4e560b6f7f9991cbc2a"
    sha256 cellar: :any_skip_relocation, mojave:        "757fe57aeab8e87aa5ef663e5ce1910c80c200f29dd585dd61a1517c51208f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe37041b445ad8d8e1ce3f77297e0429dcf7bfdc7bfd4c70649282cf0897f865"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "python@3.9"
  on_macos do
    depends_on "osx-cpu-temp"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "bpytop-themes" => "themes"
  end

  test do
    config = (testpath/".config/bpytop")
    mkdir config/"themes"
    (config/"bpytop.conf").write <<~EOS
      #? Config file for bpytop v. #{version}

      update_ms=2000
      log_level=DEBUG
    EOS

    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/bpytop")
    r.winsize = [80, 130]
    sleep 5
    w.write "\cC"

    log = (config/"error.log").read
    assert_match "bpytop version #{version} started with pid #{pid}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
