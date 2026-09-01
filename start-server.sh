```bash
#!/data/data/com.termux/files/usr/bin/bash
set -e

# ==========================================
# KORYUU MINECRAFT SERVER STARTUP
# ==========================================

GITHUB_USER="samirkoryuu"
REPO_NAME="mc-world-backup"

MINECRAFT_DIR="$HOME/minecraft"
PLAYIT_PATH="$HOME/playit"

# Put your Playit secret here
PLAYIT_SECRET="dac7bd3a003c58358bc746a0fc0b950fb11e35de3944a43f07c030c96029806a"

# Your Paper JAR download
PAPER_URL="https://github.com/samirkoryuu/mc-world-backup/releases/download/JAR/paper.jar"

echo "=========================================="
echo "     KORYUU MINECRAFT SERVER STARTUP     "
echo "=========================================="
echo ""

# ------------------------------------------
# 1. Get the latest server files
# ------------------------------------------

echo "[1/4] Getting latest server files..."

if [ -d "$MINECRAFT_DIR/.git" ]; then
    cd "$MINECRAFT_DIR"
    git pull origin main
else
    rm -rf "$MINECRAFT_DIR"

    git clone \
        "https://github.com/$GITHUB_USER/$REPO_NAME.git" \
        "$MINECRAFT_DIR"

    cd "$MINECRAFT_DIR"
fi

echo "✓ Server files ready."
echo ""

# ------------------------------------------
# 2. Download Paper
# ------------------------------------------

echo "[2/4] Checking Paper..."

if [ ! -f "$MINECRAFT_DIR/paper.jar" ]; then
    echo "Paper.jar not found."
    echo "Downloading Paper..."

    wget -O "$MINECRAFT_DIR/paper.jar" "$PAPER_URL"

    echo "✓ Paper downloaded."
else
    echo "✓ Paper.jar already exists."
fi

echo ""

# ------------------------------------------
# 3. Start Playit
# ------------------------------------------

echo "[3/4] Starting Playit..."

if [ ! -x "$PLAYIT_PATH" ]; then
    echo "ERROR: Playit was not found at:"
    echo "$PLAYIT_PATH"
    echo ""
    echo "Run setup.sh first."
    exit 1
fi

"$PLAYIT_PATH" \
    --socket-path "$PREFIX/tmp/playit.sock" \
    --secret "$PLAYIT_SECRET" &

PLAYIT_PID=$!

echo "✓ Playit started."
echo ""

# ------------------------------------------
# 4. Start Minecraft
# ------------------------------------------

echo "[4/4] Starting Minecraft server..."
echo ""

cd "$MINECRAFT_DIR"

java -Xms4G -Xmx4G -jar paper.jar --nogui

# ------------------------------------------
# Server stopped
# ------------------------------------------

echo ""
echo "Minecraft server stopped."

kill "$PLAYIT_PID" 2>/dev/null || true

echo "Playit stopped."
echo ""
echo "=========================================="
echo "          SERVER SHUTDOWN COMPLETE        "
echo "=========================================="
```
