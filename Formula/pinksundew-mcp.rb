class PinksundewMcp < Formula
  desc "Pink Sundew MCP server (Rust runtime)"
  homepage "https://pinksundew.com"
  version "2.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.4.0/pinksundew-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "451bf7791e604bb29b70029d476a38e091d01ee3518a65074bc4e9f83f2df294"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.4.0/pinksundew-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "50f0fb8d051a49464e2282687e04f11de31acb4d9d99a4645776d255631015ed"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.4.0/pinksundew-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "723aee19c43e81274d7d90c08aec6943464cbb7bdf1f38e6a65c944ed7637818"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.4.0/pinksundew-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9465adf310476cb74baa9aa5a6d1c3f06bda34d53c042e7a441bfd02c0cf4ca9"
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
