#!/bin/bash

#one argument expected
if [ "$#" -ne 1 ] ; then
    echo "One argument needed: VM name"
    exit 1
fi

myhost=10.0.2.2
vmagentfile=/tmp/agent.jar
username=root
password=12345678

if vboxmanage showvminfo "$1" --machinereadable |& grep VMState=\"running\" > /dev/null ; then
    echo "$1 is running"
else
    if vboxmanage showvminfo "$1" --machinereadable |& grep VMState=\"paused\" > /dev/null ; then
	echo "Unpausing $1"
	vboxmanage controlvm "$1" resume
       
    else
	echo "Starting VM $1"
	vboxmanage startvm "$1"  --type headless
    fi
fi

vboxmanage guestcontrol "$1" run --username $username --password $password --exe /bin/wget -- wget -q -O $vmagentfile "http://$myhost:8080/jnlpJars/agent.jar"

vboxmanage guestcontrol "$1" run --username $username --password $password --exe /bin/pkill -- pkill -f $vmagentfile
vboxmanage guestcontrol "$1" run --username $username --password $password --exe /usr/bin/java -- java -jar $vmagentfile
