class PinksundewMcp < Formula
  desc "Pink Sundew MCP server (Rust runtime)"
  homepage "https://pinksundew.com"
  version "2.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.5.0/pinksundew-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "1871ebe0c0a9765196c98045667b9463cbc7731ce500cccb08077b64a8fe6a8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.5.0/pinksundew-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "f452f0851e95bf85fa9ee5794a8134d4fdb6952915e01af435214070dcf39bed"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.5.0/pinksundew-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a0594312dc64164ca686e7fd7879a6d6317b8d5e6e1b36a7a6d4e2376d13d1c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pinksundew/pinksundew/releases/download/v2.5.0/pinksundew-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6a7190b0e70cd2c985117df74f630b084b11155676ff12ff5db36667b4071ac1"
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
