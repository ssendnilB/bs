#!/data/data/com.termux/files/usr/bin/bash
#
## opencode-install.sh v3 — installs the opencode agent on Termux/Android (arm64)
##
## NEW ROUTE (2026-08-09): pre-built community packages from
##   github.com/Hope2333/opencode-termux (release Push260803)
## The package wraps the official opencode binary with bun-termux-loader so it
## runs natively on Termux — no chroot, no proot. This REPLACES the old
## glibc-runner/grun route, which segfaulted on Android's kernel protections.
##
## IMMUTABILITY: the agent version is PINNED below. It cannot silently change.
## The .deb is kept in a local vault so a phone reimage can restore it offline
## (mirrors the GrapheneOS vault philosophy).
## PERMANENCE: a Termux:Boot autostart script is written so the agent comes
## back after every reboot (requires the Termux:Boot app from F-Droid).
#
set -e
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"

# PIN the exact agent build. Update deliberately (this is your safety pin).
V="1.18.15"
REL="Push260803"
BASE="https://github.com/Hope2333/opencode-termux/releases/download/${REL}"

echo ""
echo "============================================="
echo "  OPENCODE AGENT — TERMUX INSTALL v3 (arm64)"
echo "  pinned opencode v${V}"
echo "============================================="
echo ""

echo "[1/5] Installing runtime deps (glibc + openssl-glibc)..."
pkg install -y glibc-repo bash ncurses ripgrep
pkg update
pkg install -y glibc openssl-glibc

echo "[2/5] Downloading pinned agent package v${V} (~41 MB)..."
VAULT="$HOME/agent-vault"
mkdir -p "$VAULT"
DEB="$VAULT/opencode_${V}_aarch64.deb"
if [ ! -f "$DEB" ]; then
  curl -fSL --max-time 600 -o "$DEB" "$BASE/opencode_${V}_aarch64.deb"
  echo "      saved vault copy: $DEB"
else
  echo "      (already in vault — keeping local copy)"
fi

echo "[3/5] Installing the package..."
dpkg -i "$DEB" || apt install -f -y

echo "[4/5] Verifying the agent runs..."
opencode --version || { echo "ERROR: agent did not start. Paste the output back to Smith."; exit 1; }

echo "[5/5] Writing Termux:Boot autostart for permanence..."
mkdir -p "$HOME/.termux/boot"
printf '#!/data/data/com.termux/files/usr/bin/sh\nunset LD_PRELOAD\ntmux new-session -d -s agent opencode 2>/dev/null || true\n' > "$HOME/.termux/boot/opencode-boot.sh"
chmod 755 "$HOME/.termux/boot/opencode-boot.sh"

echo ""
echo "============================================="
echo "  DONE. opencode v${V} is installed."
echo "  - Vault (offline reinstall kit):"
echo "      $VAULT/opencode_${V}_aarch64.deb"
echo "  - Type:  opencode      to start the agent"
echo "  - Permanent at boot: install 'Termux:Boot' from F-Droid,"
echo "    then this session auto-starts the agent every reboot."
echo "============================================="
