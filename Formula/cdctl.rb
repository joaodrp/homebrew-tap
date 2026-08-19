class Cdctl < Formula
  desc "CLI for the Control D REST API (not the ctrld DNS daemon)"
  homepage "https://github.com/joaodrp/controld-cli"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/joaodrp/controld-cli/releases/download/v0.2.0/controld-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d13a125cea8f0592b523ce107ed7560ff6a9d248c1e2bb4fca515229b8e0f53b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/joaodrp/controld-cli/releases/download/v0.2.0/controld-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c56a7eb609012884348ddec160b5b22b7818bfd4ab4498df13860059fa797746"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/joaodrp/controld-cli/releases/download/v0.2.0/controld-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a3356d67138fe281fff0125474deb39978963bc69fb708ce20d0755c7c2e7a56"
    end
    if Hardware::CPU.intel?
      url "https://github.com/joaodrp/controld-cli/releases/download/v0.2.0/controld-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f1c0f32776fcb272c88bd20bdb184137aa891d9807cb3ace580dc32f3c7851c6"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
      bin.install "cdctl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cdctl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cdctl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cdctl"
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
