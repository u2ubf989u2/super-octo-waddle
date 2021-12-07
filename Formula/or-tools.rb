class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v8.2.tar.gz"
  sha256 "cf40715fa5cfeee88e2c8f5583465182c8dedf60b4eb7c4a967b32ff61ac4302"
  license "Apache-2.0"
  revision 2
  head "https://github.com/google/or-tools.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "64ed95e44237ac81f6e85f9c122fba2ea0f60d45ab3dc6caaa7501bab0ccc3ad"
    sha256 cellar: :any, big_sur:       "98e7ce2b3505ac9af96c4bb1679929a9335b261d084eee76d6bff6215cffc595"
    sha256 cellar: :any, catalina:      "f4641bf784528e7e9e72d1e997502e7c6ef3f61a7d74d2ffbfbc50b8c8fae8d4"
    sha256 cellar: :any, mojave:        "6c9cf13f2212a5e2bd3bfc3444b9b8e3215676d490dee8090f3e13f24645a3cf"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "osi"
  depends_on "protobuf"

  # Patch to fix build with abseil 20210324. Remove at version bump (v9.0).
  # https://github.com/Homebrew/homebrew-core/issues/74657
  patch do
    url "https://github.com/google/or-tools/commit/9e901a7b24e5860baa90c0fc7a02de622bc9403a.patch?full_index=1"
    sha256 "7d504e9ba9efdc72187b3420bc46a2b104234bc711c946b711b7ffec5243f31f"
  end

  def install
    system "cmake", "-S.", "-Bbuild", *std_cmake_args,
           "-DUSE_SCIP=OFF", "-DBUILD_SAMPLES=OFF", "-DBUILD_EXAMPLES=OFF"
    system "cmake", "--build", "build", "-v"
    system "cmake", "--build", "build", "--target", "install"
    pkgshare.install "ortools/linear_solver/samples/simple_lp_program.cc"
    pkgshare.install "ortools/constraint_solver/samples/simple_routing_program.cc"
    pkgshare.install "ortools/sat/samples/simple_sat_program.cc"
  end

  test do
    # Linear Solver & Glop Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-L#{Formula["abseil"].opt_lib}", "-labsl_time",
           pkgshare/"simple_lp_program.cc", "-o", "simple_lp_program"
    system "./simple_lp_program"
    # Routing Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           pkgshare/"simple_routing_program.cc", "-o", "simple_routing_program"
    system "./simple_routing_program"
    # Sat Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           pkgshare/"simple_sat_program.cc", "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
