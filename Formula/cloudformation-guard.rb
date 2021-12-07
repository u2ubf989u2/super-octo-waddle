class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/1.0.0.tar.gz"
  sha256 "1d4c057a9c076f0311409603291dadad0063159a8bed6b5576accec2dc3a4e7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "905e22dfbbb1c0fcf956b68537c46f0d4efe8b9007baa671d12d15e1434fb628"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce6a72cad49aa61d9afd07b020b2cab1f958e3c9735a8fdafba440d6719302dd"
    sha256 cellar: :any_skip_relocation, catalina:      "bc7dfce2654ad8ac46e0f7e60e5b9a79ec08e0c60e63ba02b4ad5131035764a7"
    sha256 cellar: :any_skip_relocation, mojave:        "6e62019f3ef472d09b52a322628d964787de3be3059d54e2879c3d7e166f673f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b738a55d9ced11569203dcce689e808c8573f00c61c0cbeabf0aa4745c3f8144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad7805651bbb08fc298d8ddfb1e1f5a06d707709a2b306a64145398a403a9eee"
  end

  depends_on "rust" => :build

  def install
    cd "cfn-guard" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test-template.yml").write <<~EOS
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        Volume:
          Type: "AWS::EC2::Volume"
          Properties:
            Size : 99
            Encrypted: true,
            AvailabilityZone : us-east-1b
    EOS

    (testpath/"test-ruleset").write <<~EOS
      AWS::EC2::Volume Size == 99
    EOS
    system "#{bin}/cfn-guard", "check", "-r", "test-ruleset", "-t", "test-template.yml"
  end
end
