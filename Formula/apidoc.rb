require "language/node"

class Apidoc < Formula
  desc "RESTful web API Documentation Generator"
  homepage "https://apidocjs.com"
  url "https://github.com/apidoc/apidoc/archive/0.27.0.tar.gz"
  sha256 "453772859c2d602ac98721e0038f4d9cd2b5f8bf08963362cd3db47b455b099a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d6ae6f0262f5df5f28ae6b55c3cb615bc2d0732386dd8e19d4ab1e30dc1d4a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b580c0df31070ab338c4a1ffd1c4486b2dec8467ff32f92f45a05e0b0dfc92f"
    sha256 cellar: :any_skip_relocation, catalina:      "946e1d2e35f9855aaa1e56ff0f2ef04c65d2fed42179c045a1304912033cb4d5"
    sha256 cellar: :any_skip_relocation, mojave:        "82602211849f5a90f78d43fd6ab0d1878bcc41579f74ed7aaa03ba47a567bfb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d75f8010195da0a30282473c9ea4e5b5db3935f6dc3115da56b109ff9f8dd72f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"api.go").write <<~EOS
      /**
       * @api {get} /user/:id Request User information
       * @apiVersion #{version}
       * @apiName GetUser
       * @apiGroup User
       *
       * @apiParam {Number} id User's unique ID.
       *
       * @apiSuccess {String} firstname Firstname of the User.
       * @apiSuccess {String} lastname  Lastname of the User.
       */
    EOS
    (testpath/"apidoc.json").write <<~EOS
      {
        "name": "example",
        "version": "#{version}",
        "description": "A basic apiDoc example"
      }
    EOS
    system bin/"apidoc", "-o", "out"
    api_data_json = (testpath/"out/api_data.json").read
    api_data = JSON.parse api_data_json
    assert_equal api_data.first["version"], version
  end
end
