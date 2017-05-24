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
2. bash runOnSaveCompiled.sh . test.c gcc a.out

Rust:
1. cd into directory
2. bash runOnSaveCompiled.sh . rust1.rs rustc rust1

Elixir:
1. cd into directory
2. bash runOnSaveCompiled.sh . untitled.ex elixirc M.main 'elixir -e'
	change M.main to Module name and main function as needed

# add quotes to filenames with spaces

Instructions for running scripts are also in comments at beginning of scripts.

Scripts can also be run from anywhere, so do not have to cd into directory, just make sure paths, whether absolute or relative, are correct.
