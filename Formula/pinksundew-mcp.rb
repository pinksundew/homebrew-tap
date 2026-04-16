class PinksundewMcp < Formula
  desc "Pink Sundew MCP server (Rust runtime)"
  homepage "https://pinksundew.com"
  version "2.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.3/pinksundew-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "2ba39e372d08a0007dc1f588a3107edf769f0e41b33e26f70e5fdcc261d83da6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.3/pinksundew-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "db89aeb5da18b5beeddf1d0e5388d9ef30faea78be4c0e1d8073c99d35159b90"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.3/pinksundew-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "74c366c1dbead700132e69b1ea63a5152edd066a50533906791a06c4e8d1849c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.3/pinksundew-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "25ddb60feb43b8e1c4e819f68dc3affd8070f131df7717be81163f3243ce2144"
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
