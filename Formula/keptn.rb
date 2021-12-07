class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.8.2.tar.gz"
  sha256 "eb20175aa8e2a56bc4c7311e34fd2d4046382111048f5fdae46a0d3488b13e01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "ca106c9f94dccb75e2bb6eab13c465fec3db695ad16dbf3ea7bc190bb067af4b"
    sha256 cellar: :any_skip_relocation, catalina:     "df772fbde810b557ecf3d2a8378f7a0290454575fd6bf3838e9157d07e56c6fc"
    sha256 cellar: :any_skip_relocation, mojave:       "90b8a010292b55c76c07b86073065a333f9b0101a71c755db177d668db0d342a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6d6de5d07e62462c50fd61742e86ad2f1ecac5fa3295df76527e6ce1ac66576a"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "auto"
    cd buildpath/"cli" do
      system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.Version=#{version} -X main.KubeServerVersionConstraints=\"\""
    end
  end

  test do
    run_output = shell_output("#{bin}/keptn version 2>&1")
    assert_match "\nKeptn CLI version:", run_output

    version_output = shell_output("#{bin}/keptn version 2>&1")
    assert_match version.to_s, version_output

    # As we can't bring up a Kubernetes cluster in this test, we simply
    # run "keptn status" and check that it 1) errors out, and 2) complains
    # about a missing keptn auth.
    require "pty"
    require "timeout"
    r, _w, pid = PTY.spawn("#{bin}/keptn status", err: :out)
    begin
      Timeout.timeout(5) do
        assert_match "Warning: could not open KUBECONFIG file", r.gets.chomp
        Process.wait pid
        assert_equal 1, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
