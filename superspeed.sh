#!/usr/bin/env bash
#
# Description: One step to test your server's network
#
# Copyright (C) 2017 - 2017 Oldking <oooldking@gmail.com>
#
# URL: https://www.oldking.net/305.html
#

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Error:${plain} This script must be run as root!" && exit 1

# check python
if  [ ! -e '/usr/bin/python' ]; then
        echo -e
        read -p "Error: python is not install. You must be install python command at first.\nDo you want to install? [y/n]" is_install
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
        read -p "Error: wget is not install. You must be install wget command at first.\nDo you want to install? [y/n]" is_install
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


clear
echo "#############################################################"
echo "# Description: Test your server's network with Speedtest   #"
echo "# Intro:  https://www.oldking.net/305.html                  #"
echo "# Author: Oldking <oooldking@gmail.com>                     #"
echo "# Github: https://github.com/oooldking                      #"
echo "#############################################################"
echo
echo "测试服务器到"
echo -ne "1.中国电信 2.中国联通 3.中国移动 4.本地默认"

# install speedtest
if  [ ! -e './speedtest.py' ]; then
    wget https://raw.github.com/sivel/speedtest-cli/master/speedtest.py > /dev/null 2>&1
fi
chmod a+rx speedtest.py

while :; do echo
        read -p "请输入数字选择： " telecom
        if [[ ! $telecom =~ ^[1-4]$ ]]; then
                echo "输入错误! 请输入正确的数字!"
        else
                break   
        fi
done

if [[ ${telecom} == 1 ]]; then
        telecomName="电信"
        echo -e "\n选择最靠近你的方位"
    echo -ne "1.北方 2.南方"
    while :; do echo
            read -p "请输入数字选择： " pos
            if [[ ! $pos =~ ^[1-2]$ ]]; then
                    echo "输入错误! 请输入正确的数字!"
            else
                    break
            fi
    done
    echo -e "\n选择最靠近你的城市"
    if [[ ${pos} == 1 ]]; then
        echo -ne "1.郑州 2.襄阳"
        while :; do echo
                read -p "请输入数字选择： " city
                if [[ ! $city =~ ^[1-2]$ ]]; then
                        echo "输入错误! 请输入正确的数字!"
                else
                        break
            fi
        done
        if [[ ${city} == 1 ]]; then
                num=4595
                cityName="郑州"
        fi
        if [[ ${city} == 2 ]]; then
                num=12637
                cityName="襄阳"
        fi
    fi
    if [[ ${pos} == 2 ]]; then
        echo -ne "1.上海 2.杭州 3.南宁 4.南昌 5.长沙 6.深圳 7.重庆 8.成都"
        while :; do echo
                read -p "请输入数字选择： " city
                if [[ ! $city =~ ^[1-8]$ ]]; then
                        echo "输入错误! 请输入正确的数字!"
                else
                        break
            fi
        done
        if [[ ${city} == 1 ]]; then
                num=3633
                cityName="上海"
        fi
        if [[ ${city} == 2 ]]; then
                num=7509
                cityName="杭州"
        fi
        if [[ ${city} == 3 ]]; then
                num=10305
                cityName="南宁"
        fi
        if [[ ${city} == 4 ]]; then
                num=7230
                cityName="南昌"
        fi
        if [[ ${city} == 5 ]]; then
                num=6132
                cityName="长沙"
        fi
        if [[ ${city} == 6 ]]; then
                num=5081
                cityName="深圳"
        fi
        if [[ ${city} == 7 ]]; then
                num=6592
                cityName="重庆"
        fi
        if [[ ${city} == 8 ]]; then
                num=4624
                cityName="成都"
        fi
    fi
fi

