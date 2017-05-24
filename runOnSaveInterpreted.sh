#!/usr/bin/env bash
#created by JAKOBMENKE --> Sat Jan 14 18:12:20 EST 2017 

#example usage = bash "runOnSaveInterpreted.sh" . "test.rb" ruby

clearScreen=false
delim=""


trap 'echo;echo Bye `whoami`' INT

usage(){
#here doc for printing multiline
	cat <<\Endofmessage
usage:
	script $1=dir_to_watch $2=file_to_watch $3=command_to_run
Endofmessage
	printf "\E[0m"
	exit
}

if [[ $# < 3 ]]; then
	usage
	
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
command="$3"


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

		if [[ $clearScreen = true ]]; then
		    	clear
		fi

		#run the command
		eval "$command $absoluteFilePath"

		if [[ $clearScreen = true ]]; then
		    	:
		else
			for i in $(seq `tput cols`); do
				echo -ne "$delim"
			done
			echo
		fi
	else
		#placeholder
		:
	fi

	
#ignore changes in hidden dirs such as .git
done < <(fswatch -r -0 -E "$DIR_WATCHING" -e "/\.." )
