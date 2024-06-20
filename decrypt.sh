#!/bin/bash

# Vendor ID and Product ID of the device (commented out as it's no longer needed)
# VENDOR_ID="325d"
# PRODUCT_ID="6410"

# LUKS device and mapped name
LUKS_DEVICE=$1
MAPPED_NAME=$2

# USB device partition
USB_PARTITION="/dev/disk/by-id/usb-USB_DISK_3.0_D92E3BA9DCD5F093-0:0-part1"  # Directly specify device ID

# Function to find the USB device partition (commented out as it's no longer needed)
# find_usb_partition() {
#  ... (omitted) ...
# }

# Find the USB device partition (commented out as it's no longer needed)
# USB_PARTITION=$(find_usb_partition)
# if [ -z "$USB_PARTITION" ]; then
#  ... (omitted) ...
# fi

if [ -z "$LUKS_DEVICE" ] || [ -z "$MAPPED_NAME" ]; then
  echo "Error: Specify LUKS device and mapper name." >&2
  exit 1
fi

# Decrypt the LUKS device
cryptsetup open --type luks --key-file "$USB_PARTITION" "$LUKS_DEVICE" "$MAPPED_NAME"
result=$?
if [ $result -ne 0 ]; then
  echo "Error: Failed to unlock LUKS device. (Exit code: $result)" >&2
  exit 1
fi

echo "Successfully unlocked LUKS device."
