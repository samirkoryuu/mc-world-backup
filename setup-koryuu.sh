#!/data/data/com.termux/files/usr/bin/bash

GITHUB_USER="samirkoryuu"
REPO_NAME="mc-world-backup"

echo "=== INITIALIZING KORYUU SLAVE ENVIRONMENT ==="

# 1. Update packages & install dependencies
pkg update -y && pkg upgrade -y
pkg install openjdk-17 git curl -y

# 2. Grant storage permissions
termux-setup-storage

# 3. Clone repository
cd ~
rm -rf minecraft
git clone "https://github.com/$GITHUB_USER/$REPO_NAME.git" minecraft
cd minecraft

# 4. Install Playit.gg binary
curl -SsL -o playit https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-aarch64
chmod +x playit

# 5. Build the auto-syncing engine script
cat << 'EOF' > run.sh
#!/data/data/com.termux/files/usr/bin/bash

echo "=== KORYUU SLAVE: STARTING HOSTING ENGINE ==="

# Step A: Download latest world files from GitHub
echo "[1/3] Fetching latest commit from GitHub..."
git pull origin main

# Step B: Start background auto-save loop (Syncs to GitHub every 30 seconds)
(
  while true; do
    sleep 30
    git add world/ world_nether/ world_the_end/
    git commit -m "Koryuu Slave Auto-Save: $(date)"
    git push origin main
  done
) &
SYNC_PID=$!

# Step C: Launch Playit.gg in background
./playit > /dev/null 2>&1 &
PLAYIT_PID=$!

# Step D: Host Minecraft Server
echo "[2/3] PaperMC is Live!"
java -Xms4G -Xmx4G -jar paper.jar nogui

# Step E: Server stop cleanup procedure
echo "[3/3] Shutting down. Performing final GitHub upload..."
kill $SYNC_PID
kill $PLAYIT_PID

git add .
git commit -m "Koryuu Slave Final Shutdown Sync"
git push origin main

echo "=== SERVER OFFLINE & ALL DATA SYNCED ==="
EOF

chmod +x run.sh
echo "=== KORYUU SLAVE SETUP COMPLETE! ==="
