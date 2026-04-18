class PinksundewMcp < Formula
  desc "Pink Sundew MCP server (Rust runtime)"
  homepage "https://pinksundew.com"
  version "2.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.2.5/pinksundew-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "cccfc7aea9ed3f5389101d572205bb1d1290b412e7a09d6eebdc04f9281c97bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.2.5/pinksundew-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "758cd26d0bc752155866b2825dc0a5b38e7244db1eaddbef23a649067402fbc4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.2.5/pinksundew-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8f67a85362e9c5b547238be33a2aa1105059a20fd382484a9a127e056d3624f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.2.5/pinksundew-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42be435b10ed2c1d5b54e45e2dc9ee0955ae3d4b895539351ef77d745646384a"
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
