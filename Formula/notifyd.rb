class Notifyd < Formula
  desc "Agent-first self-hosted notification service. Email, SMS, Push, In-App — one binary, Postgres only."
  homepage "https://github.com/rmzlb/notifyd"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rmzlb/notifyd/releases/download/v0.2.2/notifyd-aarch64-apple-darwin.tar.xz"
      sha256 "52a2a950b079c594c2594e36690389074bcdf2916fa3c543c8645474c74da863"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rmzlb/notifyd/releases/download/v0.2.2/notifyd-x86_64-apple-darwin.tar.xz"
      sha256 "d8d370a7730046fb6576313b628db348f6ea1688dd74c87a534a44776bb7ab1c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rmzlb/notifyd/releases/download/v0.2.2/notifyd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "395bcba9d5c5f73cb808c381a3ef389e024b56b1671a56ee66557474382895c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rmzlb/notifyd/releases/download/v0.2.2/notifyd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1af4d9448ac9495d7d7c8bf5abcdf3f0d0bc4f6842a9b01c4e4e5ff65d10c825"
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
