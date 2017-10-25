#!/usr/bin/env python

import argparse
import os
import json
import sys
import subprocess

def nmcli_check_connection(args):
	conn_id = args.connection
	active = subprocess.check_output(['nmcli', 'connection', 'show', '--active'])
	if conn_id in active:
		if args.echo:
			print '[nmcli-check-connection] Connection', conn_id, 'is active'
		sys.exit(0)
	else:
		if args.echo:
			print '[nmcli-check-connection] Connection', conn_id, 'is NOT active'
		sys.exit(1)


if __name__ == '__main__':
  # top level argument parser
  parser = argparse.ArgumentParser(
                      description='Checks if a Network connection is up or down using nmcli.')
  parser.add_argument('-e', '--echo',
                      help='prints to stdout the status of the connection', action='store_true')
  parser.add_argument('connection',
                      help='the connection to be checked')
  args = parser.parse_args()

  # main procedure
  nmcli_check_connection(args)
