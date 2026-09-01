#!/data/data/com.termux/files/usr/bin/bash

GITHUB_USER="samirkoryuu"
REPO_NAME="mc-world-backup"

echo "=== INITIALIZING KORYUU SLAVE ENVIRONMENT ==="

# Install dependencies
pkg update -y && pkg upgrade -y
pkg install openjdk-17 git curl -y
termux-setup-storage

# Clone repo & set up Playit
cd ~
rm -rf minecraft
git clone "https://github.com/$GITHUB_USER/$REPO_NAME.git" minecraft
cd minecraft

curl -SsL -o playit https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-aarch64
chmod +x playit

# Build the 1-tap run script inside Termux
cat << 'EOF' > run.sh
#!/data/data/com.termux/files/usr/bin/bash

echo "=== KORYUU SLAVE: STARTING SERVER ==="
git pull origin main

# Background auto-commit loop
(
  while true; do
    sleep 30
    git add world/ world_nether/ world_the_end/
    git commit -m "Auto-Save: $(date)"
    git push origin main
  done
) &
SYNC_PID=$!

./playit > /dev/null 2>&1 &
PLAYIT_PID=$!

java -Xms4G -Xmx4G -jar paper.jar nogui

kill $SYNC_PID
kill $PLAYIT_PID
git add .
git commit -m "Final Shutdown Sync"
git push origin main
EOF

chmod +x run.sh
echo "=== KORYUU SETUP COMPLETE! ==="
