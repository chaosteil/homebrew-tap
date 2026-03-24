class Doist < Formula
  desc "doist is an unofficial command line app for interacting with the Todoist API"
  homepage "https://github.com/chaosteil/doist"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/chaosteil/doist/releases/download/v0.4.1/doist_0.4.1_darwin_arm64.tar.gz"
      sha256 "e25ffea113182a5dbb5ac82e94a2c7412feaafdadcdb87719b7be13651ac3992"
    end
    if Hardware::CPU.intel?
      url "https://github.com/chaosteil/doist/releases/download/v0.4.1/doist_0.4.1_darwin_amd64.tar.gz"
      sha256 "d4b5e1a56c3d9d6c480d59df3e7829cdb7e62238e05dd3da00a2e944e900118a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/chaosteil/doist/releases/download/v0.4.1/doist_0.4.1_linux_amd64.tar.gz"
    sha256 "574f7a3d76489c0ccb6ffafac0d0c64356718a170bdd23a6ac624cf733fc08d3"
  end
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

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
