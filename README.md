# SaveRunWatchService

![example run](/out.gif?raw=true) <!-- .element width=100%" height="100%" -->

# dependencies: fswatch and bash

# Installation
```
brew tap menketechnologies/taps
brew install saverun
```

# For interpreted languages such as Perl, Ruby, Python
Ruby:
1. cd into directory
```
save-interpret-run . ruby test.rb *.rb
```
Make:
1. cd into directory
```
save-interpret-run . make *.c
```
Swift
1. cd into directory
```
save-interpret-run . swift test.swift
```
Perl:
1. cd into directory
```
save-interpret-run . perl test.pl
```
Node:
1. cd into directory
```
save-compile-run . node week5.js *.js
```
Go:
1. cd into directory
```
save-compile-run . "go run" test.go
```
Lua:
1. cd into directory
```
save-compile-run . "lua" test.lua
```
Applescript:
1. cd into directory
```
save-interpret-run . osascript untitled.applescript
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
save-compile-run . a.out gcc *.c
```
Rust:
1. cd into directory
```
save-compile-run . rust1 rustc rust1.rs 
```
Elixir:
1. cd into directory
```
save-compile-run -m 'elixir -e' . M.main elixirc *.ex 
```
change M.main to Module name and main function as needed

Java:
1. cd into directory
```
save-compile-run -m java . sample.Main javac *.java 
```
With Fully Qualifed Package Name:
1. cd into directory above packages
```
save-compile-run -m 'java' package_name package_name.Main_Class_Name javac package_name/*.java
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

Scripts can also be run from anywhere (except for make), so do not have to cd into directory, just make sure paths, whether absolute or relative, are correct.


