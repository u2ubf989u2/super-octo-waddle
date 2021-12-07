class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.80/karchive-5.80.0.tar.xz"
  sha256 "fce08d578c5311c475f43df5c40480ddafbb065c41599c535b5e98d2175c5df5"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256                               arm64_big_sur: "c17c23b5adae2fbfec336d75c4d4a9529aa18eb530e6cccfca23b0324c14ed2d"
    sha256                               big_sur:       "19fd1b9c1f51a978a5881fa0c839e637adca0f28c775bd152e7794094a06628e"
    sha256                               catalina:      "6a791ecc6949be93f1f3124888b1553d636ef0416f1ac3d990eeac13b5f37f96"
    sha256                               mojave:        "4874cb8acc21059aed98090420f515319806410f958f790ee87a8847d0c579e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bcec69b04bb2a08afc4a23abe4446909fd1b1f8e6e97c62031dee8234af9792"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build

  depends_on "qt@5"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    args = std_cmake_args
    args << "-DQt5Core_DIR=#{Formula["qt@5"].opt_prefix/"lib/cmake/Qt5Core"}"

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "make"
      end
    end
  end
end
