require "formula"

class Screen < Formula
  homepage "http://www.gnu.org/software/screen"

  stable do
    url "http://ftpmirror.gnu.org/screen/screen-4.2.1.tar.gz"
    mirror "http://ftp.gnu.org/gnu/screen/screen-4.2.1.tar.gz"
    sha1 "21eadf5f1d64120649f3390346253c6bc8a5103c"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha1 "93d611f1f46c7bbca5f9575304913bd1c38e183b"
    end
    
    # This patch is to enable 500kbps as a possible baud rate
    patch :p3 do
      url "https://gist.githubusercontent.com/JamesHagerman/a369606bc6cb34b6a433/raw/12017a74085e66d64bea4899645a6bb0d113dc39/add500kbp.diff"
      sha1 "e07e6e375dbfa5770f2690ada288012561568986"
    end
  end

  head do
    url "git://git.savannah.gnu.org/screen.git"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha1 "93d611f1f46c7bbca5f9575304913bd1c38e183b"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    if build.head?
      cd "src"
    end

    # With parallel build, it fails
    # because of trying to compile files which depend osdef.h
    # before osdef.sh script generates it.
    ENV.deparallelize

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-colors256"
    system "make"
    system "make install"
  end
end
