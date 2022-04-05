#!/bin/sh

month=`date +%b%Y`
today=`date +%b%d%y`
xochitl_loc="$HOME/.local/share/remarkable/xochitl"

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
			crossword_uuid=`basename $filename .metadata`
		fi
	done
}

find_uuids
echo $crossword_dir_uuid
echo $month_dir_uuid
echo $crossword_uuid
