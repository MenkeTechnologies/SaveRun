# RunOnSaveWatchService

# dependency: fswatch

brew install fswatch on macOs


# For interpreted languages such as Perl, Ruby, Python etc.
cd into directory
bash runOnSaveInterpreted.sh . test.rb ruby

# For compiled languages such as C, Rust and Elixir
example usage = cd into directory
bash runOnSaveCompiled.sh . untitled.rs rustc

example usage for elixir = cd into directory
bash runOnSaveCompiled.sh . untitled.ex elixirc M.main 'elixir -e'

change M.main to Module name and main function as needed

# add quotes to filenames with spaces

Instructions for running scripts are also in comments at beginning of scripts.

Scripts can also be run from anywhere, so do not have to cd into directory, just make sure paths, whether absolute or relative, are correct.

