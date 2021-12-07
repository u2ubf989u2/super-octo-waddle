require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.24.2.tgz"
  sha256 "51ac2b12d562ee424a556d15b95a64277ec4368bdb1450a0bbbdea214fcd3fd9"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "78a39124fce64417398dc5d486ae00175a099727d56b6b14ed9e4aa0188166ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6f7721ad08279bcf761e115b6ef9a114e21423b51454cff3868854542eda596"
    sha256 cellar: :any_skip_relocation, catalina:      "2535dd0c6b8ecdaa8c47eccd52bf3a501830c7f1d72a5e62bdf1e1d541f2679c"
    sha256 cellar: :any_skip_relocation, mojave:        "184300224eec81565511dc705d2c458c641afa5b96c683b366baf2384250d9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "399a9732262229d7ceefd7dbe0fbd84a86871c8e34740c3e3ca3f6e89e6ef439"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.5.0.tgz"
    sha256 "6db23ada5a0ef82f6fd8f7c4b247589af6b6eaec36ef5e54f39660923a001679"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production", "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "bundle", "--mode", "production", "--entry", testpath/"index.js"
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
