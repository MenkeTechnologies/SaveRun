#!/usr/bin/env bash
#created by JAKOBMENKE --> Sat Jan 14 18:12:20 EST 2017 

#example usage = cd into directory and run bash "$SCRIPTS/runOnSaveCompiled.sh" . "untitled.rs" "rustc"
#example usage for elixir 
# cd into directory and run bash $SCRIPTS/runOnSaveCompiled.sh . untitled.ex elixirc M.main 'elixir -e'
DIR_WATCHING="$1"
file_to_watch="$2"
compilingCommand="$3"
outputFileName="$4"
executingCommand="$5"

usage(){
#here doc for printing multiline
	cat <<\Endofmessage
usage:
	script $1=dir_to_watch $2=file_to_watch $3=command_to_run $4=outputFileName $5=optional execution command
Endofmessage
	printf "\E[0m"
}

if [[ $# < 4 ]]; then
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

which "$compilingCommand" >/dev/null

if [[ $? != 0 ]]; then
	echo "Command to run doesn't exist."
	exit 1
fi

#confirmation output
echo -e "Watching for changes of file \e[1m'`basename $absoluteFilePath`'\e[0m in \e[1m'$ABSOLUTE_PATH'\e[0m"
echo -e "Compiling with \e[1m'`which $compilingCommand`'\e[0m"
echo -en "Executing file \e[1m'$outputFileName'\e[0m ";

if [[ ! -z $5 ]]; then
	echo -e "with \e[1m'`which $executingCommand`'\e[0m"
else
	echo -e "as \e[1m'./$outputFileName'\e[0m"
fi

echo -e "Ctrl-C to terminate..."

while read -d "" event; do
	
	fileName=`basename $event`
	watchingFile=`basename $2`

	#ignored the intermediate files that are changing
	if [[ $fileName == $watchingFile ]]; then
		#grab error output
		output="$($compilingCommand $2 2>&1)"

		if [[ $? = 0 ]]; then
			#clear screen to maintain 
		    clear
		    #execute compiled file and then delete it
		    if [[ -z "$5" ]]; then
		    	./$outputFileName && rm $outputFileName
		    else
		    	
		    	eval "$5 $outputFileName"
			if [[ -f "$outputFileName" ]];then
				rm "$outputFileName"
			fi

		    fi 

		else
			#we have and error in compilation so show the error
		    clear
		    echo "$output"
		fi
			
	else
		:
	fi

	

done < <(fswatch -r -0 -E "$DIR_WATCHING" -e "/\.." )
