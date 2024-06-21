#!/bin/bash
build() {
    add_runscript
}

help() {
    cat <<HELPEOF
This hook opens a LUKS encrypted device during initramfs.
HELPEOF
}