if [[ ${telecom} == 2 ]]; then
        telecomName="联通"
    echo -ne "\n1.北方 2.南方"
    while :; do echo
            read -p "请输入数字选择： " pos
            if [[ ! $pos =~ ^[1-2]$ ]]; then
                    echo "输入错误! 请输入正确的数字!"
            else
                    break
            fi
    done
    echo -e "\n选择最靠近你的城市"
    if [[ ${pos} == 1 ]]; then
        echo -ne "1.沈阳 2.长春 3.哈尔滨 4.天津 5.济南 6.北京 7.郑州 8.西安 9.太原 10.宁夏 11.兰州 12.西宁"
        while :; do echo
                read -p "请输入数字选择： " city
                if [[ ! $city =~ ^(([1-9])|(1([0-2]{1})))$ ]]; then
                        echo "输入错误! 请输入正确的数字!"
                else
                        break
            fi
        done
        if [[ ${city} == 1 ]]; then
                num=5017
                cityName="沈阳"
        fi
        if [[ ${city} == 2 ]]; then
                num=9484
                cityName="长春"
        fi
        if [[ ${city} == 3 ]]; then
                num=5460
                cityName="哈尔滨"
        fi
        if [[ ${city} == 4 ]]; then
                num=5475
                cityName="天津"
        fi
        if [[ ${city} == 5 ]]; then
                num=5039
                cityName="济南"
        fi
        if [[ ${city} == 6 ]]; then
                num=5145
                cityName="北京"
        fi
        if [[ ${city} == 7 ]]; then
                num=5131
                cityName="郑州"
        fi
        if [[ ${city} == 8 ]]; then
                num= 4863
                cityName="西安"
        fi
        if [[ ${city} == 9 ]]; then
                num=12868
                cityName="太原"
        fi
        if [[ ${city} == 10 ]]; then
                num=5509
                cityName="宁夏"
        fi
        if [[ ${city} == 11 ]]; then
                num=4690
                cityName="兰州"
        fi
        if [[ ${city} == 12 ]]; then
                num=5992
                cityName="西宁"
        fi
    fi
    if [[ ${pos} == 2 ]]; then
        echo -ne "1.上海 2.杭州 3.南宁 4.合肥 5.南昌 6.长沙 7.深圳 8.广州 9.重庆 10.成都 11.昆明"
        while :; do echo
                read -p "请输入数字选择： " city
                if [[ ! $city =~ ^(([1-9])|(1([0-1]{1})))$ ]]; then
                        echo "输入错误! 请输入正确的数字!"
                else
                        break
            fi
        done
        if [[ ${city} == 1 ]]; then
                num=5083
                cityName="上海"
        fi
        if [[ ${city} == 2 ]]; then
                num=5300
                cityName="杭州"
        fi
        if [[ ${city} == 3 ]]; then
                num=5674
                cityName="南宁"
        fi
        if [[ ${city} == 4 ]]; then
                num=5724
                cityName="合肥"
        fi
        if [[ ${city} == 5 ]]; then
                num=5079
                cityName="南昌"
        fi
        if [[ ${city} == 6 ]]; then
                num=4870
                cityName="长沙"
        fi
        if [[ ${city} == 7 ]]; then
                num=10201
                cityName="深圳"
        fi
        if [[ ${city} == 8 ]]; then
                num=3891
                cityName="广州"
        fi
        if [[ ${city} == 9 ]]; then
                num=5726
                cityName="重庆"
        fi
        if [[ ${city} == 10 ]]; then
                num=2461
                cityName="成都"
        fi
        if [[ ${city} == 11 ]]; then
                num=5103
                cityName="昆明"
        fi
    fi
fi

if [[ ${telecom} == 3 ]]; then
        telecomName="移动"
    echo -ne "\n1.北方 2.南方"
    while :; do echo
            read -p "请输入数字选择： " pos
            if [[ ! $pos =~ ^[1-2]$ ]]; then
                    echo "输入错误! 请输入正确的数字!"
            else
                    break
            fi
    done
    echo -e "\n选择最靠近你的城市"
    if [[ ${pos} == 1 ]]; then
        echo -ne "1.西安"
        while :; do echo
                read -p "请输入数字选择： " city
                if [[ ! $city =~ ^[1]$ ]]; then
                        echo "输入错误! 请输入正确的数字!"
                else
                        break
            fi
        done
        if [[ ${city} == 1 ]]; then
                num=5292
        fi
    fi
    if [[ ${pos} == 2 ]]; then
        echo -ne "1.上海 2.宁波 3.无锡 4.杭州 5.合肥 6.成都"
        while :; do echo
                read -p "请输入数字选择： " city
                if [[ ! $city =~ ^[1-6]$ ]]; then
                        echo "输入错误! 请输入正确的数字!"
                else
                        break
            fi
        done
        if [[ ${city} == 1 ]]; then
                num=4665
                cityName="上海"
        fi
        if [[ ${city} == 2 ]]; then
                num=6715
                cityName="宁波"
        fi
        if [[ ${city} == 3 ]]; then
                num=5122
                cityName="无锡"
        fi
        if [[ ${city} == 4 ]]; then
                num=4647
                cityName="杭州"
        fi
        if [[ ${city} == 5 ]]; then
                num=4377 
                cityName="合肥"
        fi
        if [[ ${city} == 6 ]]; then
                num=4575
                cityName="成都"
        fi
    fi
fi

result() {
    download=`cat speed.log | awk -F ':' '/Download/{print $2}'`
    upload=`cat speed.log | awk -F ':' '/Upload/{print $2}'`
    hostby=`cat speed.log | awk -F ':' '/Hosted/{print $1}'`
    latency=`cat speed.log | awk -F ':' '/Hosted/{print $2}'`
    rm -rf speedtest.py
    rm -rf speed.log
    clear
    echo "$hostby"
    echo "延迟  : $latency"
    echo "上传  : $download"
    echo "下载  : $upload"
    echo -ne "\n当前时间: "
    echo $(date +%Y-%m-%d" "%H:%M:%S)
}

if [[ ${telecom} =~ ^[1-3]$ ]]; then
        python speedtest.py --server ${num} --share | tee speed.log
    result
    echo "测试到 ${cityName}${telecomName} 完成！"
fi

if [[ ${telecom} == 4 ]]; then
        python speedtest.py --server ${num} --share | tee speed.log
    result
        echo "本地测试完成！"
fi