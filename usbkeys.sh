#!/bin/bash

build() {
    add_runscript
    add_file /etc/initcpio/hooks/usbkeys
}

help() {
    cat <<HELPEOF
This hook scans USB devices for a specific key file.
HELPEOF
}
