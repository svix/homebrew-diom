class DiomCli < Formula
  desc "CLI for interacting with the Diom components platform"
  homepage "https://diom.com"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/diom/releases/download/v0.2.6/diom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c25997c91e2ae7ca19de52edcdfd9d12ee30e578dce2179c838f638de371364f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/diom/releases/download/v0.2.6/diom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "988366277aa6dcaaf0e7f6d0c458b6e4f8e75bce7c59077e07f4bb20f620f8f2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/diom/releases/download/v0.2.6/diom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b0d6ff7c9568a0498a2d18cbe8ae2a8035b6aaf4152c6e0e020b023aee3eb80c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/diom/releases/download/v0.2.6/diom-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "00c9269417468546a603bb94d82f3629cebb34aba5b93a35504eeb2a101e2ab0"
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
