#!/data/data/com.termux/files/usr/bin/bash

pkg update -y && apt upgrade -y -o Dpkg::Options::="--force-confnew"

pkg install -y openjdk-21 git curl wget

termux-setup-storage || true

mkdir -p "$HOME/minecraft" 

pkg install proot-distro -y

proot-distro install ubuntu

proot-distro login ubuntu
