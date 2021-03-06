require "formula"

class Whois < Formula
  homepage "https://packages.debian.org/sid/whois"
  url "http://ftp.us.debian.org/debian/pool/main/w/whois/whois_5.2.2.tar.xz"
  sha1 "4438b9940b27b67459c82e4e6865a087e491788d"

  def install
    # autodie was not shipped with the system perl 5.8
    inreplace "make_version_h.pl", "use autodie;", "" if MacOS.version < :snow_leopard

    system "make HAVE_ICONV=1 whois_LDADD+=-liconv whois"
    bin.install "whois"
    man1.install "whois.1"
  end

  def caveats; <<-EOS.undent
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.
    EOS
  end

  test do
    system "#{bin}/whois"
  end
end
