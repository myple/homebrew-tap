class Myple < Formula
  desc "Work seamlessly with Myple from the command-line"
  homepage "https://myple.io"
  version "0.20.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/myple/cli/releases/download/v#{version}/myple-v#{version}-darwin-arm64.tar.gz"
      sha256 "2aa567da4e86b7a3311c9655b3a592c6284553fc4e6d91b91f06814377298319" # myple-v0.20.0-darwin-arm64.tar.gz
    elsif Hardware::CPU.intel?
      url "https://github.com/myple/cli/releases/download/v#{version}/myple-v#{version}-darwin-amd64.tar.gz"
      sha256 "c2f1111e0e9e1439f6faf8ae497cb09d771c473c11354a73cfae0b76bf971bda" # myple-v0.20.0-darwin-amd64.tar.gz
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/myple/cli/releases/download/v#{version}/myple-v#{version}-linux-arm64.tar.gz"
      sha256 "0387d7a6876c52c855862807032893257c6b191642468d640b7c8b4afac1fa77" # myple-v0.20.0-linux-arm64.tar.gz
    elsif Hardware::CPU.intel?
      url "https://github.com/myple/cli/releases/download/v#{version}/myple-v#{version}-linux-amd64.tar.gz"
      sha256 "81f1a54677e9e74ec4f647e5a10b89b749c0361b0a1f49c00cf80ed2592b8ec5" # myple-v0.20.0-linux-amd64.tar.gz
    end
  else
    odie "Unsupported platform. Please submit a bug report here: https://github.com/myple/cli/issues/new"
  end

  def install
    bin.install "myple"
  end

  test do
    assert_match shell_output("#{bin}/myple --version"), "myple #{version}"
  end
end
