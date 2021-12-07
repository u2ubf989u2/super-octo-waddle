class Glog < Formula
  desc "Application-level logging library"
  homepage "https://github.com/google/glog"
  url "https://github.com/google/glog/archive/v0.4.0.tar.gz"
  sha256 "f28359aeba12f30d73d9e4711ef356dc842886968112162bc73002645139c39c"
  license "BSD-3-Clause"
  head "https://github.com/google/glog.git"
  revision 1 unless OS.mac?

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8f1417f8d9c708afd66bd4b9ef1b1b1308dcd85d02950b6284ff0f712f92c5e2"
    sha256 cellar: :any, big_sur:       "ed282046831a2c49077ed7427a4690f2aa95ba80ae2b9902bac8e5bd47ca0d86"
    sha256 cellar: :any, catalina:      "918710bfd20d088718f33579216eb4574595f27ea234c409dd5848c0b8ad9e15"
    sha256 cellar: :any, mojave:        "034a4d2272b48fd7655b467b92c78eebfb11efb33cc6cd31f7b13ee085b7169b"
    sha256 cellar: :any, high_sierra:   "bbe6c4138b5fe8cd58d269a39644176f640fa62e694ffac36337f87661cacc69"
    sha256 cellar: :any, sierra:        "08408127c37122614811eae2d925d940912c2cb29eb0fb300116ee4813d50095"
    sha256 cellar: :any, x86_64_linux:  "2ec0688648139e68ad94c4478f1f46ed2a623bbefa4daaaed1d79b26d44521ae"
  end

  depends_on "cmake" => :build
  depends_on "gflags"

  def install
    mkdir "cmake-build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end

    # Upstream PR from 30 Aug 2017 "Produce pkg-config file under cmake"
    # See https://github.com/google/glog/pull/239
    (lib/"pkgconfig/libglog.pc").write <<~EOS
      prefix=#{prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include

      Name: libglog
      Description: Google Log (glog) C++ logging framework
      Version: #{stable.version}
      Libs: -L${libdir} -lglog
      Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glog/logging.h>
      #include <iostream>
      #include <memory>
      int main(int argc, char* argv[])
      {
        google::InitGoogleLogging(argv[0]);
        LOG(INFO) << "test";
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}",
                    "-lglog", "-I#{Formula["gflags"].opt_lib}",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-o", "test"
    system "./test"
  end
end
