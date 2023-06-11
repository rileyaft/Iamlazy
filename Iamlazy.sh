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
YOUR_TOKEN="no_token" # Github API key for those who want to do large numbers of requests. Leave blank/untouched unless you need to download 60 files/min
REPO="Iamlazy" # repo to grab from
OWNER="rileyaft" # owner of repo
DIRECTORY="$HOME/Iamlazy" # desired file output (WILL REPLACE EXISTING FILE IF PRESENT)
FILE="tar.gz" # desired application file extension grabbed from releases, ie "7z"
NAME="Iamlazy" # application will be named this once complete


# Check if $DIRECTORY is valid
check_directory() {
  if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY is invalid."
    return 1
  fi
  return 0
}

# Loop to revalidate and prompt for new directory if needed - make the process less painful
while ! check_directory; do
  echo "Would you like to create new directory $DIRECTORY?"
  echo "1. Yes"
  echo "2. Insert new directory"
  echo "3. Cancel"

  read -p "Please enter number 1-3: " choice
  case $choice in
    1)
      echo "Creating new directory $DIRECTORY"
      mkdir -p "$DIRECTORY"
      ;;
    2)
      read -p "Enter new directory: " DIRECTORY
      ;;
    3)
      echo "Exiting script"
      exit 1
      ;;
    *)
      echo "Invalid option. Please try again"
  esac
done
echo "Directory is valid"

# Finding downloads
echo "Reading $REPO ..."
if [ "$YOUR_TOKEN" == "no_token" -o "$YOUR_TOKEN" == "" ]; then
 grablatest=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$OWNER/$REPO/releases/latest)
else
 grablatest=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $YOUR_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$OWNER/$REPO/releases/latest)
fi

browser_download_url=$(echo "$grablatest" | grep -o "\"browser_download_url\": \"[^\"]**.$FILE\"" | sed 's/"browser_download_url": "//' | sed 's/"$//')

if [ -z "$browser_download_url" ]; then
  echo "Error: No download URL found for any *.$FILE file in the latest release of $REPO. Check your configs."
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

if [ "$DIRECTORY/$downloaded_file" != "$new_file" ]; then
  echo "Renaming the file to $new_file ..."
  mv -f "$DIRECTORY/$downloaded_file" "$new_file"

  rename_exit_code=$?
  if [ $rename_exit_code -eq 0 ]; then
    echo "File renamed successfully"
  else
    echo "Error: Failed to rename the file $downloaded_file to $new_file. Check the file permissions."
    exit $rename_exit_code
  fi
else
  echo "Skipping file renaming as the source and destination paths are the same"
fi


echo "File $NAME.$FILE has been successfully downloaded and placed in target directory. Enjoy!"
exit 0
