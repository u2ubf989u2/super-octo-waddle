class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/1.2.27.tar.gz"
  sha256 "7e061b98f66ed60070a3920351bfc991d132f28ed4c7e037b8e726f825261586"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5aacdc10bc8751051d6635c8fc45decb36c6e9e1f8e0660cb921b3b80736321b"
    sha256 cellar: :any,                 big_sur:       "78939e92d2be55add6503458fa96059e36bb9e37e5b9fb72e724d1813b275ebb"
    sha256 cellar: :any,                 catalina:      "7fa8220ac770c8b2893adb7c19400b380928065fdd3d82b27a5231327b77e78e"
    sha256 cellar: :any,                 mojave:        "f0a10877d4f8fff9aeb8aaef410f534ff7279c62fc9e337c19136350733c9ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "310e49c0c19a0fc245f3cad2df702ffd890729b277a6d893983db103a246a154"
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"
  depends_on "python@3.9" unless OS.mac?

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-rehash", "$(command -v pyenv)", opt_bin/"pyenv"
    inreplace "pyenv.d/rehash/source.bash", "$(command -v pyenv)", opt_bin/"pyenv"

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    # Create a fake python version and executable.
    pyenv_root = Pathname(shell_output("pyenv root").strip)
    python_bin = pyenv_root/"versions/1.2.3/bin"
    foo_script = python_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions.
    versions = shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system "pyenv", "rehash"
    refute_match "Cellar", (pyenv_root/"shims/foo").read
    assert_equal "hello", shell_output("eval \"$(#{bin}/pyenv init -)\" && PYENV_VERSION='1.2.3' foo").chomp
  end
end
