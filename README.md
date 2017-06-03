# SaveRunWatchService

![example run](/out.gif?raw=true)

# dependency: fswatch

brew install fswatch on macOs


# For interpreted languages such as Perl, Ruby, Python
Ruby:
1. cd into directory
```
bash runOnSaveInterpreted.sh . ruby test.rb *.rb
```
Make:
1. cd into directory
```
bash runOnSaveInterpreted.sh . make *.c
```
# bash runOnSaveInterpreted.sh . perl main.pl





Perl:
1. cd into directory
```
bash runOnSaveInterpreted.sh . perl test.pl
```
Node:
1. cd into directory
```
bash runOnSaveCompiled.sh . node week5.js *.js
```
Go:
1. cd into directory
```
bash runOnSaveCompiled.sh . "go run" test.go
```
Lua:
1. cd into directory
```
bash runOnSaveCompiled.sh . "lua" test.lua
```
usage:
	script $1=dir_to_watch $2=command_to_run $3=main_file [$4=files_to_watch]

	-h help
	-c clear screen
	-d "delim" use custom delimiter.  Default is "-".
	-c and -d may not be used together.

	4th parameter is optional

# For compiled languages such as C, Rust and Elixir
C:
1. cd into directory
```
bash runOnSaveCompiled.sh . a.out gcc *.c
```
Rust:
1. cd into directory
```
bash runOnSaveCompiled.sh . rust1 rustc rust1.rs 
```
Elixir:
1. cd into directory
```
bash runOnSaveCompiled.sh -m 'elixir -e' . M.main elixirc *.ex 
```
change M.main to Module name and main function as needed

Java:
1. cd into directory
```
bash runOnSaveCompiled.sh -m java . sample.Main javac *.java 
```
With Fully Qualifed Package Name:
1. cd into directory above packages
```
bash runOnSaveCompiled.sh -m 'java' package_name package_name.Main_Class_Name javac package_name/*.java
```

usage:
	script $1=dir_to_watch $2=outputFileName $3=compilingCommand $4=filesToCompileAndWatch

	-h help
	-m optional execution command
	-c clear screen
	-d "delim" use custom delimiter.  Default is "-".
	-c and -d may not be used together.


# add double quotes to filenames with spaces

Instructions for running scripts are also in comments at beginning of scripts.

Scripts can also be run from anywhere, so do not have to cd into directory, just make sure paths, whether absolute or relative, are correct.


