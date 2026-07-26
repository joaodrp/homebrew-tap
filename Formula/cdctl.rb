class Cdctl < Formula
  desc "CLI for the Control D REST API (not the ctrld DNS daemon)"
  homepage "https://github.com/joaodrp/controld-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/joaodrp/controld-cli/releases/download/v0.1.0/controld-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f19874ab5cacee0f4393f8d49fed67ca6a630ee92c671774a8c4890bc687724c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/joaodrp/controld-cli/releases/download/v0.1.0/controld-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5906db7aee1a07ae820cef1a648f21a580f57cbbdc88f9aa5699a32903ad89fe"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/joaodrp/controld-cli/releases/download/v0.1.0/controld-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "c027039e2dcc205256ada5c8a7e4c352b4a5b592875deec9f65f96e65aa87120"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
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
    bin.install "cdctl" if OS.mac? && Hardware::CPU.arm?
    bin.install "cdctl" if OS.mac? && Hardware::CPU.intel?
    bin.install "cdctl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
