#!/bin/bash

# デバイスベンダーIDとプロダクトID
VENDOR_ID="325d"
PRODUCT_ID="6410"

# LUKSボリュームのデバイス
LUKS_DEVICE=$1
MAPPED_NAME=$2

# USBデバイスのパーティションを見つける関数
find_usb_partition() {
    for sysfs_path in /sys/bus/usb/devices/*; do
        if [ -f "$sysfs_path/idVendor" ] && [ -f "$sysfs_path/idProduct" ]; then
            idVendor=$(cat "$sysfs_path/idVendor")
            idProduct=$(cat "$sysfs_path/idProduct")
            if [ "$idVendor" == "$VENDOR_ID" ] && [ "$idProduct" == "$PRODUCT_ID" ]; then
                block_device=$(ls "$sysfs_path" | grep 'block')
                if [ ! -z "$block_device" ]; then
                    echo "/dev/$block_device"
                    return 0
                fi
            fi
        fi
    done
    return 1
}

# USBデバイスのパーティションを探す
USB_PARTITION=$(find_usb_partition)
if [ -z "$USB_PARTITION" ]; then
    echo "エラー: 指定されたベンダーIDとプロダクトIDのUSBデバイスが見つかりません。"
    exit 1
fi

# LUKSデバイスを解読
cryptsetup open --type luks --key-file "$USB_PARTITION" "$LUKS_DEVICE" "$MAPPED_NAME"
if [ $? -ne 0 ]; then
    echo "エラー: LUKSデバイスの解読に失敗しました。"
    exit 1
fi

echo "LUKSデバイスが成功裏に解読されました。"
