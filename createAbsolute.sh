createAbsolutePathFromFile(){
	local relativePath="$1"
	if [[ ${relativePath:0:1} != '/' ]]; then
	#relative path
			CONVERTPATH="$(pwd $DIR_WATCHING)/$(basename $DIR_WATCHING)"
	else
		#absolute path
		CONVERTPATH="$DIR_WATCHING"
	fi

	ABSOLUTE_PATH=$(cd ${CONVERTPATH} && pwd)



}


createAbsolutePathFromFile $1