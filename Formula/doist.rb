class Doist < Formula
  desc "doist is an unofficial command line app for interacting with the Todoist API"
  homepage "https://github.com/chaosteil/doist"
  version "0.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chaosteil/doist/releases/download/v0.3.5/doist-aarch64-apple-darwin.tar.xz"
      sha256 "824ac4431b8ef4f32b029b554771f5a9231bcd75c7a378daf86f7fc6a6876b37"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chaosteil/doist/releases/download/v0.3.5/doist-x86_64-apple-darwin.tar.xz"
      sha256 "e77995bb07522ecb39519eb02dca4b61479d106b30420ca22c7153f321af7ee7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/chaosteil/doist/releases/download/v0.3.5/doist-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ed442b7a4097a44a1ec20e6d51e75018d6c88a3618c7b23165711bdfb75a7efa"
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
