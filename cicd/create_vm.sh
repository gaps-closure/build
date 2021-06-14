#!/bin/bash -x

#one argument expected
if [ "$#" -ne 1 ] ; then
    echo "One argument needed: VM name"
    exit 1
fi

MACHINENAME="$1"
BASEDIR=~/tmp_vm
ISOFILE=$BASEDIR/centos7.iso
DISKNAME="$BASEDIR/$MACHINENAME/$MACHINENAME"_disk
password=12345678

mkdir -p "$BASEDIR"

# Download xxx.iso
if [ ! -f $ISOFILE ]; then
    wget -nv http://mirror.math.princeton.edu/pub/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-DVD-2009.iso \
	 -O $ISOFILE

fi

if vboxmanage list vms |& grep \"$MACHINENAME\" > /dev/null ; then
    echo "$1 exists"
    vboxmanage controlvm $MACHINENAME poweroff
    vboxmanage unregistervm $MACHINENAME --delete
fi
   
#Create VM
vboxmanage createvm --name $MACHINENAME --ostype "RedHat_64" --register --basefolder $BASEDIR
#Set memory and network
vboxmanage modifyvm $MACHINENAME --ioapic on
vboxmanage modifyvm $MACHINENAME --memory 4024
vboxmanage modifyvm $MACHINENAME --nic1 nat
#Create Disk and connect  Iso
vboxmanage createhd --filename $DISKNAME.vdi --size 80000 --format VDI
vboxmanage storagectl $MACHINENAME --name "SATA Controller" --add sata --controller IntelAhci
vboxmanage storageattach $MACHINENAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  $DISKNAME.vdi
vboxmanage storagectl $MACHINENAME --name "IDE Controller" --add ide --controller PIIX4
vboxmanage storageattach $MACHINENAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $ISOFILE
vboxmanage modifyvm $MACHINENAME --boot1 dvd --boot2 disk --boot3 none --boot4 none

#Enable RDP
#vboxmanage modifyvm $MACHINENAME --vrde on
#vboxmanage modifyvm $MACHINENAME --vrdemulticon on --vrdeport 10001

#install the os, create root user and user 'jenkins' with the same password
vboxmanage unattended install $MACHINENAME --iso=$ISOFILE --user=jenkins --password=$password --install-additions

#Start the VM
#vboxheadless --startvm $MACHINENAME
vboxmanage startvm $MACHINENAME --type headless
vboxmanage guestproperty wait $MACHINENAME /VirtualBox/GuestInfo/OS/NoLoggedInUsers --timeout 1800000
vboxmanage guestcontrol "$MACHINENAME" run --username root --password $password --exe /sbin/dhclient

#install java

vboxmanage guestcontrol centos_test_1 run --username root --password $password --exe /bin/yum -- yum -y install java-1.8.0-openjdk
