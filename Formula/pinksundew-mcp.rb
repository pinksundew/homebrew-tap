class PinksundewMcp < Formula
  desc "Pink Sundew MCP server (Rust runtime)"
  homepage "https://pinksundew.com"
  version "2.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.2.4/pinksundew-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "4f02f9ecfe8090128e7e01a87a900f7a50a072a8513b668f21e0c00ea14e3e7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.2.4/pinksundew-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "5714b6c6e249c4a496282da5c3a5467f4c9f1dfdb9752135ac7a9441b363e748"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.2.4/pinksundew-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d81d3e43482e3ade7bcb333eaeb98e4d5702b790a5400266dcd83e6b3e4d909c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.2.4/pinksundew-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "486411e71eca8179f7c5d91fcc397b7010924869aec4a132a1f44d849aeae167"
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
