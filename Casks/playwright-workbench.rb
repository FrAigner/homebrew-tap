cask "playwright-workbench" do
  arch arm: "arm64", intel: "x64"

  version "0.1.2"
  sha256 arm:   "40f267ff49d1d0b8816efab2da87b90164fc8412c6364afb94d08917c42e2b05",
         intel: "6327771c6da41cc3a0eb0745666b4566ae74cb3c6db39673625a694c7d1173df"

  url "https://github.com/FrAigner/playwright-workbench/releases/download/v#{version}/playwright-workbench-#{version}-#{arch}.dmg"
  name "Playwright Workbench"
  desc "Write and run Playwright tests without installing Node.js or npm"
  homepage "https://github.com/FrAigner/playwright-workbench"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Playwright Workbench.app"

  # Not notarized by Apple: drop the quarantine flag so Gatekeeper does not block the first launch.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Playwright Workbench.app"]
  end

  zap trash: [
    "~/Library/Application Support/Playwright Workbench",
    "~/Library/Preferences/online.aigner.playwright-workbench.plist",
    "~/Library/Saved Application State/online.aigner.playwright-workbench.savedState",
  ]
end
