#!/usr/bin/env bash
#created by JAKOBMENKE --> Sat Jan 14 18:12:20 EST 2017 

#example usage = cd into directory and run bash runOnSaveCompiled.sh . rust1.rs rustc rust1
#example usage for elixir 
# cd into directory and run bash $SCRIPTS/runOnSaveCompiled.sh . untitled.ex elixirc M.main 'elixir -e'

clearScreen=false
delim=""

# set -x

trap 'echo;echo Bye `whoami`' INT

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

optstring=hcd:
while getopts $optstring opt
do
	case $opt in
	  	h) usage >&2; break;;
		d) delim="$OPTARG";;
	  	c) clearScreen=true; break;;
	    *) usage >&2;;
	esac
done

if [[ -z "$delim" ]]; then
	delim="-"
fi

shift $((OPTIND-1))

DIR_WATCHING="$1"
file_to_watch="$2"
compilingCommand="$3"
outputFileName="$4"
executingCommand="$5"

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
echo -e "Watching for changes in file \e[1m'`basename $absoluteFilePath`'\e[0m in \e[1m'$ABSOLUTE_PATH'\e[0m"
echo -e "Compiling with \e[1m'`which $compilingCommand`'\e[0m"
echo -en "Executing file \e[1m'$outputFileName'\e[0m ";

if [[ ! -z $5 ]]; then
	echo -e "with \e[1m'`which $executingCommand`'\e[0m"
else
	echo -e "as \e[1m'./$outputFileName'\e[0m in \e[1m`pwd`\e[0m"
fi

echo -e "Ctrl-C to terminate..."

while read -d "" event; do
	
	fileName=`basename $event`
	watchingFile=`basename $absoluteFilePath`

	#ignored the intermediate files that are changing
	if [[ $fileName == $watchingFile ]]; then
		
		if [[ $clearScreen = true ]]; then
		    	clear
		else
				:
		fi

		#grab error output
		#the compiled output file is created in the pwd
		output="$($compilingCommand $absoluteFilePath 2>&1)"
		

		if [[ $? = 0 ]]; then
		
		    #execute compiled file with standard execution and then delete it
		    if [[ -z "$executingCommand" ]]; then
		    	./$outputFileName && rm $outputFileName
		    else
		    	#using custom command to execute file
		    	eval "$executingCommand $outputFileName"
				if [[ -f "$outputFileName" ]];then
					#get rid of old binary
					rm "$outputFileName"
				fi

		    fi 

		else
		#we have and error in compilation

		echo "$output"
		fi

		if [[ $clearScreen = true ]]; then
		    	:
		else
			for i in $(seq `tput cols`); do
				echo -ne "$delim"
			done
			echo
		fi
			
	else
		:
	fi

	
#ignore changes in hidden dirs such as .git
done < <(fswatch -r -0 -E "$DIR_WATCHING" -e "/\.." )
