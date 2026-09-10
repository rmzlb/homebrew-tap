class Notifyd < Formula
  desc "Agent-first self-hosted notification service. Email, SMS, Push, In-App — one binary, Postgres only."
  homepage "https://github.com/rmzlb/notifyd"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rmzlb/notifyd/releases/download/v0.3.0/notifyd-aarch64-apple-darwin.tar.xz"
      sha256 "bff6cf41b44313d54faf9fd008e8794752911ce8b9782d521e0dfc125f60024f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rmzlb/notifyd/releases/download/v0.3.0/notifyd-x86_64-apple-darwin.tar.xz"
      sha256 "10f523e3083d8255510939e3b1758d4a34181276ece2c701732005126c122c07"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rmzlb/notifyd/releases/download/v0.3.0/notifyd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a38e619c937b54a8d5c2c376c8662877f7233970459d86995da17df84f2b09be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rmzlb/notifyd/releases/download/v0.3.0/notifyd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3500bb6602f0f00a80978a73840c121e9efb827358857c33c1683ca83f151649"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "notifyd"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "notifyd"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "notifyd"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "notifyd"
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
