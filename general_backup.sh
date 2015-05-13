#!/bin/bash

# By default cron job is executed from home directory for the particular user;

# Directory that is to be back up
TARGET_DIR='__REPLACE__'

# Output directory where archives are stored
OUTPUT_DIR='__REPLACE'

############################
# Backup a wordpress website
############################

# check for the directories to exist;
if [ ! -d $TARGET_DIR ]; 
  then
  echo '[ error ] Missing target directory: ' $TARGET_DIR
  exit 1
fi

# Create output directory;
OUTPUT_PATH=$OUTPUT_DIR'/'`date +"%m_%d_%Y_%H_%M"`
if [ ! -d $OUTPUT_PATH ];
  then
  mkdir -p $OUTPUT_PATH
fi

### Archive project files
tar -cjf $OUTPUT_PATH'/content.tar.bz2' $TARGET_DIR