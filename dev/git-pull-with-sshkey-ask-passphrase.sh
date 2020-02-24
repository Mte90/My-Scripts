#!/usr/bin/expect -f

set pass "your-pass"
cd wp-content/plugins/folder
spawn git pull
expect "Enter passphrase for key '/your/key/path':"
send -- "$pass\r"
send -- "\r"
expect eof
cd ../another
spawn git pull
expect "Enter passphrase for key '/your/key/path':"
send -- "$pass\r"
send -- "\r"
expect eof
cd ../../themes/another-folder
spawn git pull
expect "Enter passphrase for key '/your/key/path':"
send -- "$pass\r"
send -- "\r"
expect eof
