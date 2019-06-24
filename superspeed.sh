#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE="\033[0;35m"
SKYBLUE='\033[0;36m'
PLAIN='\033[0m'

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


clear
# echo "测速节点更新日期: 2019/06/10"
echo "———————————————————————————————————————————————————————————————————"
echo "查看所有测速节点信息: "
echo "     https://github.com/ernisn/superspeed/blob/master/ServerList.md"
echo "———————————————————————————————————————————————————————————————————"
echo "是否进行全面测速? (失效的测速节点会自动跳过)"
echo -ne "1. 确认测速	2. 取消测速"

while :; do echo
        read -p "请输入数字选择: " telecom
        if [[ ! $telecom =~ ^[1-2]$ ]]; then
                echo "输入错误, 请输入正确的数字!"
        else
                break   
        fi
done

[[ ${telecom} == 2 ]] && exit 1

# install speedtest
if  [ ! -e '/tmp/speedtest.py' ]; then
    wget --no-check-certificate -P /tmp https://raw.github.com/sivel/speedtest-cli/master/speedtest.py > /dev/null 2>&1
fi
chmod a+rx /tmp/speedtest.py

speed_test(){
	temp=$(python /tmp/speedtest.py --server $1 --share 2>&1)
	is_down=$(echo "$temp" | grep 'Download') 
	if [[ ${is_down} ]]; then
        local REDownload=$(echo "$temp" | awk -F ':' '/Download/{print $2}')
        local reupload=$(echo "$temp" | awk -F ':' '/Upload/{print $2}')
        local relatency=$(echo "$temp" | awk -F ':' '/Hosted/{print $2}')
        temp=$(echo "$relatency" | awk -F '.' '{print $1}')
        if [[ ${temp} -gt 1000 ]]; then
            relatency=" > 1 s"
        fi
		local nodeID=$1
        local nodeName=$2

        printf "${PURPLE}%-8s${YELLOW}%-16s${GREEN}%-18s${RED}%-18s${SKYBLUE}%-10s${PLAIN}\n" "${nodeID}" "${nodeName}" "${reupload}" "${REDownload}" "${relatency}"
	else
        local cerror="ERROR"
	fi
}

