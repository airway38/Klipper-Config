#!/bin/bash

#####################################################################
### Please set the paths accordingly. In case you don't have all  ###
### the listed folders, just keep that line commented out.        ###
#####################################################################

### Path to your config folder you want to backup
config_folder=~/klipper_config

### Path to your Klipper folder, by default that is '~/klipper'
klipper_folder=~/klipper

### Path to your Moonraker folder, by default that is '~/moonraker'
moonraker_folder=~/moonraker

### Path to your Mainsail folder, by default that is '~/mainsail'
mainsail_folder=~/mainsail

### Path to your Fluidd folder, by default that is '~/fluidd'
#fluidd_folder=~/fluidd

################ !!! DO NOT EDIT BELOW THIS LINE !!! ################
#####################################################################
grab_version(){
  if [ ! -z "$klipper_folder" ]; then
    cd "$klipper_folder"
    klipper_commit=$(git rev-parse --short=7 HEAD)
    m1="Klipper on commit: $klipper_commit"
    cd ..
  fi
  if [ ! -z "$moonraker_folder" ]; then
    cd "$moonraker_folder"
    moonraker_commit=$(git rev-parse --short=7 HEAD)
    m2="Moonraker on commit: $moonraker_commit"
    cd ..
  fi
  if [ ! -z "$mainsail_folder" ]; then
    mainsail_ver=$(head -n 1 $mainsail_folder/.version)
    m3="Mainsail version: $mainsail_ver"
  fi
  if [ ! -z "$fluidd_folder" ]; then
    fluidd_ver=$(head -n 1 $fluidd_folder/.version)
    m4="Fluidd version: $fluidd_ver"
  fi
}


cd ~/

### Store the current date as a variable
today=$(date +%F)

### Read the file and store the line as a variable
compare_date=$(cat github_LastPushed.txt) 

### Compare the current date with the last git back up date, if it doesnt match, then back it all up to github
run_push(){
if [ "x${today}x" != "x${compare_date}x" ]; then

	echo "Last commit: $compare_date"
	echo "No backup to GitHub present from today. Starting..."

	push_config(){
	  cd ~/ ###$config_folder
	  git pull
	  git add .
	  current_date=$(date +%F)
	  git commit -m "Autocommit from $current_date" -m "$m1" -m "$m2" -m "$m3" -m "$m4"
	  git push "https://[USERNAME]:[PERSONAL ACCESS TOKEN]@github.com/[REPO]"
	  
	  ### Write the current date in YYYY-MM-DD format to a text file to refer to on next system boot
	  echo -n $(date +%F)> github_LastPushed.txt
	}

	grab_version
	push_config
	
else
	echo "Last commit: $compare_date"
	echo "Already backed up once today! Backup using macro button if required."
fi
}

run_push
