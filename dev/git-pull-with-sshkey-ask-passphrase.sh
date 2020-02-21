#!/usr/bin/expect -f

set pass "your-pass"
cd wp-content/plugins/folder
spawn git pull
expect "Enter passphrase for key '/your/key/path':"
send -- "$pass\r"
send -- "\r"
interact
cd ../another
spawn git pull
expect "Enter passphrase for key '/your/key/path':"
send -- "$pass\r"
send -- "\r"
interact
cd ../../themes/another-folder
spawn git pull
expect "Enter passphrase for key '/your/key/path':"
send -- "$pass\r"
send -- "\r"
expect eof
