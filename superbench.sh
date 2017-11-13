#!/usr/bin/env bash
#
# Description: Auto test download & I/O speed & network to China script
#
# Copyright (C) 2017 - 2017 Oldking <oooldking@gmail.com>
#
# Thanks: Bench.sh <i@teddysun.com>
#
# URL: https://www.oldking.net/350.html
#

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
SKYBLUE='\033[0;36m'
PLAIN='\033[0m'

# check release
if [ -f /etc/redhat-release ]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
fi

# check root
[[ $EUID -ne 0 ]] && echo -e "${RED}Error:${PLAIN} This script must be run as root!" && exit 1

# check python
if  [ ! -e '/usr/bin/python' ]; then
        echo -e
        read -p "${RED}Error:${PLAIN} python is not install. You must be install python command at first.\nDo you want to install? [y/n]" is_install
        if [[ ${is_install} == "y" || ${is_install} == "Y" ]]; then
            if [ "${release}" == "centos" ]; then
                        yum -y install python
                else
                        apt-get -y install python
                fi
        else
            exit
        fi
        
fi

# check wget
if  [ ! -e '/usr/bin/wget' ]; then
        echo -e
        read -p "${RED}Error:${PLAIN} wget is not install. You must be install wget command at first.\nDo you want to install? [y/n]" is_install
        if [[ ${is_install} == "y" || ${is_install} == "Y" ]]; then
                if [ "${release}" == "centos" ]; then
                        yum -y install wget
                else
                        apt-get -y install wget
                fi
        else
                exit
        fi
fi

get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

speed_test(){
	if [[ $1 == '' ]]; then
		temp=$(python speedtest.py --share 2>&1)
		is_down=$(echo "$temp" | grep 'Download') 
		if [[ ${is_down} ]]; then
	        local REDownload=$(echo "$temp" | awk -F ':' '/Download/{print $2}')
	        local reupload=$(echo "$temp" | awk -F ':' '/Upload/{print $2}')
	        local relatency=$(echo "$temp" | awk -F ':' '/Hosted/{print $2}')
	        local nodeName=$2

	        printf "${YELLOW}%-17s${GREEN}%-18s${RED}%-20s${SKYBLUE}%-12s${PLAIN}\n" "${nodeName}" "${reupload}" "${REDownload}" "${relatency}"
		else
	        local cerror="ERROR"
		fi
	else
		temp=$(python speedtest.py --server $1 --share 2>&1)
		is_down=$(echo "$temp" | grep 'Download') 
		if [[ ${is_down} ]]; then
	        local REDownload=$(echo "$temp" | awk -F ':' '/Download/{print $2}')
	        local reupload=$(echo "$temp" | awk -F ':' '/Upload/{print $2}')
	        local relatency=$(echo "$temp" | awk -F ':' '/Hosted/{print $2}')
	        temp=$(echo "$relatency" | awk -F '.' '{print $1}')
        	if [[ ${temp} -gt 1000 ]]; then
            	relatency=" 000.000 ms"
        	fi
	        local nodeName=$2

	        printf "${YELLOW}%-17s${GREEN}%-18s${RED}%-20s${SKYBLUE}%-12s${PLAIN}\n" "${nodeName}" "${reupload}" "${REDownload}" "${relatency}"
		else
	        local cerror="ERROR"
		fi
	fi
}

speed() {
	# install speedtest
	if  [ ! -e './speedtest.py' ]; then
	    wget https://raw.github.com/sivel/speedtest-cli/master/speedtest.py > /dev/null 2>&1
	fi
	chmod a+rx speedtest.py

    speed_test '' 'Normal Node'
	speed_test '12637' 'Xiangyang CT'
	speed_test '3633' 'Shanghai  CT'
	speed_test '4624' 'Chengdu   CT'
	speed_test '4863' "Xi'an     CU"
	speed_test '5083' 'Shanghai  CU'
	speed_test '5726' 'Chongqing CU'
	speed_test '5192' "Xi'an     CM"
	speed_test '4665' 'Shanghai  CM'
	speed_test '4575' 'Chengdu   CM'
	 
	rm -rf speedtest.py
}


