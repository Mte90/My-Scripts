#!/usr/bin/python

import json
import os
import subprocess

if not os.path.exists('list.json'):
    print('Generating post list')
    os.system('wp post list --post_type=post --fields=ID,post_title,post_name,post_date,post_status,post_content --post_status=publish --format=json > list.json')

new_list = []
i = 0
with open('list.json') as f:
    posts = json.load(f)
    total = str(len(posts))
    print(total + ' posts')
    for post in posts:
        i += 1
        print(' ' + str(i) + '/' + total + ' Post meta from ' + str(post['ID']))
        meta_list = json.loads(subprocess.check_output('wp post meta list ' + str(post['ID']) + ' --format=json', shell=True))
        categories = json.loads(subprocess.check_output('wp post term list ' + str(post['ID']) + ' category --fields=slug,name --format=json', shell=True))
        new_meta_list = []
        for meta in meta_list:
            del meta['post_id']
            if meta['meta_key'] == '_thumbnail_id':
                post['_thumbnail_url'] = json.loads(subprocess.check_output('wp post get ' + str(meta['meta_value']) + ' --format=json', shell=True))['guid']
            if not any(x in meta['meta_key'] for x in ['_oembed', '_edit_l', '_wp_old_date', '_thumbnail_id', '_aioseop_opengraph_settings']):
                new_meta_list.append(meta)

        item = post
        item['meta'] = new_meta_list
        item['categories'] = categories
        new_list.append(item)

print('Saving posts with meta')
with open('list_with_meta.json', 'w') as f:
    json.dump(new_list, f, ensure_ascii=True, indent=4)
