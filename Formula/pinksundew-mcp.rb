class PinksundewMcp < Formula
  desc "Pink Sundew MCP server (Rust runtime)"
  homepage "https://pinksundew.com"
  version "2.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.6/pinksundew-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "8172269bf25a95cd22c0b6649b596cf19a4884845c5914cd308eb68ddd466217"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.6/pinksundew-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "7e08a69c52783cde557400ca8c6e99d2e528d369a36a5c7d1ef12434c70dcc23"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.6/pinksundew-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9e9a3f99d1817ee4700a02e9197e6f381dffb94636a6a7ff8e44c69ff6204167"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qadolphe/AgentPlanner/releases/download/v2.1.6/pinksundew-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1b51d7e10b258e5c0c7ce949296234b8c5c581fd0a58ae660cf4095e14680569"
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
