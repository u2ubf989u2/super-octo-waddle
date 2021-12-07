class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.0.1.tar.gz"
  sha256 "86df82e1180f07bd0be19225776db8fbe199d66e715a343d8c0c3444b05ec00b"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "999eb95f618b418ca99240b283548adbcf12eb99d1e62813cbfd49938348764b"
    sha256 cellar: :any,                 big_sur:       "de5c2f9973ef064bcc233d71f1f99b5e6d1c4bd36ac0ae5ec05572d6b2df2245"
    sha256 cellar: :any,                 catalina:      "bb25092f10d6a9a90e60197dcd2e436d3d6f02e0727af827824ba423848beab7"
    sha256 cellar: :any,                 mojave:        "4f64a83667eccb3152f8ba5df8f97af41e8c6c8d3b813ca69942a53c8d1353f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cc9fc65dfc28e4c1fae3c3f0a6f6c46064346e25343a6b4fbdbfd57e8c4a34c"
  end

  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "V=1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "xlsxwriter.h"

      int main() {
          lxw_workbook  *workbook  = workbook_new("myexcel.xlsx");
          lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
          int row = 0;
          int col = 0;

          worksheet_write_string(worksheet, row, col, "Hello me!", NULL);

          return workbook_close(workbook);
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsxwriter", "-o", "test"
    system "./test"
    assert_predicate testpath/"myexcel.xlsx", :exist?, "Failed to create xlsx file"
  end
end
