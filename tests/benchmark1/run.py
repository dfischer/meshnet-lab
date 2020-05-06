#!/usr/bin/env python3

import os
import sys
import glob

sys.path.append('../../')
import software
import network
import tools


tools.root()
software.clear()
network.clear()

# need to open more files (especially for traffic measurement processes)
os.system('ulimit -Sn 4096')

prefix = os.environ.get('PREFIX', '')

# 100MBit LAN cable
def get_tc_command(link, ifname):
	return f'tc qdisc replace dev "{ifname}" root tbf rate 100mbit burst 8192 latency 1ms'

def run(protocol, csvfile):
	for path in sorted(glob.glob(f'../../data/grid4/*.json')):
		(node_count, link_count) = tools.json_count(path)

		# Limit node count to 300
		if node_count > 300:
			continue

		print(f'run {protocol} on {path}')

		network.change(from_state='none', to_state=path, link_command=get_tc_command)
		tools.sleep(10)

		#for i in range(0, 10):
		wait_beg_ms = tools.millis()

		software.start(protocol)

		# Wait until 60s are over, else error
		tools.wait(wait_beg_ms, 60)

		ping_result = tools.ping(protocol=protocol, count=link_count, duration_ms=60000, verbosity='verbose')

		sysload_result = tools.sysload()

		software.stop(protocol)

		# add data to csv file
		extra = (['node_count'], [node_count])
		tools.csv_update(csvfile, '\t', extra, ping_result, sysload_result)

		network.clear()

for protocol in ['babel', 'batman-adv', 'yggdrasil']:
	with open(f"{prefix}benchmark1-{protocol}.csv", 'w+') as csvfile:
		run(protocol, csvfile)