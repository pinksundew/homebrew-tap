class PinksundewMcp < Formula
  desc "Pink Sundew MCP server (Rust runtime)"
  homepage "https://pinksundew.com"
  version "2.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.3.0/pinksundew-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "4ad7540cd4167a61f51055c91092f645c7061b28d02bfabfa31891043b4f4996"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.3.0/pinksundew-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "2f5bd1f8b93361e57f1ccf8a6c4121ff36b4be5a130bdbf15a56f1c24b88459f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.3.0/pinksundew-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5e760e95cc474dffe6db069a7bc0bda84e7f368b780adf807b98b26f27b639d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.3.0/pinksundew-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a669522131e38a2d293aa2023a26ad182d9a63fd87815d1d7199381509d0d72"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "pinksundew-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "pinksundew-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "pinksundew-mcp" if OS.linux? && Hardware::CPU.arm?
    bin.install "pinksundew-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
