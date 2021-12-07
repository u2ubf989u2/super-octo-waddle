class Lua < Formula
  desc "Powerful, lightweight programming language"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.4.3.tar.gz"
  sha256 "f8612276169e3bfcbcfb8f226195bfc6e466fe13042f1076cbde92b7ec96bbfb"
  license "MIT"
  revision 1 unless OS.mac?

  livecheck do
    url "https://www.lua.org/ftp/"
    regex(/href=.*?lua[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "e48d1536762f0d3dae3247586c3315aea3aacf249a0142303a92809a95ed1247"
    sha256 cellar: :any,                 big_sur:       "e59dc980047218242a11cd735216b5ec881c45c60f50fffd5edd68450c281b94"
    sha256 cellar: :any,                 catalina:      "e79726810bfb57b4803ddba7f83a6e1b231724a3d19d8bfc63ba6a003f2fe886"
    sha256 cellar: :any,                 mojave:        "862243ef1193911dc07afcafcfbcbda1b6834d528dbdbfdd5558a27ef902d044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1465450038e1e18b964533e18b2213f851d90430b756c21e462df0dc71926527"
  end

  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "readline"

    # Add shared library for linux
    # Equivalent to the mac patch carried around here ... that will probably never get upstreamed
    # Inspired from http://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
    patch do
      url "https://gist.githubusercontent.com/dawidd6/fbec1d0179f8b8f7d026ed48c2f177a6/raw/a03a2dc572287314861db3c5f761427c30691c29/lua-5.4.patch"
      sha256 "6549934065eb131a13713dca7fd5143b9d90e3f0654be49294cf56bc4bb5cc0f"
    end
  end

  if OS.mac?
    # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
    # See: https://github.com/Homebrew/legacy-homebrew/pull/5043
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/11c8360432f471f74a9b2d76e012e3b36f30b871/lua/lua-dylib.patch"
      sha256 "a39e2ae1066f680e5c8bf1749fe09b0e33a0215c31972b133a73d43b00bf29dc"
    end
  end

  def install
    # Fix: /usr/bin/ld: lapi.o: relocation R_X86_64_32 against `luaO_nilobject_' can not be used
    # when making a shared object; recompile with -fPIC
    # See http://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
    ENV.append_to_cflags "-fPIC" unless OS.mac?

    # Substitute formula prefix in `src/Makefile` for install name (dylib ID).
    # Use our CC/CFLAGS to compile.
    inreplace "src/Makefile" do |s|
      s.gsub! "@OPT_LIB@", opt_lib if OS.mac?
      s.remove_make_var! "CC"
      s.change_make_var! "MYCFLAGS", ENV.cflags
      s.change_make_var! "MYLDFLAGS", ENV.ldflags
    end

    # Fix path in the config header
    inreplace "src/luaconf.h", "/usr/local", HOMEBREW_PREFIX

    # We ship our own pkg-config file as Lua no longer provide them upstream.
    arch = OS.mac? ? "macosx" : "linux"
    system "make", arch, "INSTALL_TOP=#{prefix}"
    system "make", "install", "INSTALL_TOP=#{prefix}", ("INSTALL_MAN=#{man1}" unless OS.mac?)
    (lib/"pkgconfig/lua.pc").write pc_file

    # Fix some software potentially hunting for different pc names.
    bin.install_symlink "lua" => "lua#{version.major_minor}"
    bin.install_symlink "lua" => "lua-#{version.major_minor}"
    bin.install_symlink "luac" => "luac#{version.major_minor}"
    bin.install_symlink "luac" => "luac-#{version.major_minor}"
    (include/"lua#{version.major_minor}").install_symlink Dir[include/"lua/*"]
    lib.install Dir[shared_library("src/liblua", "*")] unless OS.mac?
    lib.install_symlink shared_library("liblua", version.major_minor) => shared_library("liblua#{version.major_minor}")
    (lib/"pkgconfig").install_symlink "lua.pc" => "lua#{version.major_minor}.pc"
    (lib/"pkgconfig").install_symlink "lua.pc" => "lua-#{version.major_minor}.pc"
  end

  def pc_file
    <<~EOS
      V= #{version.major_minor}
      R= #{version}
      prefix=#{HOMEBREW_PREFIX}
      INSTALL_BIN= ${prefix}/bin
      INSTALL_INC= ${prefix}/include/lua
      INSTALL_LIB= ${prefix}/lib
      INSTALL_MAN= ${prefix}/share/man/man1
      INSTALL_LMOD= ${prefix}/share/lua/${V}
      INSTALL_CMOD= ${prefix}/lib/lua/${V}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include/lua

      Name: Lua
      Description: An Extensible Extension Language
      Version: #{version}
      Requires:
      Libs: -L${libdir} -llua -lm #{"-ldl" unless OS.mac?}
      Cflags: -I${includedir}
    EOS
  end

  def caveats
    <<~EOS
      You may also want luarocks:
        brew install luarocks
    EOS
  end

  test do
    assert_match "Homebrew is awesome!", shell_output("#{bin}/lua -e \"print ('Homebrew is awesome!')\"")
  end
end
