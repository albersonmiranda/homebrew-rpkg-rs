class Rpkg < Formula
  desc "A lightweight CLI wrapper around Rscript for installing R packages from CRAN or elsewhere"
  homepage "https://github.com/albersonmiranda/rip"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/albersonmiranda/rip/releases/download/v0.3.2/rpkg-aarch64-apple-darwin.tar.xz"
      sha256 "ba7272f7231cc787da290f724d8444737197e3f975489b3333712a8a46965103"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albersonmiranda/rip/releases/download/v0.3.2/rpkg-x86_64-apple-darwin.tar.xz"
      sha256 "73f90ddf5d9c04e720503f21dd2481313c0aeb72bd6dcf0e92399e0826152cc6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/albersonmiranda/rip/releases/download/v0.3.2/rpkg-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5e4e4423e267877c7c793f073bdd9466b251c9100649a4b743085dab03f2708d"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rpkg" if OS.mac? && Hardware::CPU.arm?
    bin.install "rpkg" if OS.mac? && Hardware::CPU.intel?
    bin.install "rpkg" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
