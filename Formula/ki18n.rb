class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.80/ki18n-5.80.0.tar.xz"
  sha256 "883a79d7e6c795148c0fe76f44a6f9ffe34282f827e580e70937fe8259967a7a"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/ki18n.git"

  bottle do
    sha256                               arm64_big_sur: "0bc6ccf85a95298dc22d259d711e1fa5249679d806f78f0804a523726546239d"
    sha256                               big_sur:       "10dfd5cfeafe8a4a054db63c7174c6cf52e2b4e34008019efca607d1dcae3051"
    sha256                               catalina:      "c0219c0daed11e67c0a841a33698875e9c118a1acb22d9597362e7fda39c419b"
    sha256                               mojave:        "5a18522ea00b307986429c205e95e7ff82144c6320d43ec6e053cc2b3bb32c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cda04a680982cd770ce25e464f47e55473e6e00814e8d1c1c97068231261aa47"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "gettext"
  depends_on "qt@5"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    pkgshare.install "autotests"
    (pkgshare/"cmake").install "cmake/FindLibIntl.cmake"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      include(FeatureSummary)
      find_package(ECM 5.71.0 NO_MODULE)
      set_package_properties(ECM PROPERTIES TYPE REQUIRED)
      set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "#{pkgshare}/cmake")
      find_package(Qt5 5.12.0 REQUIRED Core)
      find_package(KF5I18n REQUIRED)
      INCLUDE(CheckCXXSourceCompiles)
      find_package(LibIntl)
      set_package_properties(LibIntl PROPERTIES TYPE REQUIRED)
      add_subdirectory(autotests)
    EOS

    cp_r (pkgshare/"autotests"), testpath

    args = std_cmake_args
    args << "-DQt5_DIR=#{Formula["qt@5"].opt_prefix/"lib/cmake/Qt5"}"
    args << "-DLibIntl_INCLUDE_DIRS=#{Formula["gettext"].include}"
    args << "-DLibIntl_LIBRARIES=#{Formula["gettext"].lib/"libintl.dylib"}"

    system "cmake", testpath.to_s, *args
    system "make"
  end
end
