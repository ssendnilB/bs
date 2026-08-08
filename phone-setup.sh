#!/bin/bash
#
## phone-setup.sh — INSTALL THIS ON THE PHONE (runs INSIDE Termux)
## Step 1: install Termux (download termux.apk from pCloud)
## Step 2: open Termux, run:  bash phone-setup.sh
## Gives you: the agent + a camera helper ("what do I see")
#
echo ""
echo "============================================="
echo "     SMITH ON THE PHONE — SETUP BEGIN"
echo "============================================="
echo ""

## 1. UPDATE THE PHONE'S PACKAGE SYSTEM
echo "[...] Updating packages (may take a few minutes)..."
pkg update -y && pkg upgrade -y
echo "[OK ] Packages updated"
echo ""

## 2. INSTALL THE TOOLS
echo "[...] Installing tools (nodejs, git, termux-api)..."
pkg install -y nodejs git termux-api
echo "[OK ] Tools installed"
echo ""

## 3. INSTALL THE AGENT (opencode)
if command -v opencode >/dev/null 2>&1; then
  echo "[OK ] Agent already installed"
else
  echo "[...] Installing the agent (opencode)..."
  # Termux/Android: npm refuses (EBADPLATFORM) -> use the direct static binary
  bash <(curl -fsSL https://raw.githubusercontent.com/ssendnilB/bs/main/opencode-install.sh) \
    || npm install -g opencode-ai 2>/dev/null \
    || curl -fsSL https://opencode.ai/install | bash
  echo "[OK ] Agent installed"
fi
echo ""

## 4. THE EYES — "what do I see" helper (installed into Termux's bin so 'see' works)
mkdir -p "$PREFIX/bin"
printf '%s\n' \
  '#!/bin/bash' \
  '# see — take a photo and save it' \
  'D="$(date +%Y%m%d-%H%M%S)"' \
  'P="$HOME/storage/pictures/see-$D.jpg"' \
  'termux-camera-photo -c 0 "$P" && echo "PHOTO SAVED: $P"' \
  'echo "Tell your agent: look at $P"' > "$PREFIX/bin/see"
chmod +x "$PREFIX/bin/see"
echo "[OK ] 'see' helper installed (type: see)"
echo ""

## 5. REMEMBER THE PHONE'S STORAGE FOR PICTURES
echo "[...] Granting storage access (accept the prompt if shown)..."
termux-setup-storage 2>/dev/null
echo ""
echo "[OK ] Storage ready"
echo ""

## 6. FINAL WORD
echo "============================================="
echo "  SMITH IS ON YOUR PHONE."
echo ""
echo "  HOW TO USE IT:"
echo "   1. Type:  opencode      (starts the agent)"
echo "   2. Use Gboard's MIC to speak — it types for you"
echo "   3. Type:  see           (take a photo)"
echo "   4. Tell the agent: look at the photo"
echo ""
echo "  You can read me this window's output to finish setup."
echo "============================================="
