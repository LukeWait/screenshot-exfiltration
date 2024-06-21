#!/bin/bash

# Directory to save screenshots
screenshots_dir="$HOME/<PATH-TO-SCREENSHOTS-DIRECTORY>"

# Create screenshots directory if it doesn't exist
mkdir -p "$screenshots_dir"

# Get the current date and time
current_datetime=$(date +"%Y%m%d_%H%M%S")

# Download and save file with time stamp
wget -q -O "$screenshots_dir/<NAME-OF-HOST>_$current_datetime.png" <URL-OF-SCREENSHOT-FILE>