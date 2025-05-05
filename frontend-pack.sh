#!/bin/bash

# Ranglar
GREEN='\033[0;32m'
NC='\033[0m' # Rangni tiklash

# Banner
clear
echo -e "${GREEN}"
cat << "EOF"
 ░▒▓██████▓▒░ ░▒▓██████▓▒░       ░▒▓█▓▒░░▒▓██████▓▒░             ░▒▓███████▓▒░░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░      ░▒▓██████▓▒░░▒▓███████▓▒░░▒▓████████▓▒░▒▓███████▓▒░  
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░            ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░            ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       ░▒▓█▓▒▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒▒▓███▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░            ░▒▓█▓▒░░▒▓█▓▒░▒▓██████▓▒░  ░▒▓█▓▒▒▓█▓▒░░▒▓██████▓▒░ ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓██████▓▒░ ░▒▓███████▓▒░  
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░            ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░            ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ 
 ░▒▓██████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░             ░▒▓███████▓▒░░▒▓████████▓▒░  ░▒▓██▓▒░  ░▒▓████████▓▒░▒▓████████▓▒░▒▓██████▓▒░░▒▓█▓▒░      ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░ 
EOF
echo -e "${NC}"

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

# Paket mavjudligini tekshiruvchi funksiya
is_installed() {
  dpkg -s "$1" &> /dev/null
}

# .desktop fayl bilan tekshiruvchi funksiya (Telegram uchun)
desktop_exists() {
  [[ -f "/usr/share/applications/$1" ]]
}

echo -e "${GREEN}\n🔧 O‘rnatish jarayoni boshlanmoqda...\n${NC}"

# 1. Yangilanish
echo -e "${GREEN}[1/7] Yangilanishlar tekshirilmoqda...${NC}"
sudo apt update && sudo apt upgrade -y
progress_bar 2

# 2. Google Chrome
if is_installed google-chrome-stable; then
  echo -e "${GREEN}[2/7] Google Chrome allaqachon o‘rnatilgan.${NC}"
else
  echo -e "${GREEN}[2/7] Google Chrome o‘rnatilmoqda...${NC}"
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install ./google-chrome-stable_current_amd64.deb -y
  rm google-chrome-stable_current_amd64.deb
  progress_bar 2
fi

# 3. VS Code
if is_installed code; then
  echo -e "${GREEN}[3/7] Visual Studio Code allaqachon o‘rnatilgan.${NC}"
else
  echo -e "${GREEN}[3/7] Visual Studio Code o‘rnatilmoqda...${NC}"
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt update
  sudo apt install code -y
  rm packages.microsoft.gpg
  progress_bar 2
fi

# 4. Node.js
if is_installed nodejs; then
  echo -e "${GREEN}[4/7] Node.js allaqachon o‘rnatilgan.${NC}"
else
  echo -e "${GREEN}[4/7] Node.js (LTS) o‘rnatilmoqda...${NC}"
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt install -y nodejs
  progress_bar 2
fi

# 5. Plank
if is_installed plank; then
  echo -e "${GREEN}[5/7] Plank allaqachon o‘rnatilgan.${NC}"
else
  echo -e "${GREEN}[5/7] Plank (dock) o‘rnatilmoqda...${NC}"
  sudo apt install plank -y
  progress_bar 2
fi

# 6. Telegram Desktop
if desktop_exists "telegram.desktop"; then
  echo -e "${GREEN}[6/7] Telegram Desktop allaqachon o‘rnatilgan.${NC}"
else
  echo -e "${GREEN}[6/7] Telegram Desktop o‘rnatilmoqda...${NC}"
  wget -O telegram.tar.xz https://telegram.org/dl/desktop/linux
  sudo mkdir -p /opt/telegram
  sudo tar -xf telegram.tar.xz -C /opt/telegram
  rm telegram.tar.xz
  sudo ln -sf /opt/telegram/Telegram/Telegram /usr/bin/telegram

  cat <<EOF | sudo tee /usr/share/applications/telegram.desktop > /dev/null
[Desktop Entry]
Name=Telegram Desktop
Comment=Telegram messaging app
Exec=/opt/telegram/Telegram/Telegram
Icon=/opt/telegram/Telegram/telegram.png
Terminal=false
Type=Application
Categories=Network;InstantMessaging;
EOF
  progress_bar 2
fi

# Tamom
echo -e "${GREEN}\n🎉 Barcha kerakli dasturlar o‘rnatildi yoki allaqachon mavjud edi!"
echo "🚀 Endi sizning Linux Mint tizimingiz tayyor!${NC}"
