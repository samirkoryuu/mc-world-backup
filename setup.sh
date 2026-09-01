```bash
#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "=========================================="
echo " Termux Minecraft Host Environment Setup "
echo "=========================================="
echo ""

# 1. Update Termux
echo "[1/4] Updating Termux packages..."
pkg update -y
pkg upgrade -y

# 2. Install required tools
echo "[2/4] Installing required packages..."
pkg install -y openjdk-21 git curl wget

# 3. Set up Termux storage
echo "[3/4] Setting up Termux storage access..."
termux-setup-storage || true

# 4. Prepare Minecraft + Playit environment
echo "[4/4] Preparing Minecraft directory and Playit..."

mkdir -p "$HOME/minecraft"
mkdir -p "$PREFIX/tmp"

PLAYIT_PATH="$HOME/playit"

if [ ! -f "$PLAYIT_PATH" ]; then
    wget -O "$PLAYIT_PATH" \
        https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-aarch64
fi

chmod +x "$PLAYIT_PATH"

echo ""
echo "=========================================="
echo "       ENVIRONMENT SETUP COMPLETE         "
echo "=========================================="
echo ""
echo "Installed:"
echo "  ✓ Java 21"
echo "  ✓ Git"
echo "  ✓ Curl"
echo "  ✓ Wget"
echo "  ✓ Playit ARM64"
echo ""
echo "Created:"
echo "  ✓ ~/minecraft"
echo "  ✓ \$PREFIX/tmp"
echo ""
echo "Paper and Minecraft server files were NOT downloaded."
echo "Your start-server script will handle those."
echo ""
echo "Java version:"
java -version

echo ""
echo "Playit version:"
"$PLAYIT_PATH" --version

echo ""
echo "Ready for start-server.sh!"
```
