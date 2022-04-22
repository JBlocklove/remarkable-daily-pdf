#!/bin/sh

# Takes in input (yes or no) defaults to yes, but can default to no with a parameter
function getInputBoolean() {
	if [[ $2 == "no" ]]; then
        read -p "${1} (Y/n) " in;
	else
        read -p "${1} (y/N) " in;
	fi

    if [ "$in" == "y" ]; then
            echo 1;
    elif [ "$in" == "n" ]; then
            echo 0;
    else
		if [[ $2 == "no" ]]; then
			echo 0;
		else
			echo 1;
		fi
    fi
}


wget -qO- https://github.com/JBlocklove/remarkable-daily-pdf/archive/main.zip | unzip -
mv remarkable-daily-pdf-main remarkable-daily-pdf
cd remarkable-daily-pdf

auto=getInputBoolean "Do you want this to run automatically every day?" "no"
if [[ $auto == y ]]; then
	echo "For the following: please not that you can insert shell commands into the strings by using backticks. This is useful for getting a given date that updates dynamically."
	url=`read -p "What URL would you like to pull from every day? "`
	name=`read -p "What name would you like to give the downloaded documents? "`
	dir=`read -p "What directory would you like it to be in? Leave blank if you want it to save at the top level. "`
	cookies=`read -p "If this needs a cookie file, what is the file's location? Leave blank if it is not needed. "`

	options="-u \"$url\" -n \"$name\""
	if [[ $dir ]]; then
		options+="-d \"$dir\""
	fi
	if [[ $cookies ]]; then
		options+="-c \"$cookies\""
	fi

	sed -i -e "s/OPTIONS/$options/" crossword.service
	cp -v crossword.service crossword.timer /etc/systemd/system/
	systemctl enable crossword.timer
fi
