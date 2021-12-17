#!/usr/bin/env python3
import csv
import sys
import requests
import re

file_csv = sys.argv[1]
domain = sys.argv[2]
new_list = []
column = 29

with open(file_csv) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    for row in csv_reader:
        if 'https' not in row[column]:
            continue
        data = requests.get(row[column])
        post_id = re.findall(' postid\-.?\d\d\d\d\d\d', str(data.content))
        if post_id == []:
            post_id = re.findall(' postid\-.?\d\d\d\d\d', str(data.content))
        if post_id == []:
            post_id = re.findall(' postid\-.?\d\d\d\d', str(data.content))
        try:
            post_id = post_id[0].replace(' postid-','')
            new_list.append('<a href="https://' + domain + '/wp-admin/post.php?post=' + post_id + '&action=edit" target="_blank">' + row[column] + '</a><br>' + "\n")
        except:
            print(row[column])

with open('links.htm', mode='w') as output:
    for item in new_list:
        output.write(item)

output.close()
