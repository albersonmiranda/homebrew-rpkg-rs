class Rpkg < Formula
  desc "A lightweight CLI wrapper around Rscript for installing R packages from CRAN or elsewhere"
  homepage "https://github.com/albersonmiranda/rip"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/albersonmiranda/rip/releases/download/v0.3.2/rpkg-aarch64-apple-darwin.tar.xz"
      sha256 "b446450df28752e439f391eba05e4f48aacfd34b76353fe347aa126777069ad1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/albersonmiranda/rip/releases/download/v0.3.2/rpkg-x86_64-apple-darwin.tar.xz"
      sha256 "0b42a228d16da74215228b6504e837e8db63afbbc9bc4fd587763f00db6bd19f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/albersonmiranda/rip/releases/download/v0.3.2/rpkg-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8861c0cd47d5e144779dac312a567b4c4a9522f147bddb6010625dcd56826c8b"
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
