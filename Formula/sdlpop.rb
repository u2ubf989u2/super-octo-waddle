class Sdlpop < Formula
  desc "Open-source port of Prince of Persia"
  homepage "https://github.com/NagyD/SDLPoP"
  url "https://github.com/NagyD/SDLPoP/archive/v1.21.tar.gz"
  sha256 "2d3111bd92f39a6ee203194cf058f59c9774b5cb38437ff245dfc876930d0f95"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "11ae6da38a26202d102389aa5e4ce0f5c04eeb880cef6fdf61812b25a71c245f"
    sha256 cellar: :any, big_sur:       "dc3e491f6ddf7644d20ad5315d519ca43c9cc6be1f4c4de49a2c74c3775820b9"
    sha256 cellar: :any, catalina:      "b2d7607bbcd3a725ed2c3b1c9e290076c7c561deafac51b081f3d7ceabd04aad"
    sha256 cellar: :any, mojave:        "6ce535a5a303503e21def50933a3596f13b373eaa5263a076ec062be328bb717"
    sha256 cellar: :any, high_sierra:   "bf4afc58349c91ce9c2f06269e3807015e6cf4e37d0341fd4e09c3e48445c28c"
    sha256 cellar: :any, x86_64_linux:  "41b00e7e6ed2d7f85554b17ffefb8b4728b4463030c91f9d177957f9ef3fcbea"
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  def install
    system "make", "-C", "src"
    doc.install Dir["doc/*"]
    libexec.install "data"
    libexec.install "prince"

    # Use var directory to keep save and replay files
    pkgvar = var/"sdlpop"
    pkgvar.install "SDLPoP.ini" unless (pkgvar/"SDLPoP.ini").exist?

    (bin/"prince").write <<~EOS
      #!/bin/bash
      cd "#{pkgvar}" && exec "#{libexec}/prince" $@
    EOS
  end

  def caveats
    <<~EOS
      Save and replay files are stored in the following directory:
        #{var}/sdlpop
    EOS
  end
end
