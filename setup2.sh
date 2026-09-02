#!/data/data/com.termux/files/usr/bin/bash

apt update

apt install -y curl gnupg

curl -SL https://playit-cloud.github.io/ppa/key.gpg -o /tmp/playit.gpg

gpg --dearmor -o /etc/apt/trusted.gpg.d/playit.gpg /tmp/playit.gpg

echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data/ /" > /etc/apt/sources.list.d/playit-cloud.list

apt update

DEBIAN_FRONTEND=noninteractive apt-get install -y playit

