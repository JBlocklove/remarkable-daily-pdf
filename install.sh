#!/bin/sh

wget -qO- https://github.com/JBlocklove/remarkable-daily-pdf/archive/main.zip | unzip -
mv remarkable-daily-pdf-main remarkable-daily-pdf
cd remarkable-daily-pdf

echo -n "Do you want this to run automatically every day? [y/N] "
read auto
if [[ $auto == y ]]; then
	cp -v crossword.service crossword.timer /etc/systemd/system/
	systemctl enable crossword.timer
fi
