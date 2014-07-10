#!/bin/bash

# Define DB Login
USER="actoner"
PASS="Act0ner"
HOST="172.28.223.128"

# Get the database from the commandline
DB=$1

# Define the 'structure only' tables
#STRUCTURE_ONLY="/^(prefix1_|prefix2_)?(watchdog|sessions|cache(_.+)?)$/"
STRUCTURE_ONLY="/^(watchdog|sessions|cache|cache_views_data|cache_views|cache_block|cache_content|cache_filter|cache_form|cache_bootstrap|cache_menu|cache_mollom|cache_page|cache_rules|cache_swftools|cache_uc_price|cache_update|cache_field|cache_image|cache_media_xml|cache_metatag|cache_path|cache_token|search_index|linkchecker_links|login_security_track|session|print_mail_page_counter|print_page_counter|search_total|search_dataset|xmlsitemap_sitemap|main_watchdog|main_sessions|main_cache|main_search_index(_.+)?)$/"

# Get the tables from the database
TABLES=`mysql -u$USER -p$PASS -h $HOST -B -N -e 'show tables;' $DB`

# Create the SQL file
DBFILE="${DB}.sql" > $DBFILE

# Status message
# echo "Starting dump of ${DB}"

# Loop over the tables
for t in $TABLES; do
          # Test if the table matches the 'structure only' regex
          RESULT=`echo "$t" | gawk "$STRUCTURE_ONLY"`
          # if a match...
             if [ $RESULT ]
                then
                # ... dump structure only onto the end of the SQL file
                mysqldump --opt --no-data --user=$USER --password=$PASS --skip-extended-insert -h $HOST $DB $t >> $DBFILE
             else
                # dump full table onto the end of the SQL file
                mysqldump --opt -u $USER -p$PASS --skip-extended-insert -h $HOST $DB $t >> $DBFILE
             fi
done
