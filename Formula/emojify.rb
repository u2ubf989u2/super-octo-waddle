class Emojify < Formula
  desc "Emoji on the command-line :scream:"
  homepage "https://github.com/mrowa44/emojify"
  url "https://github.com/mrowa44/emojify/archive/v1.0.2.tar.gz"
  sha256 "a75d49d623f92974d7852526591d5563c27b7655c20ebdd66a07b8a47dae861c"
  license "MIT"
  head "https://github.com/mrowa44/emojify.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5111ab98df012a58c6baddd20a1fe045937605f705913ea1544e9704a3aea3f4"
  end

  def install
    bin.install "emojify"
  end

  test do
    input = "Hey, I just :raising_hand: you, and this is :scream: , but here's my :calling: , "\
            "so :telephone_receiver: me, maybe?"
    assert_equal "Hey, I just 🙋 you, and this is 😱 , but here's my 📲 , so 📞 me, maybe?",
      shell_output("#{bin}/emojify \"#{input}\"").strip
  end
end
