#!/usr/bin/env python

import argparse
import os
import json
import sys
import subprocess

def nmcli_toggle(args):
	conn_id = args.connection
	active = subprocess.check_output(['nmcli', 'connection', 'show', '--active'])
	up_down = ('up', 'down')[conn_id in active]
	subprocess.call(['nmcli', 'connection', up_down, 'id', conn_id])
	subprocess.call(['auto-proxy-toggle'])


if __name__ == '__main__':
  # top level argument parser
  parser = argparse.ArgumentParser(
                      description='Toggles a Network connection using nmcli.')
  parser.add_argument('connection',
                      help='the connection to be toggled')
  args = parser.parse_args()

  # main procedure
  nmcli_toggle(args)
