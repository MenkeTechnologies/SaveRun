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

path=$DIR_WATCHING

CONVERTPATH="$(pwd $path)/$(basename $path)"

if [[ ! -d $CONVERTPATH ]]; then
	echo "Path doesn't exist."
	exit 1
fi


if [[ ! -f $2 ]]; then
	echo "File doesn't exist."
	exit 1
fi

which "$command"
if [[ $? = 0]]; then
	echo "Command to run doesn't exist."
	exit 1
fi

echo -e "Watching for changes of file \e[1m'$2'\e[0m in \e[1m'$CONVERTPATH'\e[0m"
echo -e "Executing with \e[1m'`which $3`'\e[0m"

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
