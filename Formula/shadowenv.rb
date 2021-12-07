class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/2.0.3.tar.gz"
  sha256 "9d86db156b84e8df9cdc3c6084af4e538a5928fb6817567778464b10fe12a095"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "43ef903f8c706b1aaa787a28a101bb488f80fecfcf5207d56a55205464cd3ca3"
    sha256 cellar: :any_skip_relocation, catalina:     "a8e73028069e37003f2e019230e48947913b164ebb9cdb50ea088b6398fc352c"
    sha256 cellar: :any_skip_relocation, mojave:       "5022c65cf81ba99f8be31fdd879201e566f203f357e5ca88d14daaa0d9a83325"
    sha256 cellar: :any_skip_relocation, high_sierra:  "fe0a543dc0a0ce7adba2eebc9f8f224aa55a4f63b49a4474d576d6467d604065"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3b0ef65fd759b3d7c236fd3ab88177289a110e855a4fc4c78146c371ebcb840a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "#{buildpath}/man/man1/shadowenv.1"
    man5.install "#{buildpath}/man/man5/shadowlisp.5"
  end

  test do
    expected_output = <<~EOM
      EXAMPLE:
      EXAMPLE2:b
      EXAMPLE3:b
      EXAMPLE_PATH:a:b:d
      ---
      EXAMPLE:a
      EXAMPLE2:
      EXAMPLE3:a
      EXAMPLE_PATH:c:d
    EOM
    environment = "export EXAMPLE2=b EXAMPLE3=b EXAMPLE_PATH=a:b:d;"
    hash = "1256a7c3de15e864"
    data = {
      "scalars" => [
        { "name" => "EXAMPLE2", "original" => nil, "current" => "b" },
        { "name" => "EXAMPLE", "original" => "a", "current" => nil },
        { "name" => "EXAMPLE3", "original" => "a", "current" => "b" },
      ],
      "lists"   => [
        { "name" => "EXAMPLE_PATH", "additions" => ["b", "a"], "deletions" => ["c"] },
      ],
    }
    # Read ...'\"'\"'... on the next line as a ruby `...' + "'" + '...` but for bash
    shadowenv_command = "#{bin}/shadowenv hook '\"'\"'#{hash}:#{data.to_json}'\"'\"' 2> /dev/null"
    print_vars =
      "echo EXAMPLE:$EXAMPLE; echo EXAMPLE2:$EXAMPLE2; echo EXAMPLE3:$EXAMPLE3; echo EXAMPLE_PATH:$EXAMPLE_PATH;"

    assert_equal expected_output,
      shell_output("bash -c '#{environment} #{print_vars} echo ---; eval \"$(#{shadowenv_command})\"; #{print_vars}'")
  end
end
