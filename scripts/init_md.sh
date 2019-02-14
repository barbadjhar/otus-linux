#!/bin/bash

if [[ ! -f "/dev/md0" ]]; then
        DISK_MD=$(lshw -short -class disk | grep 209MB | awk '{print $2}')
        yes| mdadm --create /dev/md0 --level=10 --raid-devices=5 $DISK_MD
        sleep 20 
        echo "STEP1: MD RAID create"
else
        echo "Bender: we have a problem STEP 1"
fi

if [[ -s /etc/mdadm.conf ]]; then
        echo "DEVICE partitions" >> /etc/mdadm.conf ;
        mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf ;
        echo "STEP2: information about MD add /etc/mdadm.conf"
else 
        echo "Bender: we have a problem STEP2"
fi

if [[ -b /dev/md0 ]] && [[ "$(lsblk -f /dev/md0 -o fstype | grep -v FSTYPE)" != "ext4" ]] ; then
        DISK_MD_NUM=$(ls -1 /dev/md0)
        mkfs.ext4 "$DISK_MD_NUM";
        sleep 10;
        echo "STEP3:FS create for MD"
else
        echo "Bender: we have a problem STEP 3 -/\- "
fi

DISK_UUID_MD=$(lsblk /dev/md0 -o UUID | grep -v UUID)
echo "$DISK_UUID_MD"
DISK_UUID_FS=$(grep u01 /etc/fstab  | awk '{print $1}' | awk -F'=' '{print $2}')
echo "$DISK_UUID_FS"

if [[ -b /dev/md0 ]] && [[ "$DISK_UUID_MD" != "$DISK_UUID_FS" ]]; then
        NUM_UUID_MD=$(lsblk -o UUID /dev/md0 | grep -v UUID)
        echo "UUID=$NUM_UUID_MD /u01  ext4      defaults 0 0 " >> /etc/fstab ;
        echo "STEP4: line add on fstab"
else
        echo "MD not exist or was't add"
fi

if [[ ! -d "/u01" ]]; then
        mkdir /u01
else
        echo "/u01 exist or epmty"
fi

mount -a
