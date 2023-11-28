#!/bin/bash

architecture=$(uname -a)
red=$(echo -e "\033[31m")
normal=$(echo -e "\033[0m")
architecture_text=$(echo "$red Architecture: $normal")
pcpu=$(nproc --all)
pcpu_text=$(echo "$red CPU Physical: $normal")
vcpu=$(grep -c ^processoris /proc/cpuinfo | wc -l)
vcpu_text=$(echo "$red vCPU: $normal")
uram=$(free -m | awk '/^Mem:/ {print $3}')
maxram=$(free -m | awk '/^Mem:/ {print $2}')
pram=$((uram * 100 / maxram))
ram_text=$(echo "$red Memory Usage: $normal")
udisk=$(free -m | awk '/^Swap:/ {print $3}')
udisk_text=$(echo "$red Disk Usage $normal")
maxdisk=$(free -m | awk '/^Swap:/ {print $2}')
pdisk=$((udisk * 100 / maxdisk))
cpuload=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
cpuload_text=$(echo "$red CPU load: $normal")
last_reboot=$(who -b| awk '{print $3, $4}')
last_reboot_text=$(echo "$red Last boot: $normal")
lvmused=$(if [ $(lsblk |grep "lvm" | wc -l) > 0 ]; then echo yes; else echo no; fi)
lvmused_text=$(echo "$red LVM use: $normal")
active_connections=$(ss -ta | grep EST | wc -l)
active_connections_text=$(echo "$red Connections TCP: $normal")
user_counter=$(who |  wc -l)
user_counter_text=$(echo "$red User log $normal")
ip=$(hostname -I)
mac=$(ip link | grep "link/ether"| awk '{print $2}')
network_text=$(echo "$red Network: $normal")
sudoc=$(journalctl _COMM=sudo | grep COMMAND |wc -l)
sudoc_text=$(echo "$red Sudo: $normal")

wall "  $architecture_text $architecture
        $pcpu_text $pcpu
        $vcpu_text $vcpu
        $ram_text $uram/$maxram MB ($pram%)
        $udisk_text $udisk/$maxdisk G ($pdisk%)
        $cpuload_text $cpuload%
        $last_reboot_text $last_reboot
        $lvmused_text $lvmused
        $active_connections_text $active_connections ESTABLISHED
        $user_counter_text $user_counter
        $network_text IP $ip ($mac)
        $sudoc_text $sudoc cmd"
