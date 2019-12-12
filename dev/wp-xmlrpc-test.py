#!/usr/bin/env python3
import xmlrpc.client

try:
    client = xmlrpc.client.ServerProxy("https://localhost.test/xmlrpc.php")

    print(client.wp.getUsers(['','admin','password']))
except xmlrpc.client.Fault as error:
    print("""Call to user API failed with xml-rpc fault!
{}""".format(
        error.faultString))
    print("Fault code: %d" % error.faultCode)
except xmlrpc.client.ProtocolError as error:
    print("""\nA protocol error occurred
URL: {}
HTTP/HTTPS headers: {}
Error code: {}
Error message: {}""".format(
        error.url, error.headers, error.errcode, error.errmsg))
