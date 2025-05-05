#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

#
# Mount root fs with overlay if the kernel option have 'overlay=yes'
#
# 

set -e 

do_overlay() {
    modprobe overlay
    mkdir /rw
    mount -t tmpfs -o "size=500M" overlay-rw /rw
    mkdir /rw/upper
    mkdir /rw/work
    mkdir /os

    opts=$(findmnt -nfo options --mountpoint /sysroot)
    src=$(findmnt -nfo source --mountpoint /sysroot)

    umount /sysroot
    mount -o $opts $src /os
    mount -t overlay -o lowerdir=/os,upperdir=/rw/upper,workdir=/rw/work overlay-root /sysroot
}


. /lib/dracut-lib.sh

if getargs 'overlay=yes'; then
    do_overlay
fi
