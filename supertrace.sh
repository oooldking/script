#!/usr/bin/env bash
#
# Description: Auto Traceroute to China Network
#
# Copyright (C) 2022 Oldking <oooldking@gmail.com>
#
# Thanks: Besttrace
#
# URL: https://www.oldking.net/1360.html
#

# Color
SKYBLUE='\033[0;36m'
GREEN='\033[0;32m'
PLAIN='\033[0m'

# Version
VERSION=1.0.0

# Define ip address & location name
ipAddr=(106.37.68.26 202.96.18.1 211.136.66.129 210.31.160.77 101.95.89.90 219.158.111.253 221.183.89.46 202.112.27.18 219.135.131.210 210.21.11.1 211.136.192.6 202.112.19.9)
locName=(北京电信 北京联通 北京移动 北京教育 上海电信 上海联通 上海移动 上海教育 广州电信 广州联通 广州移动 广州教育)

about() {
    echo ""
    echo " ========================================================= "
    echo " \                 SuperTrace.sh  Script                 / "
    echo " \           Auto Traceroute to China Network            / "
    echo " \                   Created by Oldking                  / "
    echo " ========================================================= "
    echo ""
    echo " Intro: https://www.oldking.net/1360.html"
    echo " Copyright (C) 2022 Oldking oooldking@gmail.com"
    echo -e " Version: ${GREEN}v$VERSION${PLAIN} (1 Dec 2022)"
    echo -e " ${SKYBLUE}Usage : wget -qO- oldking.net/supertrace.sh | bash${PLAIN}"
    echo ""
}

cancel() {
    echo ""
    next;
    echo " Abort ..."
    echo " Cleanup ..."
    cleanup;
    echo " Done"
    exit
}

trap cancel SIGINT

# define "---"
next() {
    printf "%-20s\n" "-" | sed 's/\s/-/g'
}

init() {
    # Check OS
    arch=$( uname -m )

    # install besttrace
    echo " Loading supertrace..."
    echo ""
    echo -e "${SKYBLUE}START${PLAIN}"
    case ${arch} in
    x86_64 )
        wget -qO supertrace https://github.com/oooldking/script/raw/master/supertrace/besttrace/besttrace;;
    aarch64) 
        wget -qO supertrace https://github.com/oooldking/script/raw/master/supertrace/besttrace/besttracearm;;
    esac
    chmod +x supertrace

    start=$(date +%s)  
}

clear

## start to use besttrace
trace() {
    for i in {0..11}
    do
        next
        echo -e "${SKYBLUE}Round $((i+1)) - SuperTrace 路由到 - ${locName[$i]}${PLAIN}"
        next
        ./supertrace -q 1 ${ipAddr[$i]}
        echo ""
        echo ""
    done
}

print_end_time() {
    end=$(date +%s) 
    time=$(( $end - $start ))
    if [[ $time -gt 60 ]]; then
        min=$(expr $time / 60)
        sec=$(expr $time % 60)
        echo -ne "Finished in  : ${min} min ${sec} sec" | tee -a $log
    else
        echo -ne "Finished in  : ${time} sec" | tee -a $log
    fi

    printf '\n' | tee -a $log

    bj_time=$(curl -s http://cgi.im.qq.com/cgi-bin/cgi_svrtime)

    if [[ $(echo $bj_time | grep "html") ]]; then
        bj_time=$(date -u +%Y-%m-%d" "%H:%M:%S -d '+8 hours')
    fi
    echo -e "Timestamp    : $bj_time GMT+8" | tee -a $log
    echo -e "${SKYBLUE}End${PLAIN}"
}

cleanup() {
    rm -f supertrace*
}

about
init
trace
print_end_time
