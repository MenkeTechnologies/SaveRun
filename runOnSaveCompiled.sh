#!/usr/bin/env bash
#created by JAKOBMENKE --> Sat Jan 14 18:12:20 EST 2017 

#example usage = cd into directory
# bash runOnSaveCompiled.sh . rust1.rs rustc rust1
#example usage for elixir 
# cd into directory
# bash runOnSaveCompiled.sh -m  'elixir -e' . M.main elixirc untitled.ex 

clearScreen=false
delim=""



trap 'echo;echo Bye `whoami`' INT

usage(){
#here doc for printing multiline
	cat <<\Endofmessage
usage:
	script $1=dir_to_watch $2=outputFileName $3=compilingCommand $4=filesToCompileAndWatch
	-h help
	-m optional execution command
	-c clear screen
	-d "delim" use custom delimiter.  Default is "-".
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

if (( $# < 4 )); then
	usage >&2
	
fi

optstring=hcd:m:
while getopts $optstring opt
do
	case $opt in
	  	h) usage >&2; hflag=true; break;;
		d) delim="$OPTARG"; dflag=true;;
	  	c) clearScreen=true; cflag=true;;
		m) executingCommand="$OPTARG"; mflag=true;;
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
outputFileName="$2"
compilingCommand="$3"

shift 3;
declare -a files_ary
for i in "$@"; do
	files_ary+=( $(createAbsolutePathFromFile "$i") )
done


absoluteFilePath="${files_ary[0]}"
absoluteWatchingDirectory="$(createAbsolutePathFromDirectory $DIR_WATCHING)"

#sanity checks
if [[ ! -f "$absoluteFilePath" ]]; then
	echo "File doesn't exist." >&2
	exit 1
fi

if [[ ! -d $absoluteWatchingDirectory ]]; then
	echo "Path doesn't exist." >&2
	exit 1
fi

set $compilingCommand
which "$1" >/dev/null

if [[ $? != 0 ]]; then
	echo "Command to run doesn't exist." >&2
	exit 1
fi

#confirmation output
echo -e "Watching for changes in file \e[1m'`basename $absoluteFilePath`'\e[0m in \e[1m'$absoluteWatchingDirectory'\e[0m"
if (( ${#files_ary[@]} > 1 )); then
	echo -n "Also watching for changes in "
		for i in ${files_ary[@]}; do
			if [[ "$i" != "$absoluteFilePath" ]]; then
				echo -en "\e[1m`basename $i`\e[0m, "
			fi
		done
	printf "\n"
fi
echo -e "Compiling with \e[1m'`which $compilingCommand`'\e[0m and executing file \e[1m'$outputFileName'\e[0m";



if [[ ! -z $executingCommand ]]; then
	set $executingCommand
	exe="$1"
	shift
	echo -e "with \e[1m'`which $exe` $@'\e[0m"
else
	echo -e "as \e[1m'./$outputFileName'\e[0m in \e[1m`pwd`\e[0m"
fi

echo -e "Ctrl-C to terminate..."

while read -d "" event; do
	
	fileName="$event"
	watchingFile="$absoluteFilePath"
	go=false

	string_of_files=""

	for i in ${files_ary[@]}; do
		string_of_files="$string_of_files $i"
		if [[ "$i" == "$fileName" ]]; then
			go=true
		fi
	done

	#ignored the intermediate files that are changing

	if [[ "$watchingFile" == "$fileName" ]]; then
		go=true
	fi

	if [[ "$go" == true ]]; then
		
		if [[ $clearScreen = true ]]; then
		    	clear
		else
				:
		fi

		#grab error output
		#the compiled output file is created in the pwd


		output="$($compilingCommand $string_of_files 2>&1)"


		if [[ $? = 0 ]]; then
		
		    #execute compiled file with standard execution and then delete it
		    if [[ -z "$executingCommand" ]]; then
		    	./$outputFileName && rm $outputFileName
		    else
		    	#using custom command to execute file

		    	eval "$executingCommand $outputFileName"
				if [[ -f "$outputFileName" ]];then
					#get rid of old binary if its a file
					rm "$outputFileName"


				fi

				if [[ "$executingCommand" == "java" ]]; then
						rm *.class
				fi

		    fi 

		else
		#we have and error in compilation

		echo "$output"
		fi

		if [[ $clearScreen = true ]]; then
		    	:
		else
			printf "\e[1m"
			date
			for i in $(seq `tput cols`); do
				echo -ne "$delim"
			done
			printf "\e[0m"
		fi
			
	else
		:
	fi

	
#ignore changes in hidden dirs such as .git
done < <(fswatch -r -0 -E "$absoluteWatchingDirectory" -e "/\.." )
