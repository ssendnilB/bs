#!/bin/bash
#
## bootstrap.sh - one-command restore for a fresh Steam Deck
## Usage:  curl -fsSL -o /tmp/bs.sh <this url> && bash /tmp/bs.sh
##
set -e

echo ""
echo "================================"
echo " Steam Deck bootstrap"
echo "================================"
echo ""

echo "STEP 1: Installing GitHub CLI..."
mkdir -p "$HOME/.local/bin"
if ! command -v gh >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/gh" ]; then
  GH_VERSION=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest | grep -m1 '"tag_name"' | cut -d'"' -f4)
  curl -fsSL -o /tmp/gh.tar.gz \
    "https://github.com/cli/cli/releases/download/${GH_VERSION}/gh_${GH_VERSION#v}_linux_amd64.tar.gz"
  tar -xzf /tmp/gh.tar.gz -C /tmp
  cp "/tmp/gh_${GH_VERSION#v}_linux_amd64/bin/gh" "$HOME/.local/bin/gh"
  chmod +x "$HOME/.local/bin/gh"
  rm -rf /tmp/gh.tar.gz "/tmp/gh_${GH_VERSION#v}_linux_amd64"
fi
echo "  gh ready"

echo "STEP 2: Signing in to GitHub..."
echo "  A one-time code will appear. Enter it at github.com/login/device"
echo ""
"$HOME/.local/bin/gh" auth login --hostname github.com --git-protocol https --web

echo "STEP 3: Downloading your setup..."
"$HOME/.local/bin/gh" repo clone ssendnilB/deck-setup "$HOME/deck-setup" 2>/dev/null || \
  (cd "$HOME/deck-setup" && git pull --rebase)

echo "STEP 4: Running full restore..."
bash "$HOME/deck-setup/install.sh"

echo ""
echo "================================"
echo " BOOTSTRAP DONE"
echo "================================"
