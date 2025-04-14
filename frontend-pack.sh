#!/bin/bash

# Ranglar (faqat yashil rang ishlatiladi)
GREEN='\033[0;32m'
NC='\033[0m' # no color

# Progress bar funksiyasi
progress_bar() {
  local duration=$1
  local i=0
  while [ $i -le 100 ]; do
    n=$((i/2))
    bar=$(printf "%-${n}s" | tr ' ' '=')
    printf "\r${GREEN}[%-50s] %d%%${NC}" "$bar" "$i"
    sleep $(bc <<< "$duration / 100")
    ((i+=4))
  done
  echo ""
}

# Sarlavha
echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║         Linux Dasturlarini Avtomatik O‘rnatish        ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${NC}"
sleep 1

# Yangilanishlar
echo -e "${GREEN}[1/6] Yangilanishlar tekshirilmoqda...${NC}"
sudo apt update && sudo apt upgrade -y
progress_bar 2

# Snap
echo -e "${GREEN}[2/6] Snap o‘rnatilmoqda...${NC}"
sudo apt install snapd -y
progress_bar 2

# Google Chrome
echo -e "${GREEN}[3/6] Google Chrome o‘rnatilmoqda...${NC}"
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y
rm google-chrome-stable_current_amd64.deb
progress_bar 2

# VS Code
echo -e "${GREEN}[4/6] VS Code o‘rnatilmoqda...${NC}"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code -y
rm packages.microsoft.gpg
progress_bar 2

# Node.js LTS
echo -e "${GREEN}[5/6] Node.js (LTS) o‘rnatilmoqda...${NC}"
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
progress_bar 2

# Telegram Desktop
echo -e "${GREEN}[6/6] Telegram Desktop o‘rnatilmoqda...${NC}"
sudo snap install telegram-desktop
progress_bar 2

# Tamomlandi
echo -e "${GREEN}"
echo "🎉 Barcha dasturlar muvaffaqiyatli o‘rnatildi!"
echo "🚀 Endi siz zamonaviy frontend/backend ishlariga tayyorsiz."
echo -e "${NC}"
