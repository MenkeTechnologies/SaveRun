# RunOnSaveWatchService

# dependency: fswatch

brew install fswatch on macOs

instructions for running scripts are in comments at beginning

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

