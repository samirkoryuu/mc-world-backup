#!/data/data/com.termux/files/usr/bin/bash

pkg update -y && apt upgrade -y -o Dpkg::Options::="--force-confnew"

pkg install -y openjdk-21 git curl wget

termux-setup-storage || true

mkdir -p "$HOME/minecraft" && mkdir -p "$PREFIX/tmp"

wget -O ~/playit https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-aarch64 && chmod +x ~/playit
