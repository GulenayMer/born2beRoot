#!bin/bash
architecture=$(uname -a)
physical_cpu=$(nproc)
virtual_cpu=$(cat /proc/cpuinfo | grep processor | wc -l)
memory_total=$(free -m |grep Mem: | awk '{print $2}')
memory_used=$(free -m | grep Mem: | awk '{print $3}')
memory_used_percent=$(free -m | grep Mem: | awk '{printf("%.2f"), $3/$2*100}')
disk_total=$(df -h --total | grep total |  awk '{print $2}')
disk_used=$(df -h --total | grep total | awk '{print $3}')
disk_used_percent=$(df -h --total | grep total |  awk '{print $5}')
cpul=$(top -bn1 | grep Cpu | awk '{print $2}')
last_boot=$(who -b | awk '{print $3" "$4}')
lvm_total=$(lsblk | grep lvm | wc -l)

if [ $lvm_total -gt 0 ]
then
	lvm='yes'
else
	lvm='no'
fi

tcp_connections=$(ss | grep tcp | wc -l)
users_total=$(who -u | awk '{print $1}' | sort | uniq | wc -l)
ip=$(hostname -I)
mac=$(ip addr show | grep  link/ether/ | awk '{print $2}')
sudo_total=$(sudo grep sudo /var/log/auth.log | grep  COMMAND= | wc -l)

wall "
	#Architecture: $architecture
	#CPU physical : $physical_cpu
	#vCPU : $virtual_cpu
	#Memory Usage: $memory_used/${memory_total}MB (${memory_used_percent}%)
	#Disk Usage: $disk_used/${disk_total}GB (${disk_used_percent})
	#CPU load: $cpul%
	#Last boot: $last_boot
	#LVM use: $lvm
	#Connections TCP : $tcp_connections ESTABLISHED
	#User log: $users_total
	#Network: IP $ip ($mac)
	#Sudo : $sudo_total cmd
"
