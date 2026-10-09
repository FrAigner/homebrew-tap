cask "playwright-workbench" do
  arch arm: "arm64", intel: "x64"

  version "0.4.5"
  sha256 arm:   "2ca021235d404dd880d5511146eae6ea7e1e1a639c8f1c9cb138f0bf51f9dd1e",
         intel: "6220f0cf8fdc27fa8c1fb0cabe1533fe989541a72f17b29f109a1627f2d9aeca"

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
