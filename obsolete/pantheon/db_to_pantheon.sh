#!/bin/bash

# Required terminus and mysql on your system
# Example: db_to_pantheon.sh pantheon site name, sql file

ph_site=$1
file=$2

if [ -z $ph_site ] && [ -z $file ]; then
    echo ''
    echo 'This script require 2 parameters in that order: pantheon site name, sql file'
    echo 'Made by Mte90 for Codeat'
    exit
fi
 
if ! [ -x "$(command -v terminus)" ]; then
  echo 'terminus is missing on that system' >&2
  exit
fi

host=`terminus site connection-info --site="$ph_site" --env=dev --field=mysql_host`
pass=`terminus site connection-info --site="$ph_site" --env=dev --field=mysql_password`

#Clean db
echo 'Cleaning online DB'
mysqldump -upantheon -p"$pass" -h "$host" -P 10252 --add-drop-table --no-data pantheon | grep ^DROP | mysql -upantheon -p"$pass" -h "$host" -P 10252 pantheon

#Upload db
echo 'Upload new DB'
mysql -upantheon -p"$pass" -h "$host" -P 10252 pantheon < $file
old_domain=`terminus wp 'option get siteurl' --site="$ph_site" --env=dev`
echo 'Replace of the sitename'
terminus wp "search-replace $old_domain http://dev-$ph_site.pantheon.io" --site=$ph_site --env=dev
echo "Activate wp-native-php-sessions"
terminus wp 'plugin install wp-native-php-sessions --activate' --site=$ph_site --env=dev