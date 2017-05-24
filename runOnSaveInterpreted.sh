#!/usr/bin/env bash
#created by JAKOBMENKE --> Sat Jan 14 18:12:20 EST 2017 

#example usage = bash "$SCRIPTS/watchServiceFSWatchRustCompile.sh" . "untitled.rs"
DIR_WATCHING="$1"
file_to_watch="$2"
command="$3"

#set -x

trap 'echo;echo Bye `whoami`' INT

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


if [[ ${DIR_WATCHING:0:1} != '/' ]]; then
	#relative path
	CONVERTPATH="$(pwd $DIR_WATCHING)/$(basename $DIR_WATCHING)"
else
	#absolute path
	CONVERTPATH="$DIR_WATCHING"
fi

ABSOLUTE_PATH=$(cd ${CONVERTPATH} && pwd)


absoluteFilePath=$ABSOLUTE_PATH/`basename $file_to_watch`

#sanity checks
if [[ ! -f "$absoluteFilePath" ]]; then
	echo "File doesn't exist."
	exit 1
fi


if [[ ! -d $ABSOLUTE_PATH ]]; then
	echo "Path doesn't exist."
	exit 1
fi

which "$command" >/dev/null
if [[ $? != 0 ]]; then
	echo "Command to run doesn't exist."
	exit 1
fi

#confirmation output
echo -e "Watching for changes in file \e[1m'`basename $absoluteFilePath`'\e[0m in \e[1m'$ABSOLUTE_PATH'\e[0m"
echo -e "Interpreting with \e[1m'`which $command`'\e[0m"


echo -e "Ctrl-C to terminate..."

while read -d "" event; do
	
	fileName=`basename $event`
	watchingFile=`basename $absoluteFilePath`

	#ignored the intermediate files that are changing
	if [[ $fileName == $watchingFile ]]; then
		clear
		eval "$command $absoluteFilePath"
			
	else
		:
	fi

	

done < <(fswatch -r -0 -E "$DIR_WATCHING" -e "/\.." )
