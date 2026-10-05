cask "playwright-workbench" do
  arch arm: "arm64", intel: "x64"

  version "0.2.0"
  sha256 arm:   "b9987c1a7cbece290c72227bc70a9ed66f66afb1d38410b3c9290ed62a0c1983",
         intel: "2f7a557f004c1e26ffc02283a11b4213c95139cdfde92c5896c25eb3f8cd4bf8"

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
