#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import urllib2
import json
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

ip_api = urllib2.urlopen(r'http://ip-api.com/json')

ijson = json.loads(ip_api.read())

print ijson[sys.argv[1].encode('utf-8')]