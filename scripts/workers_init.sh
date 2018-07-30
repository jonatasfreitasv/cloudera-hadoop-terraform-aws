#!/usr/bin/env bash

sudo mkfs.ext4 /dev/xvdb
sudo mkdir /data
sudo mount /dev/xvdb /data

echo "/dev/xvdb  /data   ext4    defaults,noatime    0   0" | sudo tee --append /etc/fstab