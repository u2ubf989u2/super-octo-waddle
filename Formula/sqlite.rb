class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/"
  url "https://sqlite.org/2021/sqlite-autoconf-3350500.tar.gz"
  version "3.35.5"
  sha256 "f52b72a5c319c3e516ed7a92e123139a6e87af08a2dc43d7757724f6132e6db0"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "85e058d256013feea4835f51d9054dd1b8eec435d66ed581c95d161b3152e3b0"
    sha256 cellar: :any,                 big_sur:       "801e11dff40b2e7067b8e124d266f82050cbae434447d7fa1ad36888fd8ceec2"
    sha256 cellar: :any,                 catalina:      "217e257590018c8e0b2e994f8f8c9fa548459f1532acecf0b229f9885bf0ce22"
    sha256 cellar: :any,                 mojave:        "b25dc8abacbef73874c1ee995beff6a0612e2863523913ccb348eda918c3547e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b1a4c7d1bcde097e2b645bd0c653290ac6202fad8cdb18420b867c465fa0a93"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  uses_from_macos "zlib"

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_COLUMN_METADATA=1"
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_RTREE=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_JSON1=1"

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-dynamic-extensions
      --enable-readline
      --disable-editline
      --enable-session
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
