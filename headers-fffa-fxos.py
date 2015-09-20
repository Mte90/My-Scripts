#!/usr/bin/python2
# by Hallvord Reiar Michaelsen Steen
# https://github.com/hallvors/mobilewebcompat/blob/master/screenshots/headers.py
from os import environ
import argparse, requests, re, cgi, cgitb
from urlparse import urljoin
cgitb.enable()

UAS = {
    "b2g": "Mozilla/5.0 (Mobile; rv:29.0) Gecko/29.0 Firefox/29.0",
    "ios": "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25",
    "fxa": "Mozilla/5.0 (Android; Mobile; rv:26.0) Gecko/26.0 Firefox/26.0"
}

def make_request(url, ua):
    session = requests.Session()
    session.headers.update({'User-Agent': ua})
    session.headers.update({'Cookies': None})
    session.headers.update({'Cache-Control': 'no-cache, must-revalidate'})
    print 'Will now request %s with UA %s'%(url, ua)
    r = session.get(url, allow_redirects=False, verify=False)
    return r


def dump(response, output):
    wanted_headers = ['content-length', 'location', 'content-type']
    output.append("Response for: '{}'\n".format(response.request.headers['user-agent']))
    output.append("Response Status: {}\n".format(response.status_code))
    for key, value in response.headers.iteritems():
        if key in wanted_headers:
            output.append("{}: {}\n".format(key, value))
    output.append("\n")

def check_url(url, iteration=0, orig_url = ''):
    responses = []
    if re.search('^/', url) and orig_url != '': # We're redirected to a relative URL..
        url = urljoin(orig_url, url)
    for ua in UAS.itervalues():
        response = make_request(url, ua)
        responses.append(response)
        # dump(response)
    # Now compare selected responses..
    output = []
    try:
        if not 'content-length' in responses[0].headers:
            responses[0].headers['content-length'] = 0
        if not 'content-length' in responses[1].headers:
            responses[1].headers['content-length'] = 0
        if not 'content-length' in responses[2].headers:
            responses[2].headers['content-length'] = 0
        biggest_cl = max(int(responses[0].headers['content-length']), int(responses[1].headers['content-length']), int(responses[2].headers['content-length']))
        smallest_cl = min(int(responses[0].headers['content-length']), int(responses[1].headers['content-length']), int(responses[2].headers['content-length']))
        difference = abs(biggest_cl - smallest_cl)
        if biggest_cl > 0:
            if int(float(difference) / float(biggest_cl)*100 ) > 10:
                output.append('Significant difference in source code:\nSmallest response has Content-Length: '+str(smallest_cl))
                output.append('\nLargest response has Content-Length: '+str(biggest_cl)+'\n')
    except Exception,e:
        print 'Exception 1'
        print e
        pass
    try:
        if 'location' in responses[0].headers and not 'location' in responses[1].headers:
            output.append('\nFirefox OS is redirected to '+responses[0].headers['location']+', Firefox for Android not redirected\n')
        elif 'location' in responses[1].headers and not 'location' in responses[0].headers:
            output.append('\nFirefox Android is redirected to %s, Firefox OS not redirected' % str(responses[1].headers['location']))
        elif 'location' in responses[1].headers and 'location' in responses[0].headers:
            if responses[1].headers['location'] != responses[0].headers['location']:
                output.append('\nFirefox OS is redirected to '+responses[0].headers['location']+', Firefox for Android is redirected to '+responses[1].headers['location'])
            elif responses[1].headers['location'] == responses[0].headers['location']:
                if iteration == 0: # follow redirects only once
                    return check_url(responses[1].headers['location'], iteration+1, url)

        if 'location' in responses[0].headers and not 'location' in responses[2].headers:
            output.append('\nFirefox OS is redirected to '+responses[0].headers['location']+', Safari on iPhone not redirected\n')
        elif 'location' in responses[2].headers and not 'location' in responses[0].headers:
            output.append('\nSafari on iPhone is redirected to %s, Firefox OS not redirected' % str(responses[2].headers['location']))
        elif 'location' in responses[2].headers and 'location' in responses[0].headers:
            if responses[2].headers['location'] != responses[0].headers['location']:
                output.append('\nFirefox OS is redirected to '+responses[0].headers['location']+', Safari on iPhone is redirected to '+responses[2].headers['location'])
            elif responses[2].headers['location'] == responses[0].headers['location']:
                if iteration < 2: # follow redirects only once
                    return check_url(responses[2].headers['location'], iteration+1, url)

        if len(output)>0:
            output.append('\n\nSelected HTTP response headers (Firefox OS, Firefox on Android, Safari on iPhone):\n\n')
            dump(responses[0], output)
            dump(responses[1], output)
            dump(responses[2], output)
    except Exception,e:
        print 'Exception 2'
        print e
        return []

    return output

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=("Dump the response headers"
                                     "for a given URL for FxOS and FxA"))
    parser.add_argument("url")
    args = parser.parse_args()
    print(args)
    if not '://' in args.url:
        args.url = 'http://%s' % args.url
    print "".join(check_url(args.url))