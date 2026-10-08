class DiomCli < Formula
  desc "CLI for interacting with the Diom components platform"
  homepage "https://diom.com"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/diom/releases/download/v0.2.5/diom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0b7733b69ab196ae2385de575e52f06b9df146aa87828493430edd31af40e14e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/diom/releases/download/v0.2.5/diom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "722ac2f6ef80055059db6bf1bbf603a6f4671d3a3d89e8fa7e108250c4c20203"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/diom/releases/download/v0.2.5/diom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7665f5e3f1263b84b62b7aef974c9b5a63dbc0881e34c3a3908111c63423b871"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/diom/releases/download/v0.2.5/diom-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "3a78dae44b75a67d3a2422a6534b9a5cde91863699eccf079d7aeecf4ae9e5b1"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "diom"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "diom"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "diom"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "diom"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
