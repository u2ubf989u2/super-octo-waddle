class Iozone < Formula
  desc "File system benchmark tool"
  homepage "https://www.iozone.org/"
  url "https://www.iozone.org/src/current/iozone3_491.tgz"
  sha256 "057d310cc0c16fcb35ac6de25bee363d54503377cbd93a6122797f8277aab6f0"
  license :cannot_represent

  livecheck do
    url "https://www.iozone.org/src/current/"
    regex(/href=.*?iozone[._-]?v?(\d+(?:[._]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4d23cb835d535b2b6a553e5e1bb1a9cceeba50745c45e97b53ce2057b9ef5d77"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6f0a32d9de27662d82b075d9bb59944a496c2782e5ce3e8b50228fbf48b1749"
    sha256 cellar: :any_skip_relocation, catalina:      "a9865b6a1f2528acd3734a0833853a26a2b66c53c3f0e7f11be333a526c9d29d"
    sha256 cellar: :any_skip_relocation, mojave:        "9fd8e8232cb83eaeabc297ec4c89ec264e91fab8991d86c9aa57385f7143bf48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5bc9a206a9e0b0ed64005e71bc2580a133f572a20880ac7c80830c11cc4989e"
  end

  def install
    cd "src/current" do
      on_macos do
        system "make", "macosx", "CC=#{ENV.cc}"
      end
      on_linux do
        system "make", "linux", "CC=#{ENV.cc}"
      end
      bin.install "iozone"
      pkgshare.install %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                          gnuplot.dem gnuplotps.dem iozone_visualizer.pl
                          report.pl]
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end
