#!/bin/bash
# A simple script that scan and attach the file scanned to a new email on thunderbird
# require kdialog,xsane,imagemagick
# based on one-touch scan http://en.gentoo-wiki.com/wiki/Scanner_buttons_and_one-touch_scanning#one-touch_e-mail
# Version 1.0 by Mte90 - www.mte90.net

#Dialog for choose the recipient
email="$(kdialog --menu 'Choose the recipient' 1 'Tizio email@email' 2 'Caio email@email' 3 'Insert it')"
TO=""
LIST_FILE=""
  case $email in
    1)
      TO="email@email"
      ;;
    2)
      TO="email@email"
      ;;
    3)
      TO="$(kdialog --title 'Email' --inputbox 'Insert the email' '@')"
      ;;
  esac
echo 'Choosen' ${TO}

#Dialog for choose the number of scan
scan_n="$(kdialog --menu 'Number of Scan' 1 '1 Page' 2 '2 Page' 3 '3 Page')"
for i in `seq 1 $scan_n`
do
	echo "Scan "$i" page"
	TMPFILE='/tmp/attach.'$email'.'$i'.jpg'

	#check the option for your scanner can be different
	scanimage --format jpg --mode '24bit Color' --resolution 100 -l 0 -t 0 -x 215mm -y 280mm > ${TMPFILE}

	#compress the jpg
	mogrify -quality 80 ${TMPFILE}
	echo "Page Compressed"
	case $i in
		1)
			LIST_FILE='file://'$TMPFILE
			;;
		*)
			LIST_FILE=$LIST_FILE',file://'$TMPFILE
			;;
		esac

	#show a dialog for start the next scan in case of 2 or plus page
	if [ $scan_n > 1 ]
	then
	  if [ $i != $scan_n ]
	  then
	  next="$(kdialog --msgbox 'Insert the next page')"
	  fi
	fi
done
subj="$(kdialog --title 'Subject email' --inputbox 'Subject' 'Hello')"

# Use mozilla thunderbird/icedove to e-mail an image
thunderbird -compose "attachment='${LIST_FILE}',to='${TO}',subject='${subj}'"