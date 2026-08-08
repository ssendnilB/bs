#!/bin/bash
#
## opencode-install.sh — installs the opencode agent on Termux/Android (arm64)
## Why not npm? npm refuses Android ("EBADPLATFORM"). So we grab the
## static linux-arm64 binary straight from the npm registry and drop it
## into $PREFIX/bin, which Termux always searches.
#
set -e

echo ""
echo "============================================="
echo "  OPENCODE AGENT — DIRECT INSTALL (arm64)"
echo "============================================="
echo ""

V="$(curl -fsSL --max-time 20 https://registry.npmjs.org/opencode-ai/latest 2>/dev/null \
  | grep -oE '"version": *"[0-9.]+"' | head -1 | sed -E 's/.*"([0-9.]+)".*/\1/')"
[ -n "$V" ] || V="1.18.15"
echo "[...] Latest agent version: $V"
echo "[...] Downloading the binary (about 175 MB — takes a minute)..."
cd "$HOME"
curl -fSL --max-time 600 -o oc.tgz \
  "https://registry.npmjs.org/opencode-linux-arm64/-/opencode-linux-arm64-${V}.tgz"
echo "[...] Extracting..."
tar -xzf oc.tgz
mkdir -p "$PREFIX/bin"
mv -f package/bin/opencode "$PREFIX/bin/opencode"
chmod +x "$PREFIX/bin/opencode"
rm -rf package oc.tgz

echo "[OK ] Agent installed to $PREFIX/bin/opencode"
echo ""
echo "============================================="
echo "  DONE. Type:  opencode   to start the agent"
echo "============================================="
