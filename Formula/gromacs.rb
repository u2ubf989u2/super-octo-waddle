class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2021.1.tar.gz"
  sha256 "bc1d0a75c134e1fb003202262fe10d3d32c59bbb40d714bc3e5015c71effe1e5"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d6544181b87b3fc112bac1062701baef98494401db96b9bb66ecdf74592626e5"
    sha256 big_sur:       "ebea4352a0e8e468b72b403fb02c0293ffa86a5b0904b336d9a194a55f908c3a"
    sha256 catalina:      "342033a6ab15cb11014ca9289ea51ecbe8ac6c0d1e1cb6f1fb80bf20d3be8071"
    sha256 mojave:        "5fa4f3d48ec60a17153b6f767869970fd9cf7d92b4348b4fce2d203587b4a5b5"
    sha256 x86_64_linux:  "d48b2255b0878d7dda68df5acc09e0d057ec541b85d25378ac07b7351aa76493"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc"
  depends_on "gsl" # for OpenMP
  depends_on "openblas"

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    # Non-executable GMXRC files should be installed in DATADIR
    inreplace "scripts/CMakeLists.txt", "CMAKE_INSTALL_BINDIR",
                                        "CMAKE_INSTALL_DATADIR"

    # Avoid superenv shim reference
    inreplace "src/gromacs/gromacs-toolchain.cmake.cmakein", "@CMAKE_LINKER@",
                                                             "/usr/bin/ld"

    gcc_major_ver = Formula["gcc"].any_installed_version.major
    cc_args = %W[
      -DCMAKE_C_COMPILER=gcc-#{gcc_major_ver}
      -DCMAKE_CXX_COMPILER=g++-#{gcc_major_ver}
    ]
    args = std_cmake_args + cc_args

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    bash_completion.install "build/scripts/GMXRC" => "gromacs-completion.bash"
    bash_completion.install "#{bin}/gmx-completion-gmx.bash" => "gmx-completion-gmx.bash"
    bash_completion.install "#{bin}/gmx-completion.bash" => "gmx-completion.bash"
    zsh_completion.install "build/scripts/GMXRC.zsh" => "_gromacs"
  end

  def caveats
    <<~EOS
      GMXRC and other scripts installed to:
        #{HOMEBREW_PREFIX}/share/gromacs
    EOS
  end

  test do
    system "#{bin}/gmx", "help"
  end
end
