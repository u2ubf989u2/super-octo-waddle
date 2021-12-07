class Etl < Formula
  desc "Extensible Template Library"
  homepage "https://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/1.4.0/source/ETL-1.4.0.tar.gz"
  mirror "https://github.com/synfig/synfig/releases/download/v1.4.0/ETL-1.4.0.tar.gz"
  sha256 "d43396c0ac356114713469216a9257247c2588d5475590a46db63cf201d1a011"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/releases/.+?/ETL[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8918bb95db8660e8b30ac2d0d508fc35272e5dea1585bc1c057cfd0cfd4cceb2"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e50fc4f2e8a00bdb55f276839b7bebfde795c6da8a170395baa932009f1891c"
    sha256 cellar: :any_skip_relocation, catalina:      "36399b703008be7d253bbbd1313c22929982319d3e7e52dbeb92a1acbc554cb4"
    sha256 cellar: :any_skip_relocation, mojave:        "3499623804687865757dec0f5df9ae2b8c70ed8d8c8c6cfa2e8bd6bf839b55db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566456969e125e92bd51ff0ab31da75cd4b36f6268f0c31c9536ac385a3e365d"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ETL/misc>
      int main(int argc, char *argv[])
      {
        int rv = etl::ceil_to_int(5.5);
        return 6 - rv;
      }
    EOS
    flags = %W[
      -I#{include}/ETL
      -lpthread
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
