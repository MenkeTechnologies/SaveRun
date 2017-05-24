#!/usr/bin/env bash
#created by JAKOBMENKE --> Sat Jan 14 18:12:20 EST 2017 

#example usage = bash "$SCRIPTS/watchServiceFSWatchRustCompile.sh" . "untitled.rs"


usage(){
#here doc for printing multiline
	cat <<\Endofmessage
usage:
	script $1=dir_to_watch $2=file_to_watch $3=command_to_run
Endofmessage
	printf "\E[0m"
}

if [[ $# < 3 ]]; then
	usage
	exit
fi

DIR_WATCHING="$1"
command="$3"
while read -d "" event; do
	
	fileName=`basename $event`
	watchingFile=`basename $2`

	#ignored the intermediate files that are changing
	if [[ $fileName == $watchingFile ]]; then
		clear
		eval "$command $fileName"
			
		# echo "match @ $fileName"
	else
		:
		# echo "no match @ $fileName"
	fi

	

done < <(fswatch -r -0 -E "$DIR_WATCHING" -e "/\.." )
