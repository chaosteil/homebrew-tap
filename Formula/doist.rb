class Doist < Formula
  desc "doist is an unofficial command line app for interacting with the Todoist API"
  homepage "https://github.com/chaosteil/doist"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chaosteil/doist/releases/download/v0.3.2/doist-aarch64-apple-darwin.tar.xz"
      sha256 "8544bba0e7db3c1c66ef83793fcb03f5d173c924c0e8df762bf91f7e718148e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chaosteil/doist/releases/download/v0.3.2/doist-x86_64-apple-darwin.tar.xz"
      sha256 "e60c507d8d8180b21bd46da6bca2ed2f08eae1692811553db1dba3e7b7426898"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/chaosteil/doist/releases/download/v0.3.2/doist-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ccebdab023c592949111b9c2856e0cdc1e9ec944e9e0c6d096540bbb1c169538"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
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
