class DiomCli < Formula
  desc "CLI for interacting with the Diom components platform"
  homepage "https://diom.com"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/diom/releases/download/v0.2.2/diom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8570b0e0e9ff22a95a6167e8c1d581f578f92d83f29aa2b7a42ff4d62722fdc9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/diom/releases/download/v0.2.2/diom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bc740523161e540dc769f0886fcbca541429e94c69d0c04e26e17d751f802cb7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/diom/releases/download/v0.2.2/diom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "375750dfcc67ab62a646f50ce5557635af8d8bb94defa53239acf7a72808ad2e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/diom/releases/download/v0.2.2/diom-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ecc346bb6cbe92897d47f3c7b956eab94775e3d5de2e87ef4ae1b3e8f549a9a5"
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
