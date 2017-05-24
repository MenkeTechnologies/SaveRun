#!/usr/bin/env bash
#created by JAKOBMENKE --> Sat Jan 14 18:12:20 EST 2017 

#example usage = cd into directory and run bash runOnSaveCompiled.sh . rust1.rs rustc rust1
#example usage for elixir 
# cd into directory and run bash $SCRIPTS/runOnSaveCompiled.sh . untitled.ex elixirc M.main 'elixir -e'
# todo compile *.c etc

clearScreen=false
delim=""

# set -x

trap 'echo;echo Bye `whoami`' INT

usage(){
#here doc for printing multiline
	cat <<\Endofmessage
usage:
	script $1=dir_to_watch $2=file_to_watch $3=command_to_run $4=outputFileName $5=optional execution command
	-h help
	-c clear screen
	-d "delim" use custom delimiter
	-c and -d may not be used together.
Endofmessage
	printf "\E[0m"
	exit 1
}

createAbsolutePathFromFile(){
	local relativePath="$1"


	if [[ ${relativePath:0:1} != '/' && ${relativePath:0:1} != '~' ]]; then
	#relative path
		CONVERTPATH="$(pwd)/$relativePath"
		
		ABSOLUTE_PATH=$(cd ${CONVERTPATH%/*} && pwd)/`basename $relativePath`
	elif [[ ${relativePath:0:1} == '~' ]]; then

		ABSOLUTE_PATH=$(cd ${CONVERTPATH%/*} && pwd)/`basename $relativePath`
	else
		#absolute path
		ABSOLUTE_PATH="$1"
	fi

		echo $ABSOLUTE_PATH

}

createAbsolutePathFromDirectory(){
	local relativePath="$1"


	absPath=$(cd $relativePath && pwd)

	echo "$absPath"

}

if [[ $# < 4 ]]; then
	usage >&2
	
fi

optstring=hcd:
while getopts $optstring opt
do
	case $opt in
	  	h) usage >&2; hflag=true; break;;
		d) delim="$OPTARG"; dflag=true;;
	  	c) clearScreen=true; cflag=true;;
	    *) usage >&2;;
	esac
done

if [[ -z "$delim" ]]; then
	delim="-"
fi

if [[ "$dflag" = true ]]; then
	if [[ "$cflag" = true  ]]; then
		usage >&2
	fi
fi

shift $((OPTIND-1))

DIR_WATCHING="$1"
compilingCommand="$2"
outputFileName="$3"

shift 3;

files_array="$@"

file_to_watch="${files_array[0]}"

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
set $compilingCommand
which "$1" >/dev/null

if [[ $? != 0 ]]; then
	echo "Command to run doesn't exist."
	exit 1
fi

#confirmation output
echo -e "Watching for changes in file \e[1m'`basename $absoluteFilePath`'\e[0m in \e[1m'$ABSOLUTE_PATH'\e[0m"
echo -e "Compiling with \e[1m'`which $1`'\e[0m"
echo -en "Executing file \e[1m'$outputFileName'\e[0m ";

if [[ ! -z $executingCommand ]]; then
	echo -e "with \e[1m'`which $executingCommand`'\e[0m"
else
	echo -e "as \e[1m'./$outputFileName'\e[0m in \e[1m`pwd`\e[0m"
fi

echo -e "Ctrl-C to terminate..."

while read -d "" event; do
	
	fileName=`basename $event`
	watchingFile=`basename $absoluteFilePath`

	#ignored the intermediate files that are changing

	for i in ${files_array[@]}; do
		if [[ $fileName == $watchingFile ]]; then
			changeOccured=true
		fi

	done

	if [[ ! -z $changeOccured ]]; then
		
		if [[ $clearScreen = true ]]; then
		    	clear
		else
				:
		fi

		#grab error output
		#the compiled output file is created in the pwd

		

		exit

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
