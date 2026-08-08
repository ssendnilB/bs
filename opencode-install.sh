#!/data/data/com.termux/files/usr/bin/bash
#
## opencode-install.sh — installs the opencode agent on Termux/Android (arm64)
##
## Why not npm? npm refuses Android ("EBADPLATFORM"). opencode ships NO static
## build — every linux-arm64 binary is dynamically linked to glibc, whose loader
## (/lib/ld-linux-aarch64.so.1) does not exist on Termux. So we:
##   1. install Termux's official glibc support (glibc-repo + glibc-runner),
##   2. fetch the glibc linux-arm64 binary from the npm registry,
##   3. "grun --configure" it — this uses patchelf to point the binary's
##      interpreter at Termux's glibc loader and set its RPATH, making it run
##      natively (and letting opencode re-exec itself when it spawns its server),
##   4. leave a small launcher at $PREFIX/bin/opencode.
#
set -e

PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
BINDIR="$PREFIX/lib/opencode"

echo ""
echo "============================================="
echo "  OPENCODE AGENT — TERMUX INSTALL (arm64)"
echo "============================================="
echo ""

echo "[1/5] Enabling glibc support (needed to run the Linux binary)..."
if ! command -v grun >/dev/null 2>&1; then
  pkg install -y glibc-repo
  pkg update
  pkg install -y glibc-runner patchelf
fi
command -v grun >/dev/null 2>&1 || { echo "ERROR: glibc-runner did not install."; exit 1; }

V="$(curl -fsSL --max-time 20 https://registry.npmjs.org/opencode-ai/latest 2>/dev/null \
  | grep -oE '"version": *"[0-9.]+"' | head -1 | sed -E 's/.*"([0-9.]+)".*/\1/')"
[ -n "$V" ] || V="1.18.15"
echo "[2/5] Latest agent version: $V"

echo "[3/5] Downloading the binary (about 175 MB — takes a minute)..."
TMP="$(mktemp -d)"
cd "$TMP"
curl -fSL --max-time 600 -o oc.tgz \
  "https://registry.npmjs.org/opencode-linux-arm64/-/opencode-linux-arm64-${V}.tgz"
tar -xzf oc.tgz
mkdir -p "$BINDIR"
mv -f package/bin/opencode "$BINDIR/opencode"
chmod 755 "$BINDIR/opencode"

echo "[4/5] Patching binary for native Termux execution (grun --configure)..."
grun --configure "$BINDIR/opencode"

echo "[5/5] Writing launcher at $PREFIX/bin/opencode..."
printf '#!/data/data/com.termux/files/usr/bin/sh\nunset LD_PRELOAD\nexec "%s/opencode" "$@"\n' "$BINDIR" > "$PREFIX/bin/opencode"
chmod 755 "$PREFIX/bin/opencode"
rm -rf "$TMP"

echo ""
echo "============================================="
echo "  DONE. Type:  opencode --version"
echo "       then:  opencode       to start"
echo "============================================="
