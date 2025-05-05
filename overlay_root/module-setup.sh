#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# To verify that your image, use lsinitrd <your initramfs>
#

check() {
return 0
}

depends() {
return 0
}

install() {
inst_hook pre-pivot 99 "$moddir/overlayfs.sh"
}

installkernel() {
   instmods overlay
   hostonly='' instmods '=drivers/usb'
}

