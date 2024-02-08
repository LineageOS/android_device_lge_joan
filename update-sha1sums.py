#!/usr/bin/env python
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

import os
import sys
from hashlib import sha1

device='joan'
vendor='lge'

files = [
    "proprietary-files.txt",
    "proprietary-files_Q910.txt",
    "proprietary-files_h930.txt",
    "proprietary-files_h932.txt"
]

def cleanup(lines):
    for index, line in enumerate(lines):
        # Skip empty or commented lines
        if len(line) == 0 or line[0] == '#' or '|' not in line:
            continue

        # Drop SHA1 hash, if existing
        lines[index] = line.split('|')[0]
    return lines


def update(lines):
    for index, line in enumerate(lines):
        # Skip empty lines
        if len(line) == 0:
            continue

        # Check if we need to set SHA1 hash for the next files
        if line[0] == '#':
            needSHA1 = (' - from' in line or '# phoenix_sprout - ' in line)
            continue

        if needSHA1:
            # Remove existing SHA1 hash
            line = line.split('|')[0]

            filePath = line.split(';')[0].split(':')[-1]
            if filePath[0] == '-':
                filePath = filePath[1:]

            with open(os.path.join(vendorPath, filePath), 'rb') as f:
                hash = sha1(f.read()).hexdigest()

            lines[index] = '%s|%s' % (line, hash)
    return lines


for i in files:
    with open(i, 'r') as f:
        lines = f.read().splitlines()
    vendorPath = '../../../vendor/' + vendor + '/' + device + '/proprietary'
    needSHA1 = False

    if len(sys.argv) == 2 and sys.argv[1] == '-c':
        lines = cleanup(lines)
    else:
        lines = update(lines)

    with open(i, 'w') as file:
        file.write('\n'.join(lines) + '\n')

