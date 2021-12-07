require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.13.14.tgz"
  sha256 "6a03cbe41e2405be8fb565c610d6fd502e884566db22a939587c409bdd13e671"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e42f3a2cc4ce8152fa7d656537ab16a5029cea910b848ee85629edcf4a9df051"
    sha256 cellar: :any_skip_relocation, big_sur:       "bbcb12cfb38a94909b83d9c16aeffedde08f3dadd9c189a3bc26cbaf986c5a0c"
    sha256 cellar: :any_skip_relocation, catalina:      "b7a0a0ef11eb7536b96d09ffb320baac23921174ab1d3ef36713ac29b44fbfc4"
    sha256 cellar: :any_skip_relocation, mojave:        "4d407989c892dbea48bd2c18d7ac3b5187f5f896e1017fbc9edf93b47bb02bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b3f8907669bf735ccbc0e5f4b8728ac2ad2f7e19e86357efd3e1a268943da7"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.13.14.tgz"
    sha256 "3d7c70aabf192eee27bb3c94566436d9ee8abd00502c075ff9b3ad85ed523c50"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundleDependencies"] = ["@babel/core"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
