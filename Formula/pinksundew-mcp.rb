class PinksundewMcp < Formula
  desc "Pink Sundew MCP server (Rust runtime)"
  homepage "https://pinksundew.com"
  version "2.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.1/pinksundew-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "b4f308e89932be979b81bdbcc5abf10c749d3bbaf8a388dec3e4cbfd34ed0295"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.1/pinksundew-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "bd3770aa18ffcc0cd41ffd2abd575d0f250a3856bc30fd0159d8b32dbea0f5a0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.1/pinksundew-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7ff4f9a154fad1b6e2f098f7d0bdc5db58f05415e653f1ed0183b5b4ab8fcb93"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.1/pinksundew-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "400b733302a2b6537ca0f33109a3bddec28aa374e6bf1a2492832a206c639a42"
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
