class ElmFormat < Formula
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      tag:      "0.8.4",
      revision: "5bd4fbe591fe8b456160c180cb875ef60bc57890"
  license "BSD-3-Clause"
  head "https://github.com/avh4/elm-format.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "f7f6bb421efb3969733d33c7f6200af334bcd768d2128b14ba0280270b2fff30"
    sha256 cellar: :any_skip_relocation, catalina:     "dca23c0c1e66cfc6208ff891611ba8c38fdddd1d90d2a8b32bafe69dc3701b91"
    sha256 cellar: :any_skip_relocation, mojave:       "0e196d773546e0d476c079a434c57f1b49a2966410397bb33747fa2d9e57ffe1"
    sha256 cellar: :any_skip_relocation, high_sierra:  "a8f9aa324518559cdd5b7617f5453f629e90f6897cd72e38f5ab84165e7ddae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c7a19150134e2523592104ac22a2024261814278e34e7af17538cc568a82e80f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  def build_elm_format_conf
    <<~EOS
      module Build_elm_format where

      gitDescribe :: String
      gitDescribe = "#{version}"
    EOS
  end

  def install
    defaults = buildpath/"generated/Build_elm_format.hs"
    defaults.write(build_elm_format_conf)

    (buildpath/"elm-format").install Dir["*"]

    cd "elm-format" do
      system "cabal", "v2-update"
      system "cabal", "v2-install", *std_cabal_v2_args
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<~EOS
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm-format", "--elm-version=0.18", testpath/"Hello.elm", "--yes"
    system bin/"elm-format", "--elm-version=0.19", testpath/"Hello.elm", "--yes"
  end
end
