#!/bin/sh

# Takes in input (yes or no) defaults to yes, but can default to no with a parameter
function get_input_boolean() {

	local __resultvar=$3
	local input

	if [[ $2 == "no" ]]; then
        read -p "${1} (y/N) " input;
	else
        read -p "${1} (Y/n) " input;
	fi

    if [ "$input" == "" ]; then
		if [[ $2 == "no" ]]; then
			input="n";
		else
			input="y";
		fi
    fi

    if [[ "$__resultvar" ]]; then
        eval $__resultvar="'$input'"
    else
        echo "$input"
    fi
}

function make_full_script() {
	local filename="download-pdfs"
	echo "#!/bin/sh" > $filename
	for i do
		echo -n "./rm-sync-pdf " >> $filename
		echo -n $i >> $filename
	done
	echo " -r" >> $filename
	chmod a+x $filename
}

wget -qO- https://github.com/JBlocklove/remarkable-daily-pdf/archive/main.zip | unzip -
mv remarkable-daily-pdf-main remarkable-daily-pdf
cd remarkable-daily-pdf

get_input_boolean "Do you want this to run automatically every day?" "no" auto
if [[ $auto == "y" ]]; then
	echo "For the following: please not that you can insert shell commands into the strings by using backticks. This is useful for getting a given date that updates dynamically."
	read -p "What URL would you like to pull from every day? " url
	read -p "What name would you like to give the downloaded documents? " name
	read -p "What directory would you like it to be in? Leave blank if you want it to save at the top level. " dir
	read -p "If this needs a cookie file, what is the file's location? Leave blank if it is not needed. " cookies

	options="-u \"$url\" -n \"$name\""

	if [[ $dir ]]; then
		options+=" -d \"$dir\""
	fi
	if [[ $cookies ]]; then
		options+=" -c \"$cookies\""
	fi


	make_full_script "$options"
	cp -v download-pdfs.service download-pdfs.timer /etc/systemd/system/
	systemctl enable download-pdfs.timer
fi

get_input_boolean "Do you want a full version of wget? This is necessary for secure sites." "no" wget
if [[ $wget == "y" ]]; then
    wget -q "http://toltec-dev.org/thirdparty/bin/wget-v1.21.1-1" --output-document "`pwd`/gnu-wget"
    chmod 755 "`pwd`/gnu-wget"
fi
