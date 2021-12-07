class GtkDoc < Formula
  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.32/gtk-doc-1.32.tar.xz"
  sha256 "de0ef034fb17cb21ab0c635ec730d19746bce52984a6706e7bbec6fb5e0b907c"
  revision 2

  # We use a common regex because gtk-doc doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9693e712ef8fa2b8e9d3be7c30bc1a5e31616e3de51a6c3f8660f5f96c57cf70"
    sha256 cellar: :any_skip_relocation, big_sur:       "a35e40c983e136158fc38ba12cb6fefff3158b8a558fd1593a8d60dd1eb2bd45"
    sha256 cellar: :any_skip_relocation, catalina:      "8f016abd2862496357f6a926a55c3429187dc429ac746fa98b485b302761271b"
    sha256 cellar: :any_skip_relocation, mojave:        "588cd9e3cb54d2f778c82bfb586573a3211cdc9d8a537ef61e7c96a9395ad688"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2e5f324a0c3e8aac532e8946fb00cc578d18184e8fb8d247329b7fbe252054b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a33b72654200054db94cbb9fea1e5a45f28be2aa6e6639665f16d2df3a677724"
  end

  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "gettext"
  depends_on "libxml2"
  depends_on "python@3.9"
  depends_on "source-highlight"

  uses_from_macos "libxslt"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/7e/ae/26808275fc76bf2832deb10d3a3ed3107bc4de01b85dcccbe525f2cd6d1e/Pygments-2.4.2.tar.gz"
    sha256 "881c4c157e45f30af185c1ffe8d549d48ac9127433f2c380c24b84572ad66297"
  end

  def install
    # To avoid recording the shims path
    ENV["PKG_CONFIG"] = Formula["pkg-config"].bin/"pkg-config"

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resource("Pygments").stage do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-highlight=source-highlight",
                          "--with-xml-catalog=#{etc}/xml/catalog"
    system "make"
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end
