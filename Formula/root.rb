class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch/"
  url "https://root.cern.ch/download/root_v6.22.08.source.tar.gz"
  sha256 "6f061ff6ef8f5ec218a12c4c9ea92665eea116b16e1cd4df4f96f00c078a2f6f"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git"

  livecheck do
    url "https://root.cern.ch/download/"
    regex(/href=.*?root[._-]v?(\d+(?:\.\d*[02468])+)\.source\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "6a4af2c361ac4f65f523b5487a93afe1ff7ea3939997bd376d6971a1de6dd1fb"
    sha256 big_sur:       "6f3b9e7ce0cc079488e9e4b9d6ca8a0b948c0d605887ff95f40a881c0645a1b6"
    sha256 catalina:      "7fdc50aa5b0b2889c0b93f77c8dad5b8f838b924663f4d5b38fe2f423ef6effd"
    sha256 mojave:        "385d6278a1dd4c09fd1031b8c443e19b7ec4482ad85105c0d0f06bc6dea60229"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "cfitsio"
  depends_on "davix"
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "gl2ps"
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "lz4"
  depends_on "numpy" # for tmva
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.9"
  depends_on "tbb"
  depends_on "xrootd"
  depends_on "xz" # for LZMA
  depends_on "zstd"

  unless OS.mac?
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxft"
    depends_on "libxpm"
  end

  uses_from_macos "libxml2"

  conflicts_with "glew", because: "root ships its own copy of glew"

  skip_clean "bin"

  # Can be removed post 6.22.08
  patch do
    url "https://github.com/root-project/root/commit/d113c9fcf7e1d88c573717c676aa4b97f1db2ea2.patch?full_index=1"
    sha256 "6d0fd5ccd92fbb27a949ea40ed4fd60a5e112a418d124ca99f05f70c9df31cda"
  end

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    # Freetype/afterimage/gl2ps/lz4 are vendored in the tarball, so are fine.
    # However, this is still permitting the build process to make remote
    # connections. As a hack, since upstream support it, we inreplace
    # this file to "encourage" the connection over HTTPS rather than HTTP.
    inreplace "cmake/modules/SearchInstalledSoftware.cmake",
              "http://lcgpackages",
              "https://lcgpackages"

    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
      -Dbuiltin_cfitsio=OFF
      -Dbuiltin_freetype=ON
      -Dbuiltin_glew=ON
      -Ddavix=ON
      -Dfftw3=ON
      -Dfitsio=ON
      -Dfortran=ON
      -Dgdml=ON
      -Dgnuinstall=ON
      -Dimt=ON
      -Dmathmore=ON
      -Dminuit2=ON
      -Dmysql=OFF
      -Dpgsql=OFF
      -Dpyroot=ON
      -Droofit=ON
      -Dssl=ON
      -Dtmva=ON
      -Dxrootd=ON
      -GNinja
    ]

    args << "-DCLING_CXX_PATH=clang++" if OS.mac?

    cxx_version = (MacOS.version < :mojave) ? 14 : 17
    args << "-DCMAKE_CXX_STANDARD=#{cxx_version}"

    # Homebrew now sets CMAKE_INSTALL_LIBDIR to /lib, which is incorrect
    # for ROOT with gnuinstall, so we set it back here.
    args << "-DCMAKE_INSTALL_LIBDIR=lib/root"

    # Workaround the shim directory being embedded into the output
    inreplace "build/unix/compiledata.sh", "`type -path $CXX`", ENV.cxx

    mkdir "builddir" do
      system "cmake", "..", *args

      system "ninja", "install"

      chmod 0755, Dir[bin/"*.*sh"]

      version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
      pth_contents = "import site; site.addsitedir('#{lib}/root')\n"
      (prefix/"lib/python#{version}/site-packages/homebrew-root.pth").write pth_contents
    end
  end

  def caveats
    <<~EOS
      As of ROOT 6.22, you should not need the thisroot scripts; but if you
      depend on the custom variables set by them, you can still run them:

      For bash users:
        . #{HOMEBREW_PREFIX}/bin/thisroot.sh
      For zsh users:
        pushd #{HOMEBREW_PREFIX} >/dev/null; . bin/thisroot.sh; popd >/dev/null
      For csh/tcsh users:
        source #{HOMEBREW_PREFIX}/bin/thisroot.csh
      For fish users:
        . #{HOMEBREW_PREFIX}/bin/thisroot.fish
    EOS
  end

  test do
    (testpath/"test.C").write <<~EOS
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS

    # Test ROOT command line mode
    ENV.prepend_path "LD_LIBRARY_PATH", lib/"root" unless OS.mac?
    system "#{bin}/root", "-b", "-l", "-q", "-e", "gSystem->LoadAllLibraries(); 0"

    # Test ROOT executable
    assert_equal "\nProcessing test.C...\nHello, world!\n",
                 shell_output("root -l -b -n -q test.C")

    # Test linking
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <TString.h>
      int main() {
        std::cout << TString("Hello, world!") << std::endl;
        return 0;
      }
    EOS
    (testpath/"test_compile.bash").write <<~EOS
      $(root-config --cxx) $(root-config --cflags) $(root-config --libs) $(root-config --ldflags) test.cpp
      ./a.out
    EOS
    assert_equal "Hello, world!\n",
                 shell_output("/bin/bash test_compile.bash")

    # Test Python module
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import ROOT; ROOT.gSystem.LoadAllLibraries()"
  end
end
