class DiomCli < Formula
  desc "CLI for interacting with the Diom components platform"
  homepage "https://diom.com"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/diom/releases/download/v0.2.3/diom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b05199acd80d7cf538c0f52e345b205e2c28519864a51ff1973e77ccf153ad08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/diom/releases/download/v0.2.3/diom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "29d3f5badb42c0ab8bbd8d8b16dd03361c197a528d95b1e425794261515c26ac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/diom/releases/download/v0.2.3/diom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f56a33c53a7f3113f473485ef0101249b0a707d6393b9adec6dc4bf99f43a6f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/diom/releases/download/v0.2.3/diom-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "03ccfc8790643fa0876cfb933be6fe7a481ce75c763d3b7865bb78d2642d5d92"
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
