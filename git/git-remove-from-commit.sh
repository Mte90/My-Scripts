#!/bin/bash

# Require only the commit hash and run the script inside the folder
# Based: https://stackoverflow.com/questions/41953300/how-to-delete-the-old-git-history

git checkout --orphan temp $1      # checkout to the status of the git repo at commit f; creating a branch named "temp"
git commit -m "new history commit"     # create a new commit that is to be the new root commit
git rebase --onto temp $1 master   # now rebase the part of history from <f> to master onthe temp branch
git branch -D temp                  # we don't need the temp branch anymore

git prune --progress                 # delete all the objects w/o references
git gc --aggressive                  # aggressively collect garbage; may take a lot of time on large repos
