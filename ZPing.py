#!/usr/bin/python
# -*- coding: UTF-8 -*-
'''
 Author 雨落无声（Github: https://github.com/ylws-4617)
 Reference:
 1. https://www.s0nnet.com/archives/python-icmp
 2. http://www.pythoner.com/357.html
'''

import commands

def ping(host):
    cmd = "ping "+ str(host) + " -c2 -W 2"
    result = commands.getoutput(cmd)
    result = result.split()
    result = result[-2].split("/")[0]
    if result.isalpha():
        result = False
    return float(result)

STYLE = {
    'fore': {
        'black': 30, 'red': 31, 'green': 32, 'yellow': 33,
        'blue': 34, 'purple': 35, 'cyan': 36, 'white': 37,
    },
    'back': {
        'black': 40, 'red': 41, 'green': 42, 'yellow': 43,
        'blue': 44, 'purple': 45, 'cyan': 46, 'white': 47,
    },
    'mode': {
        'bold': 1, 'underline': 4, 'blink': 5, 'invert': 7,
    },
    'default': {
        'end': 0,
    }
}


def use_style(string, mode='', fore='', back=''):
    mode = '%s' % STYLE['mode'][mode] if STYLE['mode'].has_key(mode) else ''
    fore = '%s' % STYLE['fore'][fore] if STYLE['fore'].has_key(fore) else ''
    back = '%s' % STYLE['back'][back] if STYLE['back'].has_key(back) else ''
    style = ';'.join([s for s in [mode, fore, back] if s])
    style = '\033[%sm' % style if style else ''
    end = '\033[%sm' % STYLE['default']['end'] if style else ''
    return '%s%s%s' % (style, string, end)

D = {
    'Zhengzhou': '61.168.23.74', 
    'Jinan': '202.102.152.3',
    'Tianjin': '219.150.32.132', 
    'Changji': '61.128.107.242',
    'Lhasa': '221.13.70.244', 
    'Changchun': '202.98.0.68',
    'Shenzhen': '119.147.52.35', 
    'Lanzhou': 'www.lanzhouunicom.com', 
    'Xining': '221.207.32.94', 
    'Hefei': '112.122.10.26',
    'Wuhan': '113.57.249.2', 
    'Xiangyang': '202.103.44.150', 
    'Nanchang': 'speedtest2.wy.jxunicom.com', 
    'Chongqing': 'speedtest1.cqccn.com', 
    'Shanghai': 'speedtest2.sh.chinamobile.com',
    'Huhehaote': '222.74.1.200',
    'Urumqi': '61.128.114.133',
    'Hangzhou': '122.229.136.10',
    'Xi an': 'xatest.wo-xa.com', 
    'Ningbo': '202.96.104.1',
    'Taiyuan': 'speedtest.sxunicomjzjk.cn', 
    'Suzhou': '218.94.214.42', 
    'Changsha': '61.234.254.5',
    'Harbin': '202.97.224.1',
    'Beijing': 'st1.bjtelecom.net',
    'Chengdu': 'speed.westidc.com.cn', 
    'Shenyang': 'speedtest1.online.ln.cn',
    'Nanjing': '4gnanjing1.speedtest.jsinfo.net', 
    'Ningxia': '221.199.9.35',
    'Fuzhou': 'upload1.testspeed.kaopuyun.com'
    }


string =list()
d=dict()

for x in D:
    host=D[x]
    result = ping(host)


    if result == False:
        latency_str = use_style(str("Fail"), fore='red')
    elif float(result) <= 60:
        latency_str =use_style(str(round(result,2)) + " ms",fore='green')
    elif float(result) <= 130:
        latency_str = use_style(str(round(result,2))+" ms",fore='yellow')
    else:
        latency_str = use_style(str(round(result,2))+" ms", fore='red')

    d[x] = float(result)

    string.append((x,latency_str))
    if len(string) == 3:
        print("{0:12}: {1:20}{2:12}: {3:20}{4:12}: {5:20}".format(string[0][0],string[0][1],string[1][0],string[1][1],string[2][0],string[2][1]))
        string = list()


if len(string) == 2:
    print("{0:12}: {1:20}{2:12}: {3:20}".format(string[0][0],string[0][1],string[1][0],string[1][1]))

if len(string) == 1:
    print("{0:12}: {1:20}".format(string[0][0],string[0][1]))
