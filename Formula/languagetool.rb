class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v5.3",
      revision: "cc5c9279b225c10c383398baec2e7f20f2a850a2"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "1d3e5613c6ca24afb1b9d0a75b6eed4e5257a6e0803ffc4608f0b73474a66aff"
    sha256 cellar: :any_skip_relocation, catalina:     "e89a739b4bb27bfa1973f2f4697b98d6edac3247bfa00dbbba7bac35c3e5b007"
    sha256 cellar: :any_skip_relocation, mojave:       "5e2671b1326068e5b4b572148e4fc202cb13c1af137d266a1f796016e9845415"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6fae395c225dc0db8337bba174bd3a6e866fde79462c21621ab6d44a9233a8f9"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    java_version = "11"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)
    system "mvn", "clean", "package", "-DskipTests"

    # We need to strip one path level from the distribution zipball,
    # so extract it into a temporary directory then install it.
    mktemp "zip" do
      system "unzip", Dir["#{buildpath}/languagetool-standalone/target/*.zip"].first, "-d", "."
      libexec.install Dir["*/*"]
    end

    bin.write_jar_script libexec/"languagetool-commandline.jar", "languagetool", java_version: java_version
    bin.write_jar_script libexec/"languagetool.jar", "languagetool-gui", java_version: java_version
    (bin/"languagetool-server").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env(java_version)[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -cp "#{libexec}/languagetool-server.jar" org.languagetool.server.HTTPServer "$@"
    EOS
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Homebrew, the missing package manager for macOS.
    EOS
    assert_match "Homebrew", shell_output("#{bin}/languagetool -l en-US test.txt")
  end
end
