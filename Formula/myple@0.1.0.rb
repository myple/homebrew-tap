class MypleAT010 < Formula
  desc "Work seamlessly with Myple from the command-line"
  homepage "https://myple.io"
  version "0.1.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/myple/cli/releases/download/v#{version}/myple-v#{version}-darwin-arm64.tar.gz"
      sha256 "74958e86a3f927eb03882b193db91be8ee42c31441055f91a101511606f41880" # myple-v0.1.0-darwin-arm64.tar.gz
    elsif Hardware::CPU.intel?
      url "https://github.com/myple/cli/releases/download/v#{version}/myple-v#{version}-darwin-amd64.tar.gz"
      sha256 "9f521ae1c122228227940e17f788b7bc7e5923934aec34494abbfa8a159404da" # myple-v0.1.0-darwin-amd64.tar.gz
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/myple/cli/releases/download/v#{version}/myple-v#{version}-linux-arm64.tar.gz"
      sha256 "cbbb0959a34f65bd2beb9784fc37443c8def09c80a1f064d460e5c7c9ce7c4e6" # myple-v0.1.0-linux-arm64.tar.gz
    elsif Hardware::CPU.intel?
      url "https://github.com/myple/cli/releases/download/v#{version}/myple-v#{version}-linux-amd64.tar.gz"
      sha256 "91204ec3de0a197ec772471ca6cd5cf5a679629bdb357d8fe690dad6dc9c585c" # myple-v0.1.0-linux-amd64.tar.gz
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
