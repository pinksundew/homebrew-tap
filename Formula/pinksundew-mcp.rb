class PinksundewMcp < Formula
  desc "Pink Sundew MCP server (Rust runtime)"
  homepage "https://pinksundew.com"
  version "2.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.5/pinksundew-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "064895572b1997863b9a95f228d5ca314459e4b583eb4d4354d10ebf05048a58"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.5/pinksundew-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "6013debb4e2432cd0ea5b97b9ba33c87b72c4fe40a605e85c6b79deb829d9ef5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.5/pinksundew-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d181bf41f4ab1a5ec90f28e21b5078fef5d096e6de2e16e7b96cc29840b1d159"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.5/pinksundew-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f0d76657905111e6674bc628c63e47cbebddc87f7d6a853f72a37b4a4afdfd96"
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
