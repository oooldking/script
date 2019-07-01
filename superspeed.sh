#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE="\033[0;35m"
CYAN='\033[0;36m'
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

echo "———————————————————————SuperSpeed 全面测速版———————————————————————"
echo "    使用方法:      bash <(curl -Lso- https://git.io/superspeed)"
echo "    查看全部节点:  https://git.io/superspeedList"
echo "    节点更新日期:  2019/07/02"
echo "———————————————————————————————————————————————————————————————————"
echo "是否进行全面测速?  (失效的测速节点会自动跳过)"
echo -ne "    1. 确认测速    2. 取消测速"

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
		local nodeLocation=$2
		local nodeISP=$3

		printf "${RED}%-8s${YELLOW}%-10s${GREEN}%-10s${CYAN}%-16s${BLUE}%-16s${PURPLE}%-10s${PLAIN}\n" "${nodeID}  " "${nodeISP}  " "${nodeLocation}  " "${reupload}  " "${REDownload}  " "${relatency}"
	else
		local cerror="ERROR"
	fi
}

if [[ ${telecom} == 1 ]]; then
	echo "———————————————————————————————————————————————————————————————————"
	printf "%-8s%-10s%-10s%-16s%-16s%-10s\n" "节点ID  " "运营商  " "位置     " "上传速度        " "下载速度        " "延迟"
	start=$(date +%s) 
	# 电信
	speed_test '6132' '长沙' '电信'
	speed_test '3633' '上海' '电信'
	speed_test '3973' '兰州' '电信'
	speed_test '4751' '北京' '电信'
	speed_test '5316' '南京' '电信'
	speed_test '10305' '南宁1' '电信'
	speed_test '22724' '南宁2' '电信'
	speed_test '10192' '南宁3' '电信'
	speed_test '16399' '南昌1' '电信'
	speed_test '6473' '南昌2' '电信'
	speed_test '6345' '南昌3' '电信'
	speed_test '7643' '南昌4' '电信'
	speed_test '17145' '合肥' '电信'
	speed_test '24012' '呼和浩特' '电信'
	speed_test '6714' '天津' '电信'
	speed_test '10775' '广州1' '电信'
	speed_test '9151' '广州2' '电信'
	speed_test '17251' '广州3' '电信'
	speed_test '5324' '徐州' '电信'
	speed_test '4624' '成都' '电信'
	speed_test '6168' '昆明' '电信'
	speed_test '7509' '杭州' '电信'
	speed_test '23844' '武汉1' '电信'
	speed_test '20038' '武汉2' '电信'
	speed_test '23665' '武汉3' '电信'
	speed_test '24011' '武汉4' '电信'
	speed_test '5081' '深圳' '电信'
	speed_test '5396' '苏州' '电信'
	speed_test '6435' '襄阳1' '电信'
	speed_test '12637' '襄阳2' '电信'
	speed_test '19918' '西宁' '电信'
	speed_test '5317' '连云港' '电信'
	speed_test '4595' '郑州' '电信'
	speed_test '21470' '鄂尔多斯' '电信'
	speed_test '19076' '重庆1' '电信'
	speed_test '6592' '重庆2' '电信'
	speed_test '16983' '重庆3' '电信'
	# 联通
	speed_test '5145' '北京1' '联通'
	speed_test '18462' '北京2' '联通'
	speed_test '5505' '北京3' '联通'
	speed_test '9484' '长春1' '联通'
	speed_test '10742' '长春2' '联通'
	speed_test '4870' '长沙' '联通'
	speed_test '2461' '成都' '联通'
	speed_test '5726' '重庆' '联通'
	speed_test '4884' '福州' '联通'
	speed_test '3891' '广州' '联通'
	speed_test '5985' '海口' '联通'
	speed_test '5300' '杭州' '联通'
	speed_test '5460' '哈尔滨' '联通'
	speed_test '5724' '合肥' '联通'
	speed_test '5465' '呼和浩特' '联通'
	speed_test '5039' '济南1' '联通'
	speed_test '12538' '济南2' '联通'
	speed_test '5103' '昆明' '联通'
	speed_test '4690' '兰州' '联通'
	speed_test '5750' '拉萨' '联通'
	speed_test '7230' '南昌1' '联通'
	speed_test '5097' '南昌2' '联通'
	speed_test '5446' '南京1' '联通'
	speed_test '13704' '南京2' '联通'
	speed_test '5674' '南宁' '联通'
	speed_test '6245' '宁波' '联通'
	speed_test '5509' '宁夏' '联通'
	speed_test '5710' '青岛' '联通'
	speed_test '21005' '上海1' '联通'
	speed_test '24447' '上海2' '联通'
	speed_test '5083' '上海3' '联通'
	speed_test '5017' '沈阳' '联通'
	speed_test '10201' '深圳' '联通'
	speed_test '19736' '太原1' '联通'
	speed_test '12868' '太原2' '联通'
	speed_test '12516' '太原3' '联通'
	speed_test '5475' '天津' '联通'
	speed_test '6144' '乌鲁木齐' '联通'
	speed_test '5485' '武汉' '联通'
	speed_test '5506' '厦门' '联通'
	speed_test '5992' '西宁' '联通'
	speed_test '5131' '郑州1' '联通'
	speed_test '6810' '郑州2' '联通'
	# 移动
	speed_test '4665' '上海1' '移动'
	speed_test '16719' '上海2' '移动'
	speed_test '16803' '上海3' '移动'
	speed_test '17388' '临沂' '移动'
	speed_test '3784' '乌鲁木齐1' '移动'
	speed_test '16858' '乌鲁木齐2' '移动'
	speed_test '17228' '伊犁' '移动'
	speed_test '16145' '兰州' '移动'
	speed_test '4713' '北京' '移动'
	speed_test '21590' '南京' '移动'
	speed_test '15863' '南宁' '移动'
	speed_test '16294' '南昌1' '移动'
	speed_test '16332' '南昌2' '移动'
	speed_test '21530' '南通' '移动'
	speed_test '21642' '台州' '移动'
	speed_test '4377' '合肥' '移动'
	speed_test '17085' '呼和浩特' '移动'
	speed_test '17437' '哈尔滨' '移动'
	speed_test '10939' '商丘' '移动'
	speed_test '17245' '喀什' '移动'
	speed_test '17184' '天津' '移动'
	speed_test '16005' '太原' '移动'
	speed_test '6715' '宁波' '移动'
	speed_test '21722' '宿迁' '移动'
	speed_test '21845' '常州' '移动'
	speed_test '6611' '广州' '移动'
	speed_test '22349' '徐州' '移动'
	speed_test '24337' '成都1' '移动'
	speed_test '4575' '成都2' '移动'
	speed_test '21600' '扬州' '移动'
	speed_test '18444' '拉萨1' '移动'
	speed_test '17494' '拉萨2' '移动'
	speed_test '5122' '无锡1' '移动'
	speed_test '21973' '无锡2' '移动'
	speed_test '5892' '昆明' '移动'
	speed_test '4647' '杭州1' '移动'
	speed_test '12278' '杭州2' '移动'
	speed_test '16395' '武汉' '移动'
	speed_test '16167' '沈阳' '移动'
	speed_test '16314' '济南1' '移动'
	speed_test '17480' '济南2' '移动'
	speed_test '16503' '海口' '移动'
	speed_test '22037' '淮安' '移动'
	speed_test '4515' '深圳' '移动'
	speed_test '21946' '盐城' '移动'
	speed_test '17223' '石家庄' '移动'
	speed_test '16171' '福州' '移动'
	speed_test '3927' '苏州1' '移动'
	speed_test '21472' '苏州2' '移动'
	speed_test '18504' '西宁1' '移动'
	speed_test '16915' '西宁2' '移动'
	speed_test '16398' '贵阳1' '移动'
	speed_test '7404' '贵阳2' '移动'
	speed_test '21584' '连云港' '移动'
	speed_test '18970' '郑州1' '移动'
	speed_test '4486' '郑州2' '移动'
	speed_test '16409' '重庆1' '移动'
	speed_test '17584' '重庆2' '移动'
	speed_test '16392' '银川' '移动'
	speed_test '17320' '镇江' '移动'
	speed_test '16375' '长春' '移动'
	speed_test '15862' '长沙' '移动'
	speed_test '17432' '青岛' '移动'
	speed_test '17222' '阿勒泰' '移动'
	speed_test '17230' '阿拉善' '移动'
	speed_test '17227' '和田' '移动'

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
