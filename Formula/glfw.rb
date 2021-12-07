class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.3.4.tar.gz"
  sha256 "cc8ac1d024a0de5fd6f68c4133af77e1918261396319c24fd697775a6bc93b63"
  license "Zlib"
  head "https://github.com/glfw/glfw.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "254fab48c4f812c65cc73a046a664b0a914ef745c832ab01c8706ee77de6a195"
    sha256 cellar: :any,                 big_sur:       "cc2a5ebed503daa988847659ce72bcbafd44387ecebb55fa422631edb731cade"
    sha256 cellar: :any,                 catalina:      "b6505ca02cb672280ce332952dd188b7ffd139b4b48b1afb33a1619143bfd126"
    sha256 cellar: :any,                 mojave:        "fb4c73abb6b230ffc2cacf187114584a1e589e67f399b78a56396911b2e1b483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c52f68f2db30fa7b0ccfe392369c2734889f4e113f70ed3922ecc691c51179a"
  end

  depends_on "cmake" => :build

  unless OS.mac?
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "mesa"
  end

  def install
    args = std_cmake_args + %w[
      -DGLFW_USE_CHDIR=TRUE
      -DGLFW_USE_MENUBAR=TRUE
      -DBUILD_SHARED_LIBS=TRUE
    ]

    system "cmake", *args, "."
    system "make", "install"
  end

  test do
    # glfw doesn't work in headless mode
    return if !OS.mac? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.c").write <<~EOS
      #define GLFW_INCLUDE_GLU
      #include <GLFW/glfw3.h>
      #include <stdlib.h>
      int main()
      {
        if (!glfwInit())
          exit(EXIT_FAILURE);
        glfwTerminate();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lglfw"

    on_linux do
      # glfw does not work in headless mode
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "./test"
  end
end
