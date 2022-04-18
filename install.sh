#!/bin/sh

wget -qO- https://github.com/JBlocklove/remarkable-daily-pdf/archive/main.zip -O /home/root/remarkable-daily-pdf | unzip -

read -e -p "Do you want this to run automatically every day? [y/N] " auto
if [[ $auto == y ]]; then
	cp crossword.service crossword.timer /etc/systemd/system/
	systemctl enable crossword.timer
fi
