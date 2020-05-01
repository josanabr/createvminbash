#!/usr/bin/env bash
#
# Based on code provided from this web page:
#
# https://www.andreafortuna.org/2019/10/24/how-to-create-a-virtualbox-vm-from-command-line/
#
# MODIFIED BY: John Sanabria - john.sanabria@correounivalle.edu.co
# DATE: 2020-05-01
#

Ayuda() {
  echo "Uso ${1} -n <nombre_vm>  
                 -d <disk_size_in_MB>  
                 -m <ram_size_in_MB>"
}

if [ ${#} -eq 0 ]; then
  Ayuda "${0}"
  exit 1
fi

MACHINENAME="demo"
DISKSIZE="10000"
RAMSIZE="1000"
while getopts "n:d:m:" opt; do
  echo "${opt} ${OPTARG}"
  case ${opt} in
   n)
      MACHINENAME=${OPTARG}
      ;;
   d)
      DISKSIZE=${OPTARG}
      ;;
   m)
      RAMSIZE=${OPTARG}
      ;;
   ?)
      Ayuda "${0}"
      exit 1
      ;;
  esac
done

echo "Parametros para la creacion de la maquina virtual"
echo "  Nombre MV: ${MACHINENAME}"
echo "  Tamano disco: ${DISKSIZE} MB"
echo "  Tamano RAM: ${RAMSIZE} MB"
echo ""
echo -n "Esta usted de acuerdo? (Y/n) "
read ANS
if [[ "${ANS}" == "N" || "${ANS}" == "n" ]]; then
  echo "Operacion abortada"
  exit 1
fi

# Download debian.iso
if [ ! -f ./debian.iso ]; then
    wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.3.0-amd64-xfce-CD-1.iso -O debian.iso
fi

#Create VM
VBoxManage createvm --name "${MACHINENAME}" --ostype "Debian_64" --register --basefolder `pwd`
#Set memory and network
VBoxManage modifyvm "${MACHINENAME}" --ioapic on
VBoxManage modifyvm "${MACHINENAME}" --memory ${RAMSIZE} --vram 128
VBoxManage modifyvm "${MACHINENAME}" --nic1 nat
#Create Disk and connect Debian Iso
VBoxManage createhd --filename `pwd`/"${MACHINENAME}"/"${MACHINENAME}"_DISK.vdi --size ${DISKSIZE} --format VDI
VBoxManage storagectl "${MACHINENAME}" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "${MACHINENAME}" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  `pwd`/"${MACHINENAME}"/"${MACHINENAME}"_DISK.vdi
VBoxManage storagectl "${MACHINENAME}" --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach "${MACHINENAME}" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium `pwd`/debian.iso
VBoxManage modifyvm "${MACHINENAME}" --boot1 dvd --boot2 disk --boot3 none --boot4 none

#Enable RDP
VBoxManage modifyvm "${MACHINENAME}" --vrde on
VBoxManage modifyvm "${MACHINENAME}" --vrdeaddress "0.0.0.0"
VBoxManage modifyvm "${MACHINENAME}" --vrdemulticon on --vrdeport 10001

#Start the VM
VBoxHeadless --startvm $MACHINENAME
