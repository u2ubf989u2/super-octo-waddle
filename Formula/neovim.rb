class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"
  revision 2

  stable do
    url "https://github.com/neovim/neovim/archive/v0.4.4.tar.gz"
    sha256 "2f76aac59363677f37592e853ab2c06151cca8830d4b3fe4675b4a52d41fc42c"

    # Patch for Apple Silicon. Backported from
    # https://github.com/neovim/neovim/pull/12624
    patch :DATA
  end

  bottle do
    sha256 arm64_big_sur: "9e24789f21eba59817331f583622d5594598162de01eeac4abfdeacdee67f7a9"
    sha256 big_sur:       "33fd21ea56ff618b9840e4ca87ddf2b0450f73dff8f39eed163052e171395bdb"
    sha256 catalina:      "e2d64684c43eb19390975d6434e2845f98f9e0f0f91c00b1277750c36bdf0676"
    sha256 mojave:        "e6e9437addbf446ed88518784f461a0bdb9c578b6779f3353e066a4491b52465"
    sha256 x86_64_linux:  "10c3725e8927182dfa77c279199e445cc48f5c53c8e6e0ab98ac8a67bf2786dc"
  end

  head do
    url "https://github.com/neovim/neovim.git"
    depends_on "tree-sitter"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libtermkey"
  depends_on "libuv"
  depends_on "libvterm"
  depends_on "luajit-openresty"
  depends_on "luv"
  depends_on "msgpack"
  depends_on "unibilium"

  uses_from_macos "gperf" => :build
  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "libnsl"
  end

  # Keep resources updated according to:
  # https://github.com/neovim/neovim/blob/v#{version}/third-party/CMakeLists.txt

  resource "mpack" do
    url "https://github.com/libmpack/libmpack-lua/releases/download/1.0.8/libmpack-lua-1.0.8.tar.gz"
    sha256 "ed6b1b4bbdb56f26241397c1e168a6b1672f284989303b150f7ea8d39d1bc9e9"
  end

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.2-1.src.rock"
    sha256 "e0d0d687897f06588558168eeb1902ac41a11edd1b58f1aa61b99d0ea0abbfbc"
  end

  resource "inspect" do
    url "https://luarocks.org/manifests/kikito/inspect-3.1.1-0.src.rock"
    sha256 "ea1f347663cebb523e88622b1d6fe38126c79436da4dbf442674208aa14a8f4c"
  end

  def install
    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src/#{r.name}")
    end

    ENV.prepend_path "LUA_PATH", "#{buildpath}/deps-build/share/lua/5.1/?.lua"
    ENV.prepend_path "LUA_CPATH", "#{buildpath}/deps-build/lib/lua/5.1/?.so"
    lua_path = "--lua-dir=#{Formula["luajit-openresty"].opt_prefix}"

    cd "deps-build" do
      %w[
        mpack/mpack-1.0.8-0.rockspec
        lpeg/lpeg-1.0.2-1.src.rock
        inspect/inspect-3.1.1-0.src.rock
      ].each do |rock|
        dir, rock = rock.split("/")
        cd "build/src/#{dir}" do
          output = Utils.safe_popen_read("luarocks", "unpack", lua_path, rock, "--tree=#{buildpath}/deps-build")
          unpack_dir = output.split("\n")[-2]
          cd unpack_dir do
            system "luarocks", "make", lua_path, "--tree=#{buildpath}/deps-build"
          end
        end
      end
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      # Patch out references to Homebrew shims
      inreplace "config/auto/versiondef.h", /#{HOMEBREW_LIBRARY}[^ ]+/o, ENV.cc
      system "make", "install"
    end
  end

  test do
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath/"test.txt").read.chomp
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 6b3a8dc..f3370e3 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -358,16 +358,6 @@ if(CMAKE_C_COMPILER_ID STREQUAL "GNU" OR CMAKE_C_COMPILER_ID STREQUAL "Clang")
   add_definitions(-D_GNU_SOURCE)
 endif()

-if(CMAKE_SYSTEM_NAME STREQUAL "Darwin" AND CMAKE_SIZEOF_VOID_P EQUAL 8)
-  # Required for luajit.
-  set(CMAKE_EXE_LINKER_FLAGS
-    "${CMAKE_EXE_LINKER_FLAGS} -pagezero_size 10000 -image_base 100000000")
-  set(CMAKE_SHARED_LINKER_FLAGS
-    "${CMAKE_SHARED_LINKER_FLAGS} -image_base 100000000")
-  set(CMAKE_MODULE_LINKER_FLAGS
-    "${CMAKE_MODULE_LINKER_FLAGS} -image_base 100000000")
-endif()
-
 include_directories("${PROJECT_BINARY_DIR}/config")
 include_directories("${PROJECT_SOURCE_DIR}/src")
