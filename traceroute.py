#!/usr/bin/python
# -*- coding: UTF-8 -*-


def TraceRoute(filename):

	txtfile = open(filename,"r")
	content = txtfile.read().strip().split("\n")[1:]
	d=dict()

	for i in range(len(content)):
		
		line = content[i]
		if line[1].isdigit():
			if line[4] != "*" :
				l1=float(line.strip().split("  ")[2].replace(" ms",""))
				l2=float(content[i+1].strip().split("  ")[1].replace(" ms",""))
				l3=float(content[i+2].strip().split("  ")[1].replace(" ms",""))
				latency=str(round((l1+l2+l3)/3,2))+" ms"
				asn = line.strip().split("  ")[3]
				route = line.strip().split("  ")[4]
				ip = line.strip().split("  ")[1]
				step = line[0:2]
			else:
				latency="*"
				asn = "*"
				route = "*"
				ip = "*"
				step = line[0:2]
				
			d[int(step)]=dict()
			d[int(step)]["ip"]=ip
			d[int(step)]["latency"]=latency
			d[int(step)]["asn"]=asn
			d[int(step)]["route"]=route
	return d.copy()
