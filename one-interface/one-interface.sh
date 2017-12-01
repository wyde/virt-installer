#!/bin/bash

# parameter 
DISKSIZE=50
NAME=web-jenny

# config don't need to change by default
KSNAME=$NAME.cfg
KSPATH=/home/ops/virt-installer/$NAME/$KSNAME
DISKPATH=/image/qcow2/$NAME.qcow2
ISOPATH=/image/iso/CentOS-7-x86_64-Everything-1708.iso 


# disk and kickstart file check
if [ -f "$DISKPATH" ]
then
    echo "$DISKPATH already exists"
else
    qemu-img create -f qcow2 $DISKPATH $DISKSIZE"G"
    echo "$DISKPATH created"
fi

if [ -f "$KSPATH" ]
then
    echo " $KSPATH already exists...virt-intsallation begin"
else
    echo " $KSPATH could not been found"
    exit 103
fi

# installation begin
virt-install \
    --name $NAME \
    --vcpus 1 \
    --ram 1024 \
    --disk path=$DISKPATH,size=$DISKSIZE \
    --os-variant rhel7 \
    --network=bridge:br3 \
    --nographics \
    --initrd-inject $KSPATH \
    --extra-args "ks=file:/$KSNAME console=tty0 console=ttyS0,115200n8" \
    --location=$ISOPATH \
    --autostart # \
    #--debug \
    #--noautoconsole
