#!/usr/bin/env bash

# USAGE
# ./install.sh [directory1] [directory2] ...
# If no argument is passed then stow all non-hidden directories

if [ $# -eq 0 ]; then
		stow --no-folding -v -t ~ */
else
		stow --no-folding -v -t ~ $@
fi
