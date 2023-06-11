# Iamlazy
```
#    _____                _
#    \_   \__ _ _ __ ___ | | __ _ _____   _
#     / /\/ _` | '_ ` _ \| |/ _` |_  / | | |
#  /\/ /_| (_| | | | | | | | (_| |/ /| |_| |
#  \____/ \__,_|_| |_| |_|_|\__,_/___|\__, |
#                                     |___/
```
A short standalone (but soon-to-be-command!) script to download github releases and automatically place/name them wherever/whatever you like! Why? Because I am lazy.

Written in entirely in bash, it should be able to run on any UNIX-Like system, and even on Windows through WSL!

(And yes, you can even use it to download the script itself 🙃)

# Instructions
Make sure to configure the script once it has been downloaded, and only change the User Defined Variables.
Example configs are as follows below!
```bash
YOUR_TOKEN="no_token" # Github API key for those who want to do large numbers of requests. Leave blank/untouched unless you need to download 60 files/min
REPO="Iamlazy" # repo to grab from
OWNER="rileyaft" # owner of repo
DIRECTORY="$HOME/Iamlazy" # desired file output (WILL REPLACE EXISTING FILE IF PRESENT)
FILE="tar.gz" # desired application file extension grabbed from releases, ie "7z"
NAME="Iamlazy" # application will be named this once complete
```
Ensure the directory is listed directly from ```/```, otherwise ```mv``` tends to struggle.

# To-do
> allow automatic decompression of zip/7z/tar.gz/etc files

> make this an actual system package

> further customization

> separate config file

> Qt6 GUI?

> WORLD DOMINATION

> Removal of nessicary API key ✔️
