#!/bin/bash
result=1
while [ $result -ne 0 ]; do
    ls
    result=$?
done

