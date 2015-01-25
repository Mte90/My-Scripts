#!/bin/bash

# Written by Mte90 - www.mte90.net - 2013
# wp-installer it's a simpe script for install on local machine wordpress with some plugin with a click!
#Prerequisites:
# require Breeder - https://github.com/welaika/breeder - Written by weLaika
# 	Generate the Virtual Host file, edit the file hosts, refresh apache and create the folder in this script
# require WordMove - https://github.com/welaika/wordmove - Written by weLaika
#	Capistrano for Wordpress if you don't know it, fix your workflow now!!
# require Wp-Cli - http://wp-cli.org/ - Written by wp-cli
#	Command Line Script for execute command on local wordpress installation

#Usage: wp-installer.sh sitename
# sitename will be used for generate the db, create the folder and the virtual host

#Install:
# place the file in /usr/local/bin and give the execute permission!

#Language of wordpress
locale='it_IT'
#DB user
dbuser='root'
#Db Pass
dbpass='test'
#Admin password for wordpress
admin_pass='test'
#User in the system
user='mte90'

echo "Creating Virtual Host $1.dev"

#Create Virtual Host
sudo breeder -s $1 -a dev

cd /var/www/$1.dev
echo '--------------------------------------------------------'
echo "Downloading of wordpress with locale $locale in /var/www/$1.dev"

#Install wordpress
wp core download --locale=$locale
wp core config --dbname=$1 --dbuser=$dbuser --dbpass=$dbpass
wp db create
wp core install --url=$1.dev --title='Change me!' --admin_name=admin  --admin_password=$admin_pass --admin_email=youremail@email.it

echo '--------------------------------------------------------'
echo "Tweak and clean"

wp rewrite structure '/%postname%/'
wp theme delete twentythirteen
wp theme delete twentyfourteen
wp comment delete 1
wp core config --extra-php --dbname=$1 --dbuser=$dbuser --dbpass=$dbpass <<PHP
define('WP_POST_REVISIONS', 3);
define('DISALLOW_FILE_EDIT', true);
PHP

echo 'Wordpress installed and configured!'
echo '--------------------------------------------------------'
echo 'Initializing WordMove'

#Init wordmove
wordmove init

echo '--------------------------------------------------------'
echo 'Installing few plugin'

#Install some essential plugin
wp plugin install wordpress-seo
wp plugin install stop-pinging-yourself-for-wordpress
wp plugin install better-wp-security
wp plugin install wp-original-media-path
wp plugin install zero-spam
wp plugin install debug-bar --activate

echo '--------------------------------------------------------'
echo 'Remove preloaded plugin'

wp plugin delete hello
wp plugin delete akismet

echo '--------------------------------------------------------'

sudo chown -R $user:www-data /var/www/$1.dev
sudo chmod -R 775 /var/www/$1.dev
echo 'Finished!'
echo "Open http://$1.dev on your browser"