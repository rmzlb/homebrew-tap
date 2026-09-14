class Notifyd < Formula
  desc "Agent-first self-hosted notification service. Email, SMS, Push, In-App — one binary, Postgres only."
  homepage "https://github.com/rmzlb/notifyd"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rmzlb/notifyd/releases/download/v0.4.0/notifyd-aarch64-apple-darwin.tar.xz"
      sha256 "77693448592b159740e03ea956920e1aa89c221796168b94a5a6dc83c3feeea0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rmzlb/notifyd/releases/download/v0.4.0/notifyd-x86_64-apple-darwin.tar.xz"
      sha256 "0d497bb547a7c8ab10f58b2fe766e6374b6c028bceff7f8a557ef0f4fa45bb81"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rmzlb/notifyd/releases/download/v0.4.0/notifyd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c5869b0a0921c5b0901605a95b26dcdf5180b8e233f0bfd21ca807a9295b4674"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rmzlb/notifyd/releases/download/v0.4.0/notifyd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f99944ab3f187b10ac9e2c5e3ff81b6bb7dc9b522e9435f3db70384dd10332b0"
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
