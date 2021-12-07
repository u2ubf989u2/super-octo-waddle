class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-10.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-10.2.tar.xz"
  sha256 "aaa1223d534c9b700a8bec952d9748ee1977513f178727e1bee520ee000b4f29"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git"

  bottle do
    sha256 big_sur:      "31de67be9674e5bd363a554e7f02002687a5ac9734526983e0430b041acea042"
    sha256 catalina:     "66f0ab39e075db4f5de3403c0f8125b54be84b7d009491e0b8e040d774721c3b"
    sha256 mojave:       "f1392338a52a0e3d74b3b4f9f1ad4e70977d80ad672789a1371bed545d5528e4"
    sha256 x86_64_linux: "f288bd9eda8a4e085217d203e49a70429645fabb385a0ddc47df3d61eeb1cc18"
  end

  depends_on "python@3.9"
  depends_on "xz" # required for lzma support

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    fails_with gcc: "6"
    depends_on "gcc@7"
  end

  uses_from_macos "texinfo" => :build
  uses_from_macos "expat"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "guile"
  end

  conflicts_with "i386-elf-gdb", because: "both install include/gdb, share/gdb and share/info"
  conflicts_with "x86_64-elf-gdb", because: "both install include/gdb, share/gdb and share/info"

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  def install
    args = %W[
      --enable-targets=all
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.9"].opt_bin}/python3
      --disable-binutils
    ]

    ENV.append "CPPFLAGS", "-I#{Formula["python@3.9"].opt_libexec}" unless OS.mac?
    ENV.append "LDFLAGS", "-L#{Formula["gcc@7"].opt_lib}/gcc/7" unless OS.mac?

    mkdir "build" do
      system "../configure", *args
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb", "maybe-install-gdbserver"
    end
  end

  def caveats
    <<~EOS
      gdb requires special privileges to access Mach ports.
      You will need to codesign the binary. For instructions, see:

        https://sourceware.org/gdb/wiki/BuildingOnDarwin

      On 10.12 (Sierra) or later with SIP, you need to run this:

        echo "set startup-with-shell off" >> ~/.gdbinit
    EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
