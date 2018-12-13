#!/usr/bin/python

# Generate the list of tags
# wp term list post_tag --format=json > tags.json

import json
import os

with open('tags.json') as f:
    tags = json.load(f)
    for taxonomy in tags:
        if taxonomy['count'] == 0:
            os.system("wp term delete " + str(taxonomy['term_id']))
