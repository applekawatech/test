#!/bin/bash

# Variables
USB_DEVICE="/dev/sdX1"  # USB device with key
LUKS_DEVICE="/dev/sdY1" # LUKS encrypted device
MOUNT_POINT="/mnt/luks" # Mount point for decrypted LUKS device
MAPPED_NAME="luks_device"

# Create mount point if it doesn't exist
[ ! -d "$MOUNT_POINT" ] && sudo mkdir -p "$MOUNT_POINT"

# Decrypt LUKS device using key file from USB
sudo cryptsetup luksOpen --key-file "$USB_DEVICE" "$LUKS_DEVICE" "$MAPPED_NAME"

# Check if the decryption was successful
if [ $? -eq 0 ]; then
    # Mount the decrypted LUKS device
    sudo mount /dev/mapper/"$MAPPED_NAME" "$MOUNT_POINT"
    if [ $? -eq 0 ]; then
        echo "LUKS device mounted successfully at $MOUNT_POINT."
    else
        echo "Failed to mount the LUKS device."
        sudo cryptsetup luksClose "$MAPPED_NAME"
    fi
else
    echo "Failed to decrypt the LUKS device."
fi
