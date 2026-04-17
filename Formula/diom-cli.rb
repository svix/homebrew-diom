class DiomCli < Formula
  desc "CLI for Diom"
  homepage "https://diom.com"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/diom/releases/download/v0.2.1/diom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6926852fae96c76a2db2a91f2e0f31960ef39889c9d92d4fe41eb7e5cb566968"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/diom/releases/download/v0.2.1/diom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4f015ea6c5966685add204967df04e1f74b2f2e0da0afbc3cae19e9035a89f51"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/diom/releases/download/v0.2.1/diom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "46f1cc9d6a3772abed25405f0cabc1bb60094de2baf61606b20b52cc47eed66e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/diom/releases/download/v0.2.1/diom-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7e7484c130bce14275631735448657cc13119e26031a38ff83419e149c1ef728"
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
    bin.install "diom" if OS.mac? && Hardware::CPU.arm?
    bin.install "diom" if OS.mac? && Hardware::CPU.intel?
    bin.install "diom" if OS.linux? && Hardware::CPU.arm?
    bin.install "diom" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
