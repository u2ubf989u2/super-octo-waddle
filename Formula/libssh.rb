class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.9/libssh-0.9.5.tar.xz"
  sha256 "acffef2da98e761fc1fd9c4fddde0f3af60ab44c4f5af05cd1b2d60a3fa08718"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a51771f2d0aad1f496cece28cd55bf8e9577e68acc57e3c8b2fe2e5c16b82917"
    sha256 cellar: :any, big_sur:       "ba9752b774a055a0df12b12cb76c8faed66b13de0f8ebbb8d415dae9f21a899d"
    sha256 cellar: :any, catalina:      "85e25fa108135c48e655b4d26fb716430bea5795e13a7e61011d34c3f75be2dd"
    sha256 cellar: :any, mojave:        "d5ae563dad7c55f63a2509838a98df08643b13c07e1febd9ddeddf79ecfe043a"
    sha256 cellar: :any, x86_64_linux:  "9367e79298e7011227dbafb0a87dbfee363714c6601c91407583725486f51d9a"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_STATIC_LIB=ON",
                            "-DWITH_SYMBOL_VERSIONING=OFF",
                            *std_cmake_args
      system "make", "install"
      lib.install "src/libssh.a"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libssh/libssh.h>
      #include <stdlib.h>
      int main()
      {
        ssh_session my_ssh_session = ssh_new();
        if (my_ssh_session == NULL)
          exit(-1);
        ssh_free(my_ssh_session);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", *("-L#{lib}" if OS.mac?), *("-lssh" if OS.mac?),
           testpath/"test.c", *("-L#{lib}" unless OS.mac?), *("-lssh" unless OS.mac?), "-o", testpath/"test"
    system "./test"
  end
end
