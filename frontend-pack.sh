#!/bin/bash

set -euo pipefail
trap 'echo -e "\n❌ Xatolik yuz berdi. Skript to‘xtadi." >&2' ERR

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

progress_bar() {
  local duration=$1
  local i=0
  while [ $i -le 100 ]; do
    n=$((i / 2))
    bar=$(printf "%-${n}s" | tr ' ' '=')
    printf "\r${GREEN}[%-50s] %d%%${NC}" "$bar" "$i"
    sleep $(bc <<< "$duration / 100")
    ((i+=4))
  done
  echo ""
}

is_installed() {
  dpkg -s "$1" &> /dev/null
}

desktop_exists() {
  [[ -f "/usr/share/applications/$1" ]]
}

print_step() {
  local step_num=$1
  local total_steps=6
  local msg=$2
  clear
  echo -e "${GREEN}[${step_num}/${total_steps}] ${msg}${NC}"
}

install_package() {
  local step_num=$1
  local name=$2
  local command=$3

  print_step "$step_num" "$name o‘rnatilmoqda..."
  # O‘rnatish chiqishini vaqtincha faylga yo‘naltiramiz
  if ! eval "$command" &> /tmp/install_log; then
    echo -e "${RED}❌ $name o‘rnatishda xatolik yuz berdi! Batafsil: /tmp/install_log${NC}"
    exit 1
  fi
  progress_bar 2
}

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

# --- Amaliyotlarni tartib bilan bajarish ---

# 1. Node.js
if is_installed nodejs; then
  print_step 1 "Node.js allaqachon o‘rnatilgan."
  progress_bar 2
else
  install_package 1 "Node.js" "
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&
    sudo apt install -y nodejs"
fi

# 2. Telegram Desktop
if desktop_exists "telegram.desktop"; then
  print_step 2 "Telegram Desktop allaqachon o‘rnatilgan."
  progress_bar 2
else
  install_package 2 "Telegram Desktop" "
    curl -fsSLo telegram.tar.xz https://telegram.org/dl/desktop/linux &&
    sudo mkdir -p /opt/telegram &&
    sudo tar -xf telegram.tar.xz -C /opt/telegram &&
    rm telegram.tar.xz &&
    sudo ln -sf /opt/telegram/Telegram/Telegram /usr/bin/telegram &&
    cat <<EOF2 | sudo tee /usr/share/applications/telegram.desktop > /dev/null
[Desktop Entry]
Name=Telegram Desktop
Comment=Telegram messaging app
Exec=/opt/telegram/Telegram/Telegram
Icon=/opt/telegram/Telegram/telegram.png
Terminal=false
Type=Application
Categories=Network;InstantMessaging;
EOF2"
fi

# 3. VS Code
if is_installed code; then
  print_step 3 "Visual Studio Code allaqachon o‘rnatilgan."
  progress_bar 2
else
  install_package 3 "VS Code" "
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null &&
    echo 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main' | sudo tee /etc/apt/sources.list.d/vscode.list &&
    sudo apt update &&
    sudo apt install code -y"
fi

# 4. Google Chrome
if is_installed google-chrome-stable; then
  print_step 4 "Google Chrome allaqachon o‘rnatilgan."
  progress_bar 2
else
  install_package 4 "Google Chrome" "
    curl -fsSLo chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
    sudo apt install ./chrome.deb -y &&
    rm chrome.deb"
fi

# 5. Plank
if is_installed plank; then
  print_step 5 "Plank allaqachon o‘rnatilgan."
  progress_bar 2
else
  install_package 5 "Plank" "sudo apt install plank -y"
fi

# 6. Yangilanishlar (oxirgi qadam)
print_step 6 "Yangilanishlar tekshirilmoqda..."
sudo apt update && sudo apt upgrade -y
progress_bar 2

# Yakuniy xabar
clear
echo -e "${GREEN}🎉 Barcha kerakli dasturlar o‘rnatildi yoki allaqachon mavjud edi!"
echo -e "🚀 Endi sizning Linux tizimingiz tayyor!${NC}"
