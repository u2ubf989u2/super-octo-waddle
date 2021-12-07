class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.21.tar.gz"
  sha256 "889a4444501aedfbc035beae7f3e006310ec41e1743aacb89892ca199afb7c31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3fc1e135316268f24528e6ceb830092c97441880575f6e5b6aee7a8e71b5ebb9"
    sha256 cellar: :any_skip_relocation, big_sur:       "92b3785eccdfd576c482fa61b50f89e235ac2db2f8fb57bd7057fe23c2baea6b"
    sha256 cellar: :any_skip_relocation, catalina:      "8189046bd7ebe91be16c1548f74137f82f0a66b4867921697443e9d800929ff6"
    sha256 cellar: :any_skip_relocation, mojave:        "cb644f7ceb962864bc8a6da5c0a70820a444dfc9ffb3434485a96648f59356f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31c1adb1f68d291a33796aa049b25b6965af73dd22e75676a309d48f3945c0dd"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"
  end

  test do
    (testpath/".actrc").write <<~EOS
      -P ubuntu-latest=node:12.6-buster-slim
      -P ubuntu-12.04=node:12.6-buster-slim
      -P ubuntu-18.04=node:12.6-buster-slim
      -P ubuntu-16.04=node:12.6-stretch-slim
    EOS

    system "git", "clone", "https://github.com/stefanzweifel/laravel-github-actions-demo.git"

    cd "laravel-github-actions-demo" do
      system "git", "checkout", "v2.0"

      pull_request_jobs = shell_output("#{bin}/act pull_request --list")
      assert_match "php-cs-fixer", pull_request_jobs

      push_jobs = shell_output("#{bin}/act push --list")
      assert_match "phpinsights", push_jobs
      assert_match "phpunit", push_jobs
    end
  end
end
