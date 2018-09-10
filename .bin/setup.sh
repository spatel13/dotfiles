#!/bin/sh

# SETUP dotfiles git
git clone --bare git@github.com:spatel13/dotfiles.git $HOME/.cfg

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@'

mkdir -p .config-backup
config checkout arch
if [ $? = 0 ]; then
    echo "Checked out config.";
else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;

config checkout arch
config config status.showUntrackedFiles no

# INSTALL packer
sudo pacman -S jshon expac

wget https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=packer

mv PKGBUILD\?h\=packer PKGBUILD

makepkg

sudo pacman -U packer-*.pkg.tar.xz

# update & upgrade
packer -Syyu

# INSTALL new apps
packer -S git zsh emacs tmux rxvt-unicode python python-pip compton rofi ranger i3-gaps polybar google-chrome dropbox light acpi powertop xorg xorg-xinit nvidia openssh slock terminus-font noto-font xbindkeys bumblebee primus bbswitch spotify slack-desktop gpmdp networkmanager-openvpn 

# INSTALL oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# INSTALL powerlevel9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# INSTALL powerline
pip install --user powerline-status

wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.fonts/ && mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts
mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
sudo mv PowerlineSymbols.otf /usr/share/fonts/
sudo fc-cache -vf
sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/

# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts

# Give executables permission to files
sudo chmod +x ~/.bin/*

# CONFIGURE powertop
sudo powertop --calibrate
sudo powertop --auto-tune

echo "[Unit]           
Description=Powertop tunings

[Service]
Type=oneshot
ExecStart=/usr/bin/powertop --auto-tune

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/powertop.service

systemctl enable powertop.service

# ENABLE lock before sleep
echo "[Unit]
Description=User suspend actions
Before=sleep.target

[Service]
User=%I
Type=simple
Environment=DISPLAY=:0
ExecStart=/home/spatel13/.config/i3/lock/lock.sh
ExecStartPost=/usr/bin/sleep 1

[Install]
WantedBy=sleep.target" >> /etc/systemd/system/suspend@spatel13.service

systemctl enable suspend@spatel13.service

# SSH key permissions
sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 600 ~/.ssh/id_rsa.pub
sudo chmod 644 ~/.ssh/known_hosts
sudo chmod 755 ~/.ssh