if [[ ${telecom} == 1 ]]; then
	echo "———————————————————————————————————————————————————————————————————"
	printf "%-8s%-16s%-18s%-18s%-10s\n" "节点ID  " "节点名称     " "上传速度          " "下载速度          " "延迟"
	start=$(date +%s) 
    speed_test '6132' '长沙电信'
    speed_test '3633' '上海电信'
    speed_test '3973' '兰州电信'
    speed_test '4751' '北京电信'
    speed_test '5316' '南京电信'
    speed_test '10305' '南宁电信1'
    speed_test '22724' '南宁电信2'
    speed_test '10192' '南宁电信3'
    speed_test '16399' '南昌电信1'
    speed_test '6473' '南昌电信2'
    speed_test '6345' '南昌电信3'
    speed_test '7643' '南昌电信4'
    speed_test '17145' '合肥电信'
    speed_test '24012' '呼和浩特电信'
    speed_test '6714' '天津电信'
    speed_test '10775' '广州电信1'
    speed_test '9151' '广州电信2'
    speed_test '17251' '广州电信3'
    speed_test '5324' '徐州电信'
    speed_test '4624' '成都电信'
    speed_test '6168' '昆明电信'
    speed_test '7509' '杭州电信'
    speed_test '23844' '武汉电信1'
    speed_test '20038' '武汉电信2'
    speed_test '23665' '武汉电信3'
    speed_test '24011' '武汉电信4'
    speed_test '5081' '深圳电信'
    speed_test '5396' '苏州电信'
    speed_test '6435' '襄阳电信1'
    speed_test '12637' '襄阳电信2'
    speed_test '19918' '西宁电信'
    speed_test '5317' '连云港电信'
    speed_test '4595' '郑州电信'
    speed_test '21470' '鄂尔多斯电信'
    speed_test '19076' '重庆电信1'
    speed_test '6592' '重庆电信2'
    speed_test '16983' '重庆电信3'
    speed_test '5145' '北京联通1'
    speed_test '18462' '北京联通2'
    speed_test '5505' '北京联通3'
    speed_test '9484' '长春联通1'
    speed_test '10742' '长春联通2'
    speed_test '4870' '长沙联通'
    speed_test '2461' '成都联通'
    speed_test '5726' '重庆联通'
    speed_test '4884' '福州联通'
    speed_test '3891' '广州联通'
    speed_test '5985' '海口联通'
    speed_test '5300' '杭州联通'
    speed_test '5460' '哈尔滨联通'
    speed_test '5724' '合肥联通'
    speed_test '5465' '呼和浩特联通'
    speed_test '5039' '济南联通1'
    speed_test '12538' '济南联通2'
    speed_test '5103' '昆明联通'
    speed_test '4690' '兰州联通'
    speed_test '5750' '拉萨联通'
    speed_test '7230' '南昌联通1'
    speed_test '5097' '南昌联通2'
    speed_test '5446' '南京联通1'
    speed_test '13704' '南京联通2'
    speed_test '5674' '南宁联通'
    speed_test '6245' '宁波联通'
    speed_test '5509' '宁夏联通'
    speed_test '5710' '青岛联通'
    speed_test '21005' '上海联通1'
    speed_test '24447' '上海联通2'
    speed_test '5083' '上海联通3'
    speed_test '5017' '沈阳联通'
    speed_test '10201' '深圳联通'
    speed_test '19736' '太原联通1'
    speed_test '12868' '太原联通2'
    speed_test '12516' '太原联通3'
    speed_test '5475' '天津联通'
    speed_test '6144' '乌鲁木齐联通'
    speed_test '5485' '武汉联通'
    speed_test '5506' '厦门联通'
    speed_test '5992' '西宁联通'
    speed_test '5131' '郑州联通1'
    speed_test '6810' '郑州联通2'
    speed_test '17222' '阿勒泰移动'
    speed_test '17230' '阿拉善移动'
    speed_test '17227' '和田移动'
    speed_test '4665' '上海移动1'
    speed_test '16719' '上海移动2'
    speed_test '16803' '上海移动3'
    speed_test '17388' '临沂移动'
    speed_test '3784' '乌鲁木齐移动1'
    speed_test '16858' '乌鲁木齐移动2'
    speed_test '17228' '伊犁移动'
    speed_test '16145' '兰州移动'
    speed_test '4713' '北京移动'
    speed_test '21590' '南京移动'
    speed_test '15863' '南宁移动'
    speed_test '16294' '南昌移动1'
    speed_test '16332' '南昌移动2'
    speed_test '21530' '南通移动'
    speed_test '21642' '台州移动'
    speed_test '4377' '合肥移动'
    speed_test '17085' '呼和浩特移动'
    speed_test '17437' '哈尔滨移动'
    speed_test '10939' '商丘移动'
    speed_test '17245' '喀什移动'
    speed_test '17184' '天津移动'
    speed_test '16005' '太原移动'
    speed_test '6715' '宁波移动'
    speed_test '21722' '宿迁移动'
    speed_test '21845' '常州移动'
    speed_test '6611' '广州移动'
    speed_test '22349' '徐州移动'
    speed_test '24337' '成都移动1'
    speed_test '4575' '成都移动2'
    speed_test '21600' '扬州移动'
    speed_test '18444' '拉萨移动1'
    speed_test '17494' '拉萨移动2'
    speed_test '5122' '无锡移动1'
    speed_test '21973' '无锡移动2'
    speed_test '5892' '昆明移动'
    speed_test '4647' '杭州移动1'
    speed_test '12278' '杭州移动2'
    speed_test '16395' '武汉移动'
    speed_test '16167' '沈阳移动'
    speed_test '16314' '济南移动1'
    speed_test '17480' '济南移动2'
    speed_test '16503' '海口移动'
    speed_test '22037' '淮安移动'
    speed_test '4515' '深圳移动'
    speed_test '21946' '盐城移动'
    speed_test '17223' '石家庄移动'
    speed_test '16171' '福州移动'
    speed_test '3927' '苏州移动1'
    speed_test '21472' '苏州移动2'
    speed_test '18504' '西宁移动1'
    speed_test '16915' '西宁移动2'
    speed_test '16398' '贵阳移动1'
    speed_test '7404' '贵阳移动2'
    speed_test '21584' '连云港移动'
    speed_test '18970' '郑州移动1'
    speed_test '4486' '郑州移动2'
    speed_test '16409' '重庆移动1'
    speed_test '17584' '重庆移动2'
    speed_test '16392' '银川移动'
    speed_test '17320' '镇江移动'
    speed_test '16375' '长春移动'
    speed_test '15862' '长沙移动'
    speed_test '17432' '青岛移动'
	end=$(date +%s)  
	rm -rf /tmp/speedtest.py
	echo "———————————————————————————————————————————————————————————————————"
	time=$(( $end - $start ))
	if [[ $time -gt 60 ]]; then
		min=$(expr $time / 60)
		sec=$(expr $time % 60)
		echo -ne "测试完成, 本次测速耗时: ${min} 分 ${sec} 秒"
	else
		echo -ne "测试完成, 本次测速耗时: ${time} 秒"
	fi
	echo -ne "\n当前时间: "
    echo $(date +%Y-%m-%d" "%H:%M:%S)
fi
