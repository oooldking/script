#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import urllib2
import json
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

f = open("ip_json.json",'r')
ijson = json.load(f)
jjson = ijson['location']

print jjson[sys.argv[1].encode('utf-8')]