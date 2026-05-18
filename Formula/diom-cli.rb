class DiomCli < Formula
  desc "CLI for interacting with the Diom components platform"
  homepage "https://diom.com"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/svix/diom/releases/download/v0.2.4/diom-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a40f3475acb325083218a3a7b9083556d98ce397f132a42b94f3cd3be0971038"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/diom/releases/download/v0.2.4/diom-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ec109cb3f06d34e40eda2af0ac394fc8fac5672381723ffc7cda8c1ac92ffd47"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/svix/diom/releases/download/v0.2.4/diom-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "08c412a353a6884915c820faa73af156ec3db308dd66f1f917675d1dd34a518e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/svix/diom/releases/download/v0.2.4/diom-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "57d7ae7561818e09135ed45822613b23698ca6caa68aead51eb4cb5ca947a8dc"
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
