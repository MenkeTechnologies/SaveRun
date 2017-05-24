#!/usr/bin/env bash
#created by JAKOBMENKE --> Sat Jan 14 18:12:20 EST 2017 

#example usage = 
# bash runOnSaveInterpreted.sh . ruby main.rb *.rb
# bash runOnSaveInterpreted.sh . perl main.pl

clearScreen=false
delim=""

trap 'echo;echo Bye `whoami`' INT

usage(){
#here doc for printing multiline
	cat <<\Endofmessage
usage:
	script $1=dir_to_watch $2=command_to_run $3=main_file [$4=files_to_watch]
	-h help
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

if (( $# < 3 )); then
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
file_to_watch="$3"
command="$2"

absoluteFilePath="$(createAbsolutePathFromFile $file_to_watch)"
absoluteWatchingDirectory="$(createAbsolutePathFromDirectory $DIR_WATCHING)"

#sanity checks
if [[ ! -f "$absoluteFilePath" ]]; then
	echo "Main file doesn't exist." >&2
	exit 1
fi

if [[ ! -d $absoluteWatchingDirectory ]]; then
	echo "Path doesn't exist." >&2
	exit 1
fi

which "$command" >/dev/null
if [[ $? != 0 ]]; then
	echo "Command to run doesn't exist." >&2
	exit 1
fi

shift 3;
declare -a files_ary
for i in "$@"; do
	files_ary+=( $(createAbsolutePathFromFile "$i") )
done

#confirmation output
echo -e "Watching for changes in main file \e[1m'`basename $absoluteFilePath`'\e[0m in \e[1m'$absoluteWatchingDirectory'\e[0m"
if (( ${#files_ary[@]} > 0 )); then
	echo -n "Also watching for changes in "
	for i in ${files_ary[@]}; do
		if [[ "$i" != "$absoluteFilePath" ]]; then
			echo -en "\e[1m`basename $i`\e[0m, "
		fi
	done
	echo

fi
echo -e "Interpreting main file \e[1m'`basename $absoluteFilePath`'\e[0m with \e[1m'`which $command`'\e[0m"

echo -e "Ctrl-C to terminate..."

while read -d "" event; do
	
	fileName="$event"
	watchingFile="$absoluteFilePath"
	go=false

	for i in ${files_ary[@]}; do
		if [[ "$i" == "$fileName" ]]; then
			go=true
		fi
	done

	if [[ "$watchingFile" == "$fileName" ]]; then
		go=true
	fi

	#ignored the intermediate files that are changing
	if [[ "$go" == true ]]; then

		if [[ $clearScreen = true ]]; then
		    	clear
		fi

		#run the command
		eval "$command $absoluteFilePath"

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
		#placeholder
		:
	fi

	
#ignore changes in hidden dirs such as .git
done < <(fswatch -r -0 -E "$absoluteWatchingDirectory" -e "/\.." )
