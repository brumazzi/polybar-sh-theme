import evdev
from evdev import InputDevice

import os
import sys

MOD_FILE = "/dev/input/by-id/usb-C-Media_Electronics_Inc._USB_Audio_Device-event-if03"

SH_VOLUME_DEC="""
CUR_VOL=$(amixer get Speaker | grep -E -o '[%[0-9]{1,3}%]' | head -1 | grep -E -o '[0-9]{1,3}')
let NEW_VOL=$CUR_VOL-5
amixer set 'Speaker' "$NEW_VOL%" > /dev/zero
"""

SH_VOLUME_INC="""
CUR_VOL=$(amixer get Speaker | grep -E -o '[%[0-9]{1,3}%]' | head -1 | grep -E -o '[0-9]{1,3}')
let NEW_VOL=$CUR_VOL+5
amixer set 'Speaker' "$NEW_VOL%" > /dev/zero
"""

PID_FILE='/var/run/husk-headset.pid'
if os.path.isfile(PID_FILE):
    sys.exit(1)

run_file = open(PID_FILE, 'w')
run_file.write('%d' %(os.getpid()))
run_file.close()

head_set = InputDevice(MOD_FILE)
for evt in head_set.read_loop():
    if evt.value == 1:
        if evt.code == 114:
            os.system(SH_VOLUME_DEC)
            pass
        elif evt.code == 115:
            os.system(SH_VOLUME_INC)
            pass
        print(SH_VOLUME_INC)
