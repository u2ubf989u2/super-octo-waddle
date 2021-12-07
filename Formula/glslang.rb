class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.4.0.tar.gz"
  sha256 "9bae79c2b640b60474f8944a5ab4aff3af990074636ea2a0a3c97cb86be61dfa"
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eb51f24a65ecfb2cd5080f2c562300268c08fe0e107d49521a2ea86f3a7865e5"
    sha256 cellar: :any_skip_relocation, big_sur:       "4db24bbba60de0fd354c7f4de436ea330d7cd3f3e5ffca3db262db2ba0e924a0"
    sha256 cellar: :any_skip_relocation, catalina:      "ca0171811150b46b0c4a69792582e6e82337c6b9a0d94bc5f69e441acb26e7ee"
    sha256 cellar: :any_skip_relocation, mojave:        "a13c9cb21459616831c6d676c233b7899ee9ec1c398b79d3bea9425ff038dba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d9178a53f753481fb0fded2a60384c22db931883eacb7f7e82e0b92cc5febd6"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    args = %w[
      -DBUILD_EXTERNAL=OFF
      -DENABLE_CTEST=OFF
    ]

    system "cmake", ".", *std_cmake_args, *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.frag").write <<~EOS
      #version 110
      void main() {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
      }
    EOS
    (testpath/"test.vert").write <<~EOS
      #version 110
      void main() {
          gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
      }
    EOS
    system "#{bin}/glslangValidator", "-i", testpath/"test.vert", testpath/"test.frag"
  end
end
