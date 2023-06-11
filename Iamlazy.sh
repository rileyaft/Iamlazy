#!/bin/bash

# This script'll grab the latest release for your own use, then name/place it whatever/wherever you like!
# Made by RileyAFT on Github, because I'm lazy
# Check out my revisions at https://github.com/rileyaft/Iamlazy
# Version 1.0.1

#    _____                _
#    \_   \__ _ _ __ ___ | | __ _ _____   _
#     / /\/ _` | '_ ` _ \| |/ _` |_  / | | |
#  /\/ /_| (_| | | | | | | | (_| |/ /| |_| |
#  \____/ \__,_|_| |_| |_|_|\__,_/___|\__, |
#                                     |___/


#####################################
############# IMPORTANT #############
#####################################
# Make sure this script has executable premissions before running! Either use "chmod +x /directory/to/file.sh" or
# (If using KDE) right click the file, Select Properties > Permissions > Tick "Is Executable"


# User Variables
YOUR_TOKEN="your_token_here" # IMPORTANT: your Github API access key, make one at "https://github.com/settings/tokens"
REPO="repo" # repo to grab from
OWNER="owner" # owner of repo
DIRECTORY="./Downloads" # desired file output (WILL REPLACE EXISTING FILE IF PRESENT)
FILE="extension" # desired application file extension grabbed from releases, ie "7z"
NAME="name" # application will be named this once complete


# Finding downloads
echo "Reading $REPO ..."
RESPONSE=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $YOUR_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$OWNER/$REPO/releases/latest)

browser_download_url=$(echo "$RESPONSE" | grep -o "\"browser_download_url\": \"[^\"]**.$FILE\"" | sed 's/"browser_download_url": "//' | sed 's/"$//')

if [ -z "$browser_download_url" ]; then
  echo "Error: No download URL found for *.$FILE in the latest release of $REPO. Check your configs."
  exit 1
fi

echo "Found downloads: $browser_download_url"
echo "Grabbing first file appended *.$FILE from $REPO"

# Downloading
curl -LO "$browser_download_url"
download_exit_code=$?

# Check if download was successful
if [ $download_exit_code -eq 0 ]; then
  echo "Download successful!"
else
  echo "Download failed with exit code: $download_exit_code"
  exit $download_exit_code
fi

# Final touches
downloaded_file=$(basename "$browser_download_url")
chmod +x "$downloaded_file"
script_loc=$(pwd) # check working directory

# Moving the file to the desired directory
echo "Moving the downloaded file to $DIRECTORY ..."
cd /
mv -f "$script_loc/$downloaded_file" "$DIRECTORY/"

# Check if move was successful
move_exit_code=$?
if [ $move_exit_code -eq 0 ]; then
  echo "File $downloaded_file has been moved to $DIRECTORY"
else
  echo "Error: Failed to move the file $downloaded_file. Check the destination directory and file permissions. Did you input the full destination path?"
  exit $move_exit_code
fi

# Renaming the file to the desired name and extension
new_file="$DIRECTORY/$NAME.$FILE"
echo "Renaming the file to $new_file ..."
mv -f "$DIRECTORY/$downloaded_file" "$new_file"

# Check if rename was successful
rename_exit_code=$?
if [ $rename_exit_code -eq 0 ]; then
  echo "File $downloaded_file has been renamed to $new_file"
else
  echo "Error: Failed to rename the file $downloaded_file to $new_file. Check the file permissions."
  exit $rename_exit_code
fi
echo "File $NAME.$FILE has been successfully downloaded and placed in target directory. Enjoy!"
exit 0
