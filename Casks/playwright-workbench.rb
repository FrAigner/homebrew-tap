cask "playwright-workbench" do
  arch arm: "arm64", intel: "x64"

  version "0.4.2"
  sha256 arm:   "fa9a64c6dd550a61a75845036d150f1c25c753857431bb546120f04995ff8b4c",
         intel: "694401c91c22ebf2a72d3248e2c5d27495a1b527a62f4b489a53ce88b1976c2b"

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
