class Prover9 < Formula
  desc "Automated theorem prover for first-order and equational logic"
  homepage "https://www.cs.unm.edu/~mccune/prover9/"
  url "https://www.cs.unm.edu/~mccune/prover9/download/LADR-2009-11A.tar.gz"
  version "2009-11A"
  sha256 "c32bed5807000c0b7161c276e50d9ca0af0cb248df2c1affb2f6fc02471b51d0"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d5bf0492b97661c22bc8077463c7f577971e1a6f2db5a70f0bb86337c8de02f"
    sha256 cellar: :any_skip_relocation, big_sur:       "a81af1adbb27059709ec9bd9afd30e7819fbd750ea18736c079640058e9ca5b0"
    sha256 cellar: :any_skip_relocation, catalina:      "1f637c295f07ddf31eedf6bcc73b957584da4d55cb92c7bfea3264d6c3780d1b"
    sha256 cellar: :any_skip_relocation, mojave:        "5ae1f642fa781841fc843a548b5327cf1dfb8d8c4fbe5ea83ddffef004282d57"
    sha256 cellar: :any_skip_relocation, high_sierra:   "055cf6646dd19effa87d7b9fa8e820c24710a023bcefc98c35604205530ab2c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53992499680447c0b9c964b08b1df4af419832f4473de27e1966f9bbd052ee36"
  end

  # Order of parameters passed to gcc matters
  patch :DATA unless OS.mac?

  def install
    ENV.deparallelize
    system "make", "all"
    bin.install "bin/prover9", "bin/mace4"
    man1.install Dir["manpages/*.1"]
  end

  test do
    (testpath/"x2.in").write <<~EOS
      formulas(sos).
        e * x = x.
        x' * x = e.
        (x * y) * z = x * (y * z).
        x * x = e.
      end_of_list.
      formulas(goals).
        x * y = y * x.
      end_of_list.
    EOS
    (testpath/"group2.in").write <<~EOS
      assign(iterate_up_to, 12).
      set(verbose).
      formulas(theory).
      all x all y all z ((x * y) * z = x * (y * z)).
      exists e ((all x (e * x = x)) &
                (all x exists y (y * x = e))).
      exists a exists b (a * b != b * a).
      end_of_list.
    EOS

    system bin/"prover9", "-f", testpath/"x2.in"
    system bin/"mace4", "-f", testpath/"group2.in"
  end
end
__END__
diff --git a/provers.src/Makefile b/provers.src/Makefile
index 78c2543..9c91b4e 100644
--- a/provers.src/Makefile
+++ b/provers.src/Makefile
@@ -63,25 +63,25 @@ prover:
	$(MAKE) prover9

 prover9: prover9.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o prover9 prover9.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o prover9 prover9.o $(OBJECTS) ../ladr/libladr.a -lm

 fof-prover9: fof-prover9.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o fof-prover9 fof-prover9.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o fof-prover9 fof-prover9.o $(OBJECTS) ../ladr/libladr.a -lm

 ladr_to_tptp: ladr_to_tptp.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o ladr_to_tptp ladr_to_tptp.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o ladr_to_tptp ladr_to_tptp.o $(OBJECTS) ../ladr/libladr.a -lm

 tptp_to_ladr: tptp_to_ladr.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o tptp_to_ladr tptp_to_ladr.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o tptp_to_ladr tptp_to_ladr.o $(OBJECTS) ../ladr/libladr.a -lm

 autosketches4: autosketches4.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o autosketches4 autosketches4.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o autosketches4 autosketches4.o $(OBJECTS) ../ladr/libladr.a -lm

 newauto: newauto.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o newauto newauto.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o newauto newauto.o $(OBJECTS) ../ladr/libladr.a -lm

 newsax: newsax.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o newsax newsax.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o newsax newsax.o $(OBJECTS) ../ladr/libladr.a -lm

 cgrep: cgrep.o $(OBJECTS)
	$(CC) $(CFLAGS) -o cgrep cgrep.o $(OBJECTS) ../ladr/libladr.a
