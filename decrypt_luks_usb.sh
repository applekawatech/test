#!/bin/bash

# デバイスベンダーIDとプロダクトID (不要になったのでコメントアウト)
# VENDOR_ID="325d"
# PRODUCT_ID="6410"

# LUKSボリュームのデバイス
LUKS_DEVICE=$1
MAPPED_NAME=$2

# USBデバイスのパーティション
USB_PARTITION="/dev/disk/by-id/usb-USB_DISK_3.0_D92E3BA9DCD5F093-0:0-part1"  # デバイスIDを直接指定

# USBデバイスのパーティションを見つける関数 (不要になったのでコメントアウト)
# find_usb_partition() {
#  ... (省略) ...
# }

# USBデバイスのパーティションを探す (不要になったのでコメントアウト)
# USB_PARTITION=$(find_usb_partition)
# if [ -z "$USB_PARTITION" ]; then
#  ... (省略) ...
# fi

if [ -z "$LUKS_DEVICE" ] || [ -z "$MAPPED_NAME" ]; then
  echo "エラー: LUKSデバイスとマッパー名を指定してください。" >&2
  exit 1
fi

# LUKSデバイスを解読
cryptsetup open --type luks --key-file "$USB_PARTITION" "$LUKS_DEVICE" "$MAPPED_NAME"
result=$?
if [ $result -ne 0 ]; then
  echo "エラー: LUKSデバイスの解読に失敗しました。（終了コード: $result）" >&2
  exit 1
fi

echo "LUKSデバイスが成功裏に解読されました。"
