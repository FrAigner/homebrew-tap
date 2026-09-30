cask "playwright-workbench" do
  arch arm: "arm64", intel: "x64"

  version "0.1.0"
  sha256 arm:   "5313f1f910d402b3033f76822044c9497bc2ef50b028be4c98099746ecf63bc9",
         intel: "af90af42393d6a867b709b824b50f03f1ca19ba3dcdc475efcb857da8bbe59ad"

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
