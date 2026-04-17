class PinksundewMcp < Formula
  desc "Pink Sundew MCP server (Rust runtime)"
  homepage "https://pinksundew.com"
  version "2.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.2.1/pinksundew-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "94a308e19c68bb132d46b58009074afa47c4afd8a4705c4729e4dcb30bd7f32f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.2.1/pinksundew-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "d95d38975255a8369155e880855cc4761c03d2657af1f7b9bbbf7030b4fa8f0e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.2.1/pinksundew-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2f85b8bfcbce2f2068a2f94aa70bfb18af1fa167d9637c93bcf5b4789e11dc35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.2.1/pinksundew-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f8722b12e65ac9943a234c5cb402e8415f765fae0bff46d123d5d5d57b21924c"
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