io_test() {
    (LANG=C dd if=/dev/zero of=test_$$ bs=$1 count=$2 conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

calc_disk() {
    local total_size=0
    local array=$@
    for size in ${array[@]}
    do
        [ "${size}" == "0" ] && size_t=0 || size_t=`echo ${size:0:${#size}-1}`
        [ "`echo ${size:(-1)}`" == "K" ] && size=0
        [ "`echo ${size:(-1)}`" == "M" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' / 1024}' )
        [ "`echo ${size:(-1)}`" == "T" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' * 1024}' )
        [ "`echo ${size:(-1)}`" == "G" ] && size=${size_t}
        total_size=$( awk 'BEGIN{printf "%.1f", '$total_size' + '$size'}' )
    done
    echo ${total_size}
}

power_time() {

	result=$(smartctl -a $(result=$(cat /proc/mounts) && echo $(echo "$result" | awk '/data=ordered/{print $1}') | awk '{print $1}') 2>&1) && power_time=$(echo "$result" | awk '/Power_On/{print $10}') && echo "$power_time"
}

install_smart() {
	# install smartctl
	if  [ ! -e '/usr/sbin/smartctl' ]; then
	    if [ "${release}" == "centos" ]; then
	        yum -y install smartmontools > /dev/null 2>&1
	    else
	        apt-get -y install smartmontools > /dev/null 2>&1
	    fi      
	fi
}

start=$(date +%s) 

cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
tram=$( free -m | awk '/Mem/ {print $2}' )
uram=$( free -m | awk '/Mem/ {print $3}' )
swap=$( free -m | awk '/Swap/ {print $2}' )
uswap=$( free -m | awk '/Swap/ {print $3}' )
up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days %d hour %d min\n",a,b,c)}' /proc/uptime )
load=$( w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
opsy=$( get_opsy )
arch=$( uname -m )
lbit=$( getconf LONG_BIT )
kern=$( uname -r )
ipv6=$( wget -qO- -t1 -T2 ipv6.icanhazip.com )
disk_size1=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $2}' ))
disk_size2=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $3}' ))
disk_total_size=$( calc_disk ${disk_size1[@]} )
disk_used_size=$( calc_disk ${disk_size2[@]} )
ptime=$(power_time)


clear
next
echo -e "CPU model            : ${SKYBLUE}$cname${PLAIN}"
echo -e "Number of cores      : ${SKYBLUE}$cores${PLAIN}"
echo -e "CPU frequency        : ${SKYBLUE}$freq MHz${PLAIN}"
echo -e "Total size of Disk   : ${SKYBLUE}$disk_total_size GB ($disk_used_size GB Used)${PLAIN}"
echo -e "Total amount of Mem  : ${SKYBLUE}$tram MB ($uram MB Used)${PLAIN}"
echo -e "Total amount of Swap : ${SKYBLUE}$swap MB ($uswap MB Used)${PLAIN}"
echo -e "System uptime        : ${SKYBLUE}$up${PLAIN}"
echo -e "Load average         : ${SKYBLUE}$load${PLAIN}"
echo -e "OS                   : ${SKYBLUE}$opsy${PLAIN}"
echo -e "Arch                 : ${SKYBLUE}$arch ($lbit Bit)${PLAIN}"
echo -e "Kernel               : ${SKYBLUE}$kern${PLAIN}"
echo -ne "Virt                 : "

# install virt-what
if  [ ! -e '/usr/sbin/virt-what' ]; then
    if [ "${release}" == "centos" ]; then
    	yum update > /dev/null 2>&1
        yum -y install virt-what > /dev/null 2>&1
    else
    	apt-get update > /dev/null 2>&1
        apt-get -y install virt-what > /dev/null 2>&1
    fi      
fi
virtua=$(virt-what)

if [[ ${virtua} ]]; then
	echo -e "${SKYBLUE}$virtua${PLAIN}"
else
	echo -e "${SKYBLUE}No Virt${PLAIN}"
	echo -ne "Power time of disk   : "
	install_smart
	echo -e "${SKYBLUE}$ptime Hours${PLAIN}"
fi
next
echo -n "I/O speed( 32M )     : "
io1=$( io_test 32k 1k )
echo -e "${YELLOW}$io1${PLAIN}"
echo -n "I/O speed( 256M )    : "
io2=$( io_test 64k 4k )
echo -e "${YELLOW}$io2${PLAIN}"
echo -n "I/O speed( 2G )      : "
io3=$( io_test 64k 32k )
echo -e "${YELLOW}$io3${PLAIN}"
ioraw1=$( echo $io1 | awk 'NR==1 {print $1}' )
[ "`echo $io1 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw1=$( awk 'BEGIN{print '$ioraw1' * 1024}' )
ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
[ "`echo $io2 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw2=$( awk 'BEGIN{print '$ioraw2' * 1024}' )
ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
[ "`echo $io3 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw3=$( awk 'BEGIN{print '$ioraw3' * 1024}' )
ioall=$( awk 'BEGIN{print '$ioraw1' + '$ioraw2' + '$ioraw3'}' )
ioavg=$( awk 'BEGIN{printf "%.1f", '$ioall' / 3}' )
echo -e "Average I/O speed    : ${YELLOW}$ioavg MB/s${PLAIN}"
next
printf "%-18s%-18s%-20s%-12s\n" "Node Name" "Upload Speed" "Download Speed" "Latency"
speed && next
end=$(date +%s) 
time=$(( $end - $start ))
if [[ $time -gt 60 ]]; then
	min=$(expr $time / 60)
	sec=$(expr $time % 60)
	echo -ne "Total time   : ${min} min ${sec} sec"
else
	echo -ne "Total time   : ${time} sec"
fi
echo -ne "\nCurrent time : "
echo $(date +%Y-%m-%d" "%H:%M:%S)
echo "Finished！"
next