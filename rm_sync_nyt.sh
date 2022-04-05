#!/bin/sh

crossword_uuid=`cat /proc/sys/kernel/random/uuid`
xochitl_loc="$HOME/.local/share/remarkable/xochitl"
month=`date +%b%Y`
today=`date +%b%d%y`

download_crossword() {
	#downloads today's nyt crossword
	crossword_url="http://www.nytimes.com/svc/crosswords/v2/puzzle/print/$today.pdf"
	nyt_cookies=`cat nyt-cookies.txt`

	wget $crossword_url \
		--header="Referer: https://www.nytimes.com/crosswords/archive/daily" \
		--header="Cookie: $nyt_cookies" \
		-O "$xochitl_loc/$crossword_uuid.pdf"

	if [[ -z $month_dir_uuid ]]; then
		create_dir_metadata "$crossword_dir_uuid" "$month"
		month_dir_uuid=$dir_uuid
		create_dir_content "$month_dir_uuid"
	fi

	create_doc_metadata $crossword_uuid $month_dir_uuid $today
	create_doc_content $crossword_uuid
}

create_dir_metadata() {
	#creates metadata for new directory under $1 with name $2
	dir_uuid=`cat /proc/sys/kernel/random/uuid`
	cp dir_metadata.txt $xochitl_loc/$dir_uuid.metadata
	sed -i -e "s/PARENT_NAME/$1/" -e "s/DIR_NAME/$2/" $xochitl_loc/$dir_uuid.metadata
}

create_dir_content() {
	#creates for new directory $1
	echo "{}" > $xochitl_loc/$1.content
}

create_doc_metadata() {
	#creates metadata and pagedata files for pdf $1 under parent $2
	mod_time=`date +%s`
	cp doc_metadata.txt $xochitl_loc/$1.metadata
	sed -i -e "s/PARENT_NAME/$2/" -e "s/DOC_NAME/$3/" -e "s/MOD_TIME/$mod_time/" $xochitl_loc/$1.metadata
}

create_doc_content() {
	#creates content files for pdf $1
	page_uuid=`cat /proc/sys/kernel/random/uuid`a
	size_in_bytes=`stat -c %s $xochitl_loc/$1.pdf`
	cp doc_content.txt $xochitl_loc/$1.content
	sed -i -e "s/PAGE_UUID/$page_uuid/" -e "s/SIZE_IN_BYTES/$size_in_bytes/" $xochitl_loc/$1.content
}

find_uuids() {
	#finds uuid for today's crossword if it exists, the crossword directory and this month's directory under that if they exist
	for filename in $xochitl_loc/*.metadata ; do
		doc_name=`sed -e 's/ //g' -e 's/\"//g' $filename | awk -F '[:,]' '{if ($1 == "visibleName") print $2;}'`
		doc_type=`sed -e 's/ //g' -e 's/\"//g' $filename | awk -F '[:,]' '{if ($1 == "type") print $2;}'`
		if [[ $doc_name == "Crosswords" && $doc_type == "CollectionType" ]]; then
			crossword_dir_uuid=`basename $filename .metadata`
		elif [[ $doc_name == $month && $doc_type == "CollectionType" ]]; then
			month_dir_uuid=`basename $filename .metadata`
		elif [[ $doc_name == $today && $doc_type == "DocumentType" ]]; then #script is done if we find this
			exit 1
		fi
	done
}

find_uuids
download_crossword

systemctl restart xochitl.service
