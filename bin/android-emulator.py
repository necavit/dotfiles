#!/usr/bin/env python

import subprocess
import os

cmdpipe = subprocess.Popen("emulator -list-avds", stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
result = cmdpipe.stdout.read()
avds = filter(lambda s: s != '', result.split('\n'))

print 'Emulators found in the system:\n'
for index, item in enumerate(avds):
    print (index + 1), item
print '\nPlease choose the emulator to be run with KVM acceleration:'
emulator = raw_input('-> ')

cmd = 'emulator -avd ' + avds[int(emulator) - 1] + ' -scale 0.8 -qemu -m 512 -enable-kvm &'
os.system(cmd)
