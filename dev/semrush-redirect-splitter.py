#!/usr/bin/env python3
import csv
import sys

domain = sys.argv[1]
new_csv = []

with open('reindirizzamento_(3xx).csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    total_count = 0
    no_image_count = 0
    for row in csv_reader:
        total_count += 1
        # 0 Address, 8 URL redirect columns
        # Check if https and with www so we can ignore those redirects
        if 'https' in row[0] and 'www' in row[0] and \
            domain in row[0] and domain in row[8]:
            if '.jpg' not in row[8]:
                new_csv.append([row[0], row[8]])
                no_image_count += 1
            line_count += 1

with open('reindirizzamento_(3xx)_pulito.csv', mode='w') as csv_output:
    csv_writer = csv.writer(csv_output, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for item in new_csv:
        csv_writer.writerow(item)

print(f'Processed {line_count} lines with domain ' + domain)
print(f'Processed {no_image_count} lines without images')
print(f'On {total_count} lines')
print(f'New file generated!')
