#!/usr/bin/env bash
# Regenerates Casks/playwright-workbench.rb for a release, e.g.: ./update-playwright-workbench.sh 0.1.0
set -euo pipefail

VERSION="${1:?Version angeben, z.B. 0.1.0}"
REPO="FrAigner/playwright-workbench"
GH="${GH:-gh}"
cd "$(dirname "$0")"

digest() {
  local name="playwright-workbench-${VERSION}-$1.dmg"
  local d
  d=$("$GH" api "repos/$REPO/releases/tags/v$VERSION" --jq ".assets[] | select(.name==\"$name\") | .digest")
  [[ "$d" == sha256:* ]] || { echo "Keine SHA256 für $name gefunden" >&2; exit 1; }
  echo "${d#sha256:}"
}

ARM=$(digest arm64)
INTEL=$(digest x64)

cat > Casks/playwright-workbench.rb <<EOF
cask "playwright-workbench" do
  arch arm: "arm64", intel: "x64"

  version "$VERSION"
  sha256 arm:   "$ARM",
         intel: "$INTEL"

  url "https://github.com/$REPO/releases/download/v#{version}/playwright-workbench-#{version}-#{arch}.dmg"
  name "Playwright Workbench"
  desc "Write and run Playwright tests without installing Node.js or npm"
  homepage "https://github.com/$REPO"

  livecheck do
    url :url
    strategy :github_latest
  end

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
EOF
echo "Casks/playwright-workbench.rb -> $VERSION (arm64 $ARM, x64 $INTEL)"
