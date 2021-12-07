class Luaradio < Formula
  desc "Lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "https://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.9.1.tar.gz"
  sha256 "25150fa6b2cfd885d59453a9c4599811573176451c659278c12d50fece69f7f3"
  license "MIT"
  revision 1
  head "https://github.com/vsergeev/luaradio.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a603c19d3aa76490299c95ced28c7b522c8b3e4580878bd77381b1dd8a15dad8"
    sha256 cellar: :any,                 big_sur:       "055327aacdb7cfb4ff1b2f3173d74a4e722912c83c40b20471d7ca1a6a69de52"
    sha256 cellar: :any,                 catalina:      "c0af371bf5dd9240c43a72cabd5bd49bb0782f2d86333d4aa342d896e3ff0f75"
    sha256 cellar: :any,                 mojave:        "266f5c368e4f6a50bb2097bf682ac9e975018da4733592691e92a24c466fe6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bc89eacceac8bbe90534575c5d0b994594aee0b4a768c88aa16a8083f750c5a"
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "luajit-openresty"

  def install
    cd "embed" do
      # Ensure file placement is compatible with HOMEBREW_SANDBOX.
      inreplace "Makefile" do |s|
        s.gsub! "install -d $(DESTDIR)$(INSTALL_CMOD)",
                "install -d $(PREFIX)/lib/lua/5.1"
        s.gsub! "$(DESTDIR)$(INSTALL_CMOD)/radio.so",
                "$(PREFIX)/lib/lua/5.1/radio.so"
      end
      system "make", "install", "PREFIX=#{prefix}"
    end

    env = {
      PATH:      "#{Formula["luajit-openresty"].opt_bin}:$PATH",
      LUA_PATH:  "#{lib}/lua/5.1/?.lua${LUA_PATH:+:$LUA_PATH}",
      LUA_CPATH: "#{lib}/lua/5.1/?.so${LUA_CPATH:+:$LUA_CPATH}",
    }

    bin.env_script_all_files libexec/"bin", env
  end

  test do
    (testpath/"hello").write("Hello, world!")
    (testpath/"test.lua").write <<~EOS
      local radio = require('radio')

      local PrintBytes = radio.block.factory("PrintBytes")

      function PrintBytes:instantiate()
          self:add_type_signature({radio.block.Input("in", radio.types.Byte)}, {})
      end

      function PrintBytes:process(c)
          for i = 0, c.length - 1 do
              io.write(string.char(c.data[i].value))
          end
      end

      local source = radio.RawFileSource("hello", radio.types.Byte, 1e6)
      local sink = PrintBytes()
      local top = radio.CompositeBlock()

      top:connect(source, sink)
      top:run()
    EOS

    assert_equal "Hello, world!", shell_output("#{bin}/luaradio test.lua")
  end
end
