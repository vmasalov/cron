#!/bin/bash

# By default cron job is executed from home directory for the particular user;

# Datalife engine directory that is to be back up
TARGET_DIR='__REPLACE__'

# Output directory where archives are stored
OUTPUT_DIR='__REPLACE'

######################
# Backup a DLE website
######################

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
tar -cjf $OUTPUT_PATH'/dle_content.tar.bz2' $TARGET_DIR

# Parse config file to extract DB configuration;
DB_NAME=`cat $TARGET_DIR'/engine/data/dbconfig.php' | grep DBNAME | sed s/[\"\,\(\)\;]//g | awk '{ print $3}'`
DB_USER=`cat $TARGET_DIR'/engine/data/dbconfig.php' | grep DBUSER | sed s/[\"\,\(\)\;]//g | awk '{ print $3}'`
DB_PASSWORD=`cat $TARGET_DIR'/engine/data/dbconfig.php' | grep DBPASS | sed s/[\"\,\(\)\;]//g | awk '{ print $3}'`
DB_HOST=`cat $TARGET_DIR'/engine/data/dbconfig.php' | grep DBHOST | sed s/[\"\,\(\)\;]//g | awk '{ print $3}'`

### Dump database
mysqldump --add-drop-database --add-drop-table --delayed-insert $DB_NAME --user=$DB_USER -p$DB_PASSWORD --host $DB_HOST | gzip -c > $OUTPUT_PATH'/dle_db.sql.gz'