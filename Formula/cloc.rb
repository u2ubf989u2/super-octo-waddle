class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/1.88.tar.gz"
  sha256 "e85c2d1b3ec389d892955cf20b3fa5c797e81136e231d9a09e4f4c62e272f8cd"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/AlDanial/cloc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3638341e5639b04660af751d3646c698404636f12903fc7c90cf394d0069dfdb"
    sha256 cellar: :any_skip_relocation, big_sur:       "6692daba03124d954e7dfd5455df6bda3fd7ba7a847b79f3510ddc03fb739aed"
    sha256 cellar: :any_skip_relocation, catalina:      "8a91568128c7b0a952688e786eb16c3e7d1f4aecd73bef02ca4e7bc0f155fbae"
    sha256 cellar: :any_skip_relocation, mojave:        "6db6825b40d19e3df273e692da859cd183284308ca57291a37fb4c59ed89436c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46bdd692483faa6d1529ce803b865f3f0a7f9dbff12766959c215f8e1aba81a5"
  end

  uses_from_macos "perl"

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz"
    sha256 "ee07853aee06f310e040b6bf1a0199a18d81896d3219b9b35c9630d0eb69089b"
  end

  resource "Algorithm::Diff" do
    url "https://cpan.metacpan.org/authors/id/T/TY/TYEMQ/Algorithm-Diff-1.1903.tar.gz"
    sha256 "30e84ac4b31d40b66293f7b1221331c5a50561a39d580d85004d9c1fff991751"
  end

  resource "Parallel::ForkManager" do
    url "https://cpan.metacpan.org/authors/id/Y/YA/YANICK/Parallel-ForkManager-2.02.tar.gz"
    sha256 "c1b2970a8bb666c3de7caac4a8f4dbcc043ab819bbc337692ec7bf27adae4404"
  end

  resource "Sub::Quote" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006006.tar.gz"
    sha256 "6e4e2af42388fa6d2609e0e82417de7cc6be47223f576592c656c73c7524d89d"
  end

  resource "Moo::Role" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Moo-2.004000.tar.gz"
    sha256 "323240d000394cf38ec42e865b05cb8928f625c82c9391cd2cdc72b33c51b834"
  end

  resource "Module::Runtime" do
    url "https://cpan.metacpan.org/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz"
    sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
  end

  resource "Role::Tiny" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.001004.tar.gz"
    sha256 "92ba5712850a74102c93c942eb6e7f62f7a4f8f483734ed289d08b324c281687"
  end

  resource "Devel::GlobalDestruction" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Devel-GlobalDestruction-0.14.tar.gz"
      sha256 "34b8a5f29991311468fe6913cadaba75fd5d2b0b3ee3bb41fe5b53efab9154ab"
    end
  end

  resource "Sub::Exporter::Progressive" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz"
      sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
    end
  end

  # Needed to fix https://github.com/AlDanial/cloc/issues/571 in 1.88
  patch do
    url "https://github.com/AlDanial/cloc/commit/32d0a28f44fc8687fd5dbfc94e9b197cc68b7f60.patch?full_index=1"
    sha256 "eee7e728802b6e95768e6290e2d8f5f9b63242186b35b8c94a2ef405f911e63d"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # These are shipped as standard with OS X/macOS' default Perl, but
    # because upstream has chosen to use "#!/usr/bin/env perl" cloc will
    # use whichever Perl is in the PATH, which isn't guaranteed to include
    # these modules. Vendor them to be safe.
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "make", "-C", "Unix", "prefix=#{libexec}", "install"
    bin.install libexec/"bin/cloc"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
    man1.install libexec/"share/man/man1/cloc.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "1,C,0,0,4", shell_output("#{bin}/cloc --csv .")
  end
end
