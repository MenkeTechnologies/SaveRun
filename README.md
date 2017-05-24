# RunOnSaveWatchService

# dependency: fswatch

brew install fswatch on macOs


# For interpreted languages such as Perl, Ruby, Python
Ruby:
1. cd into directory
2. bash runOnSaveInterpreted.sh . ruby test.rb *.rb

usage:
	script $1=dir_to_watch $2=command_to_run $3=main_file [$4=files_to_watch]
	-h help
	-c clear screen
	-d "delim" use custom delimiter
	-c and -d may not be used together.

	4th parameter is optional

# For compiled languages such as C, Rust and Elixir
C:
1. cd into directory
2. bash runOnSaveCompiled.sh . a.out gcc main.c *.c

Rust:
1. cd into directory
2. bash runOnSaveCompiled.sh . rust1 rustc rust1.rs 

Elixir:
1. cd into directory
2. bash runOnSaveCompiled.sh -m 'elixir -e' . M.main elixirc untitled.ex 
	change M.main to Module name and main function as needed

Java:
1. cd into directory
2. bash runOnSaveCompiled.sh -m java . sample.Main javac main.java *.java 
	change M.main to Module name and main function as needed

usage:
	script $1=dir_to_watch $2=outputFileName $3=compilingCommand $4=mainfile [$5=otherFilesToWatchAndCompile]
	-h help
	-m optional execution command
	-c clear screen
	-d "delim" use custom delimiter
	-c and -d may not be used together.


# add double quotes to filenames with spaces

Instructions for running scripts are also in comments at beginning of scripts.

Scripts can also be run from anywhere, so do not have to cd into directory, just make sure paths, whether absolute or relative, are correct.
