class SshCopyId < Formula
  desc "Add a public key to a remote machine's authorized_keys file"
  homepage "https://www.openssh.com/"
  url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.6p1.tar.gz"
  mirror "https://mirror.vdms.io/pub/OpenBSD/OpenSSH/portable/openssh-8.6p1.tar.gz"
  version "8.6p1"
  sha256 "c3e6e4da1621762c850d03b47eed1e48dff4cc9608ddeb547202a234df8ed7ae"
  license "SSH-OpenSSH"
  head "https://github.com/openssh/openssh-portable.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f7eabbbc20c02c577d18d2524f935dfdcb8c77916f926842f0cfa8d6640ee912"
  end

  keg_only :provided_by_macos

  def install
    bin.install "contrib/ssh-copy-id"
    man1.install "contrib/ssh-copy-id.1"
  end

  test do
    output = shell_output("#{bin}/ssh-copy-id -h 2>&1", 1)
    assert_match "identity_file", output
  end
end
