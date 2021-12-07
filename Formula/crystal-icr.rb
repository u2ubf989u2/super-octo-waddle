class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.8.0.tar.gz"
  sha256 "8c7825dd035bbb4bc6499873d4bd125185a01cae10dc8dd6f98e6e013def381c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 big_sur:      "27aca5fd1d1b212b90575dd385b27cbc215aea9510cab6c24efe18ec15d617cc"
    sha256 catalina:     "a0683b8dce5fd77b89f4ba6412ad1ad7b793abfd2e703f9cff72e2ffe7248d43"
    sha256 mojave:       "30bbc4ad85339e27305d4294cf53e3ddc252f137599b7602ca2930f01728cd8c"
    sha256 x86_64_linux: "ac10ad637bebc3fdd3284bc36c00b211154597251874a6360bc2fc9444bd96c7"
  end

  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@1.1"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
