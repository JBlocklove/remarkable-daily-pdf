#!/bin/sh

INSTALL_DIR="$HOME/.local/share/remarkable-daily-pdf"
GNU_WGET="$INSTALL_DIR/gnu-wget"

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
	local filename="$INSTALL_DIR/download-pdfs"
	echo "#!/bin/sh" > $filename
	for i do
		echo -n "./rm-sync-pdf " >> $filename
		echo -n $i >> $filename
	done
	echo " -r" >> $filename
	chmod a+x $filename
}

function wget_git_recursive() {
	local top_repo="$1"
	local repo_name=$(basename $top_repo)
	local path="$2"
	local branch="${3:-main}"

	$GNU_WGET -qO- "$top_repo/archive/$branch.tar.gz" | tar -xz
	if [[ -d $path ]]; then
		mv $path ${path}_tmp
		mv ${repo_name}-$branch $path
		mv ${path}_tmp/* $path
		rm -rf ${path}_tmp
	else
		mv ${repo_name}-$branch $path
		cd $path
	fi

	if [[ -f .gitmodules ]]; then
		local submodules
		local parsed_lines
		readarray -t submodules <<< "$(awk '/\[submodule/,1' .gitmodules)"
		readarray -t parsed_lines <<< "$(awk '/\[/{prefix=$0; next} $1{print prefix $0}' .gitmodules)"

		for submodule in "${submodules[@]}"; do
			for line in "${parsed_lines[@]}"; do
				if [[ $line =~ $submodule*path ]]; then
					local submodule_path=$(echo $line | awk -F'= ' '{print $2}')
				elif [[ $line =~ $submodule*url ]]; then
					local submodule_url=$(echo $line | awk -F'= ' '{print $2}')
				elif [[ $line =~ $submodule*branch ]]; then
					local submodule_branch=$(echo $line | awk -F'= ' '{print $2}')
				fi
			done
			submodule_url=${submodule_url%.git}
			wget_git_recursive $submodule_url $submodule_path $submodule_branch
		done
	fi

}

mkdir -p "$INSTALL_DIR"

wget -q "http://toltec-dev.org/thirdparty/bin/wget-v1.21.1-1" --output-document "$GNU_WGET"
chmod 755 "$GNU_WGET"

wget_git_recursive "https://github.com/JBlocklove/remarkable-daily-pdf" "$INSTALL_DIR" "dev"

get_input_boolean "Do you want to set up a daily download now?" "no" setup
if [[ $setup == "y" ]]; then
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
fi

get_input_boolean "Do you want this to run automatically every day?" "no" auto
if [[ $auto == "y" ]]; then
	cp -v $INSTALL_DIR/download-pdfs.service $INSTALL_DIR/download-pdfs.timer /etc/systemd/system/
	systemctl enable download-pdfs.timer
fi

get_input_boolean "Do you want to do an initial download now?" "no" init
if [[ $init == "y" ]]; then
	systemctl start download-pdfs.service
fi
