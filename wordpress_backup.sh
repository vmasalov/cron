#!/bin/bash

# By default cron job is executed from home directory for the particular user;

# Wordpress directory that is to be back up
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
if [ ! -d $OUTPUT_DIR ];
  then
  mkdir $OUTPUT_DIR
  chmod 640 $OUTPUT_DIR
fi

OUTPUT_PATH=$OUTPUT_DIR'/'`date +"%m_%d_%Y_%H_%M"`
if [ ! -d $OUTPUT_PATH ];
  then
  mkdir $OUTPUT_PATH
fi

### Archive project files
tar -cjf $OUTPUT_PATH'/wordpress_content.tar.bz2' $TARGET_DIR

# Parse config file to extract DB configuration;
DB_NAME=`cat $TARGET_DIR'/wp-config.php' | grep DB_NAME | sed s/[\'\,\(\)\;]//g | awk '{ print $2}'`
DB_USER=`cat $TARGET_DIR'/wp-config.php' | grep DB_USER | sed s/[\'\,\(\)\;]//g | awk '{ print $2}'`
DB_PASSWORD=`cat $TARGET_DIR'/wp-config.php' | grep DB_PASSWORD | sed s/[\'\,\(\)\;]//g | awk '{ print $2}'`
DB_HOST=`cat $TARGET_DIR'/wp-config.php' | grep DB_HOST | sed s/[\'\,\(\)\;]//g | awk '{ print $2}'`

### Dump database
mysqldump --add-drop-database --add-drop-table --delayed-insert $DB_NAME --user=$DB_USER -p$DB_PASSWORD --host $DB_HOST | gzip -c > $OUTPUT_PATH'/wordpress_db.sql.gz'