# Find all the files changed later the Makefile 

`find . -name '*.c' -newer Makefile -print`

# File not changed in the last 7 days

`find . -name '*.php' -mtime +7 -print
