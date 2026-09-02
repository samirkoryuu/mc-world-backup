#!/data/data/com.termux/files/usr/bin/bash

cd ~/minecraft

git pull origin main

java -Xms2G -Xmx4G -jar paper.jar --nogui
