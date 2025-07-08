class Doist < Formula
  desc "doist is an unofficial command line app for interacting with the Todoist API"
  homepage "https://github.com/chaosteil/doist"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chaosteil/doist/releases/download/v0.3.3/doist-aarch64-apple-darwin.tar.xz"
      sha256 "692f0d14e00de90fc32dd71a4421de5bc7a400b5cfcc9556348b90c6ce796782"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chaosteil/doist/releases/download/v0.3.3/doist-x86_64-apple-darwin.tar.xz"
      sha256 "5e63287169bed2dbbdc304f991673957a9d587852cbabaa679a6477b27f917f0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/chaosteil/doist/releases/download/v0.3.3/doist-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0c93345b24728a02e0939c151f127b9c25c9ceed84e4149c9893d5b96ba8d51a"
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
    bin.install "doist" if OS.mac? && Hardware::CPU.arm?
    bin.install "doist" if OS.mac? && Hardware::CPU.intel?
    bin.install "doist" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
