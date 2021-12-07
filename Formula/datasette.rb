class Datasette < Formula
  include Language::Python::Virtualenv
  desc "Open source multi-tool for exploring and publishing data"
  homepage "https://docs.datasette.io/en/stable/"
  url "https://files.pythonhosted.org/packages/50/87/8b1eb4163493f431b65c8557d526017d988c7443f5be33db38e59efd4f60/datasette-0.56.tar.gz"
  sha256 "66b3988a2f17c8ecff0f3cd593ed60236841af5c804399c25f553584f705acf3"
  license "Apache-2.0"
  head "https://github.com/simonw/datasette.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "814579b8cff5849ea6b7a8c9c2de6d864574f2324d04ea4d499b4a8f1e6fbe97"
    sha256 cellar: :any_skip_relocation, big_sur:       "804102cb75c24d39b01d5c2b4dc11d3191124e820a29af2b7aada3678fb8a384"
    sha256 cellar: :any_skip_relocation, catalina:      "8dad2e13b0db0c49d11cf9ab989c3e760616143913c55ced410d2ff88ed28cbd"
    sha256 cellar: :any_skip_relocation, mojave:        "3389ab6ab3845bd2e00b8c2ed7476715f1b6b497a3e9c4831c0c64145075db47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6d4f812603ae77e331717404425e6cf7adf596cf6ce732d36fdb1f7af08fbf4"
  end

  depends_on "python@3.9"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/77/47/19e5951cc6ed771669906d2946b3deac32a35a9a155f730be49d8fa73dc9/aiofiles-0.6.0.tar.gz"
    sha256 "e0281b157d3d5d59d803e3f4557dcc9a3dff28a4dd4829a9ff478adae50ca092"
  end

  resource "asgi-csrf" do
    url "https://files.pythonhosted.org/packages/84/85/45a529925fd802e0442a43aa3207f0a68dbf75346e5146852b80d04a7e46/asgi-csrf-0.8.tar.gz"
    sha256 "312a35c73092db96fe2da325458d482954e1e3bceeac398455f0b0f3958d9620"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/e9/d1/096b5b0b411a1a53c294a508fdc51542de77bc193df5c8230ff9445e4ff3/asgiref-3.3.1.tar.gz"
    sha256 "7162a3cb30ab0609f1a4c95938fd73e8604f63bdba516a7f7d64b83ff09478f0"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/bd/e9/72c3dc8f7dd7874812be6a6ec788ba1300bfe31570963a7e788c86280cb9/h11-0.12.0.tar.gz"
    sha256 "47222cb6067e4a307d535814917cd98fd0a57b6788ce715755fa2b6c28b56042"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/e0/c5/c6aa5cdf93808549d8495569f12757f9800a1c59be4b153b23814712a604/httpcore-0.12.3.tar.gz"
    sha256 "37ae835fb370049b2030c3290e12ed298bf1473c41bb72ca4aa78681eba9b7c9"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/f2/f4/de27c93aaaf6f9b24334a320b40d9d6df379c4d707e777bde07aedc83c35/httpx-0.17.1.tar.gz"
    sha256 "cc2a55188e4b25272d2bcd46379d300f632045de4377682aa98a8a6069d55967"
  end

  resource "hupper" do
    url "https://files.pythonhosted.org/packages/41/24/ea90fef04706e54bd1635c05c50dc9cf87cda543c59303a03e7aa7dda0ce/hupper-1.10.2.tar.gz"
    sha256 "3818f53dabc24da66f65cf4878c1c7a9b5df0c46b813e014abdd7c569eb9a02a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/9f/24/1444ee2c9aee531783c031072a273182109c6800320868ab87675d147a05/idna-3.1.tar.gz"
    sha256 "c5b02147e01ea9920e6b0a3f1f7bb833612d507592c837a6c49552768f4054e1"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/68/1a/f27de07a8a304ad5fa817bbe383d1238ac4396da447fa11ed937039fa04b/itsdangerous-1.1.0.tar.gz"
    sha256 "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19"
  end

  resource "janus" do
    url "https://files.pythonhosted.org/packages/7c/1b/8769c2dca84dd8ca92e48b14750c7106ff4313df4fee651dbc3cd9e345a9/janus-0.6.1.tar.gz"
    sha256 "4712e0ef75711fe5947c2db855bc96221a9a03641b52e5ae8e25c2b705dd1d0c"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "Pint" do
    url "https://files.pythonhosted.org/packages/8d/ac/3ec9b2692e17db4d99d1b9af8c68a45a2c37aab714c1c0320a3a6f1601e0/Pint-0.17.tar.gz"
    sha256 "f4d0caa713239e6847a7c6eefe2427358566451fe56497d533f21fb590a3f313"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-baseconv" do
    url "https://files.pythonhosted.org/packages/33/d0/9297d7d8dd74767b4d5560d834b30b2fff17d39987c23ed8656f476e0d9b/python-baseconv-1.2.2.tar.gz"
    sha256 "0539f8bd0464013b05ad62e0a1673f0ac9086c76b43ebf9f833053527cd9931b"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/46/40/a933ac570bf7aad12a298fc53458115cc74053474a72fbb8201d7dc06d3d/python-multipart-0.0.5.tar.gz"
    sha256 "f7bb5f611fc600d15fa47b3974c8aa16e93724513b49b5f95c81e6624c83fa43"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/70/e2/1344681ad04a0971e8884b9a9856e5a13cc4824d15c047f8b0bbcc0b2029/rfc3986-1.4.0.tar.gz"
    sha256 "112398da31a3344dc25dbf477d8df6cb34f9278a94fee2625d89e4514be8bb9d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/26/6c/6ace1cd024a27dd692c80fd31c8e51e6b81bde459e2cae06b5ab30fc37d2/uvicorn-0.13.4.tar.gz"
    sha256 "3292251b3c7978e8e4a7868f4baf7f7f7bb7e40c759ecc125c37e99cdea34202"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/datasette --get '/:memory:.csv?sql=select+3*5'")
    assert_match "<title>Datasette:", shell_output("#{bin}/datasette --get '/'")
  end
end
