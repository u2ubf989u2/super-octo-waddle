class Kubeprod < Formula
  desc "Installer for the Bitnami Kubernetes Production Runtime (BKPR)"
  homepage "https://kubeprod.io"
  url "https://github.com/bitnami/kube-prod-runtime/archive/v1.7.0.tar.gz"
  sha256 "8bc41467511e69b53e29257ffd588fbaca6a904f3bec04493a1e7eb7048ea67d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c06463709376ab375246b30e50e1f3f71fcf57a9219d710994d9a5fadde4199"
    sha256 cellar: :any_skip_relocation, big_sur:       "3286c04ea5d7d7a198791ebb2a69ae172c6fb5cfc2c1013c1d7b7e66d3053dcd"
    sha256 cellar: :any_skip_relocation, catalina:      "e7aa12f3c6d2900563d0c9996ff6a16b235eeb3f94617b3c6cd38a1571c06f35"
    sha256 cellar: :any_skip_relocation, mojave:        "75f7896a2872579b7bc7626ad92b8e2956541fb5d217712009c2ce81e379b565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04e30e87dbfc13a566b857fea0125cb9d320ee52c859fef22a4b1be00b614bfc"
  end

  depends_on "go" => :build

  def install
    cd "kubeprod" do
      system "go", "build", *std_go_args, "-ldflags", "-X main.version=v#{version}", "-mod=vendor"
    end
  end

  test do
    version_output = shell_output("#{bin}/kubeprod version")
    assert_match "Installer version: v#{version}", version_output

    (testpath/"kube-config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    authz_domain = "castle-black.com"
    project = "white-walkers"
    oauth_client_id = "jon-snow"
    oauth_client_secret = "king-of-the-north"
    contact_email = "jon@castle-black.com"

    ENV["KUBECONFIG"] = testpath/"kube-config"
    system "#{bin}/kubeprod", "install", "gke",
                              "--authz-domain", authz_domain,
                              "--project", project,
                              "--oauth-client-id", oauth_client_id,
                              "--oauth-client-secret", oauth_client_secret,
                              "--email", contact_email,
                              "--only-generate"

    json = File.read("kubeprod-autogen.json")
    assert_match "\"authz_domain\": \"#{authz_domain}\"", json
    assert_match "\"client_id\": \"#{oauth_client_id}\"", json
    assert_match "\"client_secret\": \"#{oauth_client_secret}\"", json
    assert_match "\"contactEmail\": \"#{contact_email}\"", json

    jsonnet = File.read("kubeprod-manifest.jsonnet")
    assert_match "https://releases.kubeprod.io/files/v#{version}/manifests/platforms/gke.jsonnet", jsonnet
  end
end
