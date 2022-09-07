#!/usr/bin/env bash

# To use with the Open with CLVC Service menu
 
killall vlc
rm /tmp/cvlc.sh
list=$(echo "$1" | sed -e 's/\/media/\"\/media/g' )
list=$(echo "$list" | sed -e 's/ \"/\" \"/g' )
list+='"'
echo "#!/usr/bin/env bash" > /tmp/cvlc.sh
echo "cvlc $list" >> /tmp/cvlc.sh
chmod +x /tmp/cvlc.sh
/tmp/cvlc.sh
