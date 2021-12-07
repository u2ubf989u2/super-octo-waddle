class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.21.0/bitcoin-0.21.0.tar.gz"
  sha256 "1a91202c62ee49fb64d57a52b8d6d01cd392fffcbef257b573800f9289655f37"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    sha256 cellar: :any, big_sur:      "f9235205e7c1befe37fa1663c5f25a9dfe03198ff9db8e439d116109fb12948c"
    sha256 cellar: :any, catalina:     "1908a1b6dc0f0ded7091db58cfe74d7540f36636c1599b71a2016c50f71ab7fe"
    sha256 cellar: :any, mojave:       "05343622704d9ca898949fc46973a7a1e7b911530e5de13d6c5d0a51777671f2"
    sha256 cellar: :any, x86_64_linux: "3e20920bf9da6d3e40b1699fa843fae24f67f51dfa34af4746b8519d65166811"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "zeromq"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  def install
    ENV.delete("SDKROOT") if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "share/rpcauth"
  end

  plist_options manual: "bitcoind"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/bitcoind</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end
