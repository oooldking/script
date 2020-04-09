#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE="\033[0;35m"
CYAN='\033[0;36m'
PLAIN='\033[0m'

checkroot(){
	[[ $EUID -ne 0 ]] && echo -e "${RED}请使用 root 用户运行本脚本！${PLAIN}" && exit 1
}

checksystem() {
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
}

checkpython() {
	if  [ ! -e '/usr/bin/python' ]; then
	        echo "正在安装 Python"
	            if [ "${release}" == "centos" ]; then
	            		yum update > /dev/null 2>&1
	                    yum -y install python > /dev/null 2>&1
	                else
	                	apt-get update > /dev/null 2>&1
	                    apt-get -y install python > /dev/null 2>&1
	                fi
	        
	fi
}

checkcurl() {
	if  [ ! -e '/usr/bin/curl' ]; then
	        echo "正在安装 Curl"
	            if [ "${release}" == "centos" ]; then
	                yum update > /dev/null 2>&1
	                yum -y install curl > /dev/null 2>&1
	            else
	                apt-get update > /dev/null 2>&1
	                apt-get -y install curl > /dev/null 2>&1
	            fi
	fi
}

checkwget() {
	if  [ ! -e '/usr/bin/wget' ]; then
	        echo "正在安装 Wget"
	            if [ "${release}" == "centos" ]; then
	                yum update > /dev/null 2>&1
	                yum -y install wget > /dev/null 2>&1
	            else
	                apt-get update > /dev/null 2>&1
	                apt-get -y install wget > /dev/null 2>&1
	            fi
	fi
}

checkspeedtest() {
	if  [ ! -e './speedtest-cli/speedtest' ]; then
		echo "正在安装 Speedtest-cli"
		wget --no-check-certificate -qO speedtest.tgz https://cdn.jsdelivr.net/gh/oooldking/script@1.1.7/speedtest_cli/ookla-speedtest-1.0.0-$(uname -m)-linux.tgz > /dev/null 2>&1
	fi
	mkdir -p speedtest-cli && tar zxvf speedtest.tgz -C ./speedtest-cli/ > /dev/null 2>&1 && chmod a+rx ./speedtest-cli/speedtest
}

speed_test(){
	speedLog="./speedtest.log"
	true > $speedLog
		speedtest-cli/speedtest -p no -s $1 --accept-license > $speedLog 2>&1
		is_upload=$(cat $speedLog | grep 'Upload')
		if [[ ${is_upload} ]]; then
	        local REDownload=$(cat $speedLog | awk -F ' ' '/Download/{print $3}')
	        local reupload=$(cat $speedLog | awk -F ' ' '/Upload/{print $3}')
	        local relatency=$(cat $speedLog | awk -F ' ' '/Latency/{print $2}')
	        
			local nodeID=$1
			local nodeLocation=$2
			local nodeISP=$3
			
			strnodeLocation="${nodeLocation}　　　　　　"
			LANG=C
			#echo $LANG
			
			temp=$(echo "${REDownload}" | awk -F ' ' '{print $1}')
	        if [[ $(awk -v num1=${temp} -v num2=0 'BEGIN{print(num1>num2)?"1":"0"}') -eq 1 ]]; then
	        	printf "${RED}%-6s${YELLOW}%s%s${GREEN}%-24s${CYAN}%s%-10s${BLUE}%s%-10s${PURPLE}%-8s${PLAIN}\n" "${nodeID}"  "${nodeISP}" "|" "${strnodeLocation:0:24}" "↑ " "${reupload}" "↓ " "${REDownload}" "${relatency}" | tee -a $log
			fi
		else
	        local cerror="ERROR"
		fi
}

preinfo() {
	echo "———————————————————SuperSpeed 全面测速版——————————————————"
	echo "       bash <(curl -Lso- https://git.io/superspeed)"
	echo "       全部节点列表:  https://git.io/superspeedList"
	echo "       节点更新: 2019/12/23  | 脚本更新: 2020/04/09"
	echo "——————————————————————————————————————————————————————————"
}

selecttest() {
	echo -e "  选择测速类型:      ${GREEN}1.${PLAIN} 三网测速         ${GREEN}3.${PLAIN} 电信节点测速"
	echo -e "                     ${GREEN}2.${PLAIN} 取消本次测速     ${GREEN}4.${PLAIN} 联通节点测速"
	echo -ne "                                         ${GREEN}5.${PLAIN} 移动节点测速"
	while :; do echo
			read -p "  请输入数字选择: " selection
			if [[ ! $selection =~ ^[1-5]$ ]]; then
					echo -ne "  ${RED}输入错误${PLAIN}, 请输入正确的数字!"
			else
					break   
			fi
	done
}

runtest() {
	[[ ${selection} == 2 ]] && exit 1

	if [[ ${selection} == 1 ]]; then
		echo "——————————————————————————————————————————————————————————"
		echo "ID    测速服务器信息       上传/Mbps   下载/Mbps   延迟/ms"
		start=$(date +%s) 

		 speed_test '3633' '上海' '电信'
		 speed_test '28139' '上海５Ｇ' '电信'
		 speed_test '6168' '云南昆明' '电信'
		 speed_test '27539' '云南昆明５Ｇ' '电信'
		 speed_test '24012' '内蒙古呼和浩特' '电信'
		 speed_test '21470' '内蒙古鄂尔多斯' '电信'
		# speed_test '4751' '北京' '电信'
		 speed_test '27377' '北京５Ｇ' '电信'
		 speed_test '4624' '四川成都' '电信'
		 speed_test '6714' '天津' '电信'
		 speed_test '17145' '安徽合肥' '电信'
		# speed_test '9151' '广东广州' '电信'
		# speed_test '10775' '广东广州' '电信'
		# speed_test '17251' '广东广州' '电信'
		 speed_test '27594' '广东广州５Ｇ' '电信'
		 speed_test '5081' '广东深圳' '电信'
		 speed_test '10192' '广西南宁' '电信'
		 speed_test '10305' '广西南宁' '电信'
		 speed_test '22724' '广西南宁' '电信'
		 speed_test '27810' '广西南宁' '电信'
		 speed_test '27304' '新疆乌鲁木齐' '电信'
		 speed_test '27575' '新疆乌鲁木齐' '电信'
		# speed_test '5316' '江苏南京' '电信'
		 speed_test '26352' '江苏南京５Ｇ' '电信'
		 speed_test '5324' '江苏徐州' '电信'
		 speed_test '5396' '江苏苏州' '电信'
		# speed_test '5317' '江苏连云港' '电信'
		 speed_test '6345' '江西南昌' '电信'
		 speed_test '6473' '江西南昌' '电信'
		 speed_test '7643' '江西南昌' '电信'
		 speed_test '16399' '江西南昌' '电信'
		 speed_test '4595' '河南郑州' '电信'
		 speed_test '7509' '浙江杭州' '电信'
		 speed_test '20038' '湖北武汉' '电信'
		 speed_test '23665' '湖北武汉' '电信'
		 speed_test '23844' '湖北武汉' '电信'
		 speed_test '24011' '湖北武汉' '电信'
		 speed_test '6435' '湖北襄阳' '电信'
		 speed_test '12637' '湖北襄阳' '电信'
		 speed_test '6132' '湖南长沙' '电信'
		 speed_test '28225' '湖南长沙' '电信'
		 speed_test '3973' '甘肃兰州' '电信'
		 speed_test '6592' '重庆' '电信'
		 speed_test '16983' '重庆' '电信'
		 speed_test '19076' '重庆' '电信'
		 speed_test '19918' '青海西宁' '电信'

		# speed_test '5083' '上海' '联通'
		# speed_test '21005' '上海' '联通'
		 speed_test '24447' '上海５Ｇ' '联通'
		 speed_test '5103' '云南昆明' '联通'
		 speed_test '5465' '内蒙古呼和浩特' '联通'
		 speed_test '5145' '北京' '联通'
		# speed_test '5505' '北京' '联通'
		# speed_test '18462' '北京' '联通'
		 speed_test '9484' '吉林长春' '联通'
		# speed_test '10742' '吉林长春' '联通'
		 speed_test '2461' '四川成都' '联通'
		# speed_test '5475' '天津' '联通'
		 speed_test '27154' '天津５Ｇ' '联通'
		# speed_test '5509' '宁夏' '联通'
		 speed_test '5724' '安徽合肥' '联通'
		# speed_test '5039' '山东济南' '联通'
		# speed_test '12538' '山东济南' '联通'
		 speed_test '26180' '山东济南５Ｇ' '联通'
		# speed_test '5710' '山东青岛' '联通'
		 speed_test '12516' '山西太原' '联通'
		 speed_test '12868' '山西太原' '联通'
		 speed_test '19736' '山西太原' '联通'
		# speed_test '3891' '广东广州' '联通'
		 speed_test '26678' '广东广州５Ｇ' '联通'
		 speed_test '10201' '广东深圳' '联通'
		 speed_test '5674' '广西南宁' '联通'
		 speed_test '6144' '新疆乌鲁木齐' '联通'
		 speed_test '5446' '江苏南京' '联通'
		 speed_test '13704' '江苏南京' '联通'
		 speed_test '5097' '江西南昌' '联通'
		 speed_test '7230' '江西南昌' '联通'
		 speed_test '5131' '河南郑州' '联通'
		 speed_test '6810' '河南郑州' '联通'
		 speed_test '6245' '浙江宁波' '联通'
		 speed_test '5300' '浙江杭州' '联通'
		 speed_test '5985' '海南海口' '联通'
		 speed_test '5485' '湖北武汉' '联通'
		# speed_test '26677' '湖南株洲' '联通'
		# speed_test '4870' '湖南长沙' '联通'
		 speed_test '4690' '甘肃兰州' '联通'
		 speed_test '5506' '福建厦门' '联通'
		 speed_test '4884' '福建福州' '联通'
		 speed_test '5750' '西藏拉萨' '联通'
		 speed_test '5017' '辽宁沈阳' '联通'
		 speed_test '5726' '重庆' '联通'
		 speed_test '5992' '青海西宁' '联通'
		 speed_test '5460' '黑龙江哈尔滨' '联通'

		# speed_test '4665' '上海' '移动'
		# speed_test '16719' '上海' '移动'
		# speed_test '16803' '上海' '移动'
		 speed_test '25637' '上海５Ｇ' '移动'
		# speed_test '5892' '云南昆明' '移动'
		# speed_test '26728' '云南昆明' '移动'
		# speed_test '17085' '内蒙古呼和浩特' '移动'
		# speed_test '27019' '内蒙古呼和浩特' '移动'
		# speed_test '17230' '内蒙古阿拉善' '移动'
		# speed_test '4713' '北京' '移动'
		# speed_test '25858' '北京' '移动'
		 speed_test '16375' '吉林长春' '移动'
		# speed_test '4575' '四川成都' '移动'
		 speed_test '24337' '四川成都' '移动'
		# speed_test '28211' '四川成都' '移动'
		 speed_test '17184' '天津' '移动'
		# speed_test '16392' '宁夏银川' '移动'
		# speed_test '26940' '宁夏银川' '移动'
		# speed_test '4377' '安徽合肥' '移动'
		# speed_test '26404' '安徽合肥' '移动'
		# speed_test '17388' '山东临沂' '移动'
		# speed_test '16314' '山东济南' '移动'
		# speed_test '17480' '山东济南' '移动'
		 speed_test '25881' '山东济南' '移动'
		# speed_test '17432' '山东青岛' '移动'
		# speed_test '16005' '山西太原' '移动'
		# speed_test '6611' '广东广州' '移动'
		 speed_test '4515' '广东深圳' '移动'
		 speed_test '15863' '广西南宁' '移动'
		# speed_test '3784' '新疆乌鲁木齐' '移动'
		# speed_test '16858' '新疆乌鲁木齐' '移动'
		 speed_test '26938' '新疆乌鲁木齐５Ｇ' '移动'
		# speed_test '17228' '新疆伊犁' '移动'
		# speed_test '17227' '新疆和田' '移动'
		# speed_test '17245' '新疆喀什' '移动'
		# speed_test '17222' '新疆阿勒泰' '移动'
		# speed_test '21590' '江苏南京' '移动'
		# speed_test '27249' '江苏南京５Ｇ' '移动'
		# speed_test '21530' '江苏南通' '移动'
		# speed_test '21722' '江苏宿迁' '移动'
		# speed_test '21845' '江苏常州' '移动'
		# speed_test '22349' '江苏徐州' '移动'
		# speed_test '21600' '江苏扬州' '移动'
		# speed_test '5122' '江苏无锡' '移动'
		# speed_test '21973' '江苏无锡' '移动'
		# speed_test '26850' '江苏无锡５Ｇ' '移动'
		# speed_test '21642' '江苏泰州' '移动'
		# speed_test '22037' '江苏淮安' '移动'
		# speed_test '21946' '江苏盐城' '移动'
		# speed_test '3927' '江苏苏州' '移动'
		# speed_test '21472' '江苏苏州' '移动'
		# speed_test '21584' '江苏连云港' '移动'
		# speed_test '17320' '江苏镇江' '移动'
		# speed_test '16294' '江西南昌' '移动'
		# speed_test '16332' '江西南昌' '移动'
		# speed_test '25883' '江西南昌' '移动'
		# speed_test '17223' '河北石家庄' '移动'
		# speed_test '10939' '河南商丘' '移动'
		# speed_test '4486' '河南郑州' '移动'
		# speed_test '18970' '河南郑州' '移动'
		# speed_test '26331' '河南郑州５Ｇ' '移动'
		 speed_test '6715' '浙江宁波' '移动'
		# speed_test '4647' '浙江杭州' '移动'
		# speed_test '12278' '浙江杭州' '移动'
		 speed_test '16503' '海南海口' '移动'
		# speed_test '16395' '湖北武汉' '移动'
		# speed_test '26357' '湖北武汉' '移动'
		# speed_test '26547' '湖北武汉' '移动'
		# speed_test '15862' '湖南长沙' '移动'
		# speed_test '28491' '湖南长沙５Ｇ' '移动'
		# speed_test '16145' '甘肃兰州' '移动'
		# speed_test '16171' '福建福州' '移动'
		# speed_test '17494' '西藏拉萨' '移动'
		# speed_test '18444' '西藏拉萨' '移动'
		# speed_test '7404' '贵州贵阳' '移动'
		 speed_test '16398' '贵州贵阳' '移动'
		# speed_test '25728' '辽宁大连' '移动'
		# speed_test '16167' '辽宁沈阳' '移动'
		# speed_test '16409' '重庆' '移动'
		 speed_test '17584' '重庆' '移动'
		# speed_test '26380' '陕西西安' '移动'
		# speed_test '16915' '青海西宁' '移动'
		# speed_test '18504' '青海西宁' '移动'
		 speed_test '29083' '青海西宁５Ｇ' '移动'
		# speed_test '17437' '黑龙江哈尔滨' '移动'
		 speed_test '26656' '黑龙江哈尔滨５Ｇ' '移动'

		end=$(date +%s)  
		rm -rf speedtest*
		echo "——————————————————————————————————————————————————————————"
		time=$(( $end - $start ))
		if [[ $time -gt 60 ]]; then
			min=$(expr $time / 60)
			sec=$(expr $time % 60)
			echo -ne "  测试完成, 本次测速耗时: ${min} 分 ${sec} 秒"
		else
			echo -ne "  测试完成, 本次测速耗时: ${time} 秒"
		fi
		echo -ne "\n  当前时间: "
		echo $(date +%Y-%m-%d" "%H:%M:%S)
		echo -e "  ${GREEN}# 三网测速中为避免节点数不均及测试过久，每部分未使用所${PLAIN}"
		echo -e "  ${GREEN}# 有节点，如果需要使用全部节点，可分别选择三网节点检测${PLAIN}"
	fi

	if [[ ${selection} == 3 ]]; then
		echo "——————————————————————————————————————————————————————————"
		echo "ID    测速服务器信息       上传/Mbps   下载/Mbps   延迟/ms"
		start=$(date +%s) 

		 speed_test '3633' '上海' '电信'
		 speed_test '28139' '上海５Ｇ' '电信'
		 speed_test '6168' '云南昆明' '电信'
		 speed_test '27539' '云南昆明５Ｇ' '电信'
		 speed_test '24012' '内蒙古呼和浩特' '电信'
		 speed_test '21470' '内蒙古鄂尔多斯' '电信'
		 speed_test '4751' '北京' '电信'
		 speed_test '27377' '北京５Ｇ' '电信'
		 speed_test '4624' '四川成都' '电信'
		 speed_test '6714' '天津' '电信'
		 speed_test '17145' '安徽合肥' '电信'
		 speed_test '9151' '广东广州' '电信'
		 speed_test '10775' '广东广州' '电信'
		 speed_test '17251' '广东广州' '电信'
		 speed_test '27594' '广东广州５Ｇ' '电信'
		 speed_test '5081' '广东深圳' '电信'
		 speed_test '10192' '广西南宁' '电信'
		 speed_test '10305' '广西南宁' '电信'
		 speed_test '22724' '广西南宁' '电信'
		 speed_test '27810' '广西南宁' '电信'
		 speed_test '27304' '新疆乌鲁木齐' '电信'
		 speed_test '27575' '新疆乌鲁木齐' '电信'
		 speed_test '5316' '江苏南京' '电信'
		 speed_test '26352' '江苏南京５Ｇ' '电信'
		 speed_test '5324' '江苏徐州' '电信'
		 speed_test '5396' '江苏苏州' '电信'
		 speed_test '5317' '江苏连云港' '电信'
		 speed_test '6345' '江西南昌' '电信'
		 speed_test '6473' '江西南昌' '电信'
		 speed_test '7643' '江西南昌' '电信'
		 speed_test '16399' '江西南昌' '电信'
		 speed_test '4595' '河南郑州' '电信'
		 speed_test '7509' '浙江杭州' '电信'
		 speed_test '20038' '湖北武汉' '电信'
		 speed_test '23665' '湖北武汉' '电信'
		 speed_test '23844' '湖北武汉' '电信'
		 speed_test '24011' '湖北武汉' '电信'
		 speed_test '6435' '湖北襄阳' '电信'
		 speed_test '12637' '湖北襄阳' '电信'
		 speed_test '6132' '湖南长沙' '电信'
		 speed_test '28225' '湖南长沙' '电信'
		 speed_test '3973' '甘肃兰州' '电信'
		 speed_test '6592' '重庆' '电信'
		 speed_test '16983' '重庆' '电信'
		 speed_test '19076' '重庆' '电信'
		 speed_test '19918' '青海西宁' '电信'

		end=$(date +%s)  
		rm -rf speedtest*
		echo "——————————————————————————————————————————————————————————"
		time=$(( $end - $start ))
		if [[ $time -gt 60 ]]; then
			min=$(expr $time / 60)
			sec=$(expr $time % 60)
			echo -ne "  测试完成, 本次测速耗时: ${min} 分 ${sec} 秒"
		else
			echo -ne "  测试完成, 本次测速耗时: ${time} 秒"
		fi
		echo -ne "\n  当前时间: "
		echo $(date +%Y-%m-%d" "%H:%M:%S)
	fi

	if [[ ${selection} == 4 ]]; then
		echo "——————————————————————————————————————————————————————————"
		echo "ID    测速服务器信息       上传/Mbps   下载/Mbps   延迟/ms"
		start=$(date +%s) 

		 speed_test '5083' '上海' '联通'
		 speed_test '21005' '上海' '联通'
		 speed_test '24447' '上海５Ｇ' '联通'
		 speed_test '5103' '云南昆明' '联通'
		 speed_test '5465' '内蒙古呼和浩特' '联通'
		 speed_test '5145' '北京' '联通'
		 speed_test '5505' '北京' '联通'
		 speed_test '18462' '北京' '联通'
		 speed_test '9484' '吉林长春' '联通'
		 speed_test '10742' '吉林长春' '联通'
		 speed_test '2461' '四川成都' '联通'
		 speed_test '5475' '天津' '联通'
		 speed_test '27154' '天津５Ｇ' '联通'
		 speed_test '5509' '宁夏' '联通'
		 speed_test '5724' '安徽合肥' '联通'
		 speed_test '5039' '山东济南' '联通'
		 speed_test '12538' '山东济南' '联通'
		 speed_test '26180' '山东济南５Ｇ' '联通'
		 speed_test '5710' '山东青岛' '联通'
		 speed_test '12516' '山西太原' '联通'
		 speed_test '12868' '山西太原' '联通'
		 speed_test '19736' '山西太原' '联通'
		 speed_test '3891' '广东广州' '联通'
		 speed_test '26678' '广东广州' '联通'
		 speed_test '10201' '广东深圳' '联通'
		 speed_test '5674' '广西南宁' '联通'
		 speed_test '6144' '新疆乌鲁木齐' '联通'
		 speed_test '5446' '江苏南京' '联通'
		 speed_test '13704' '江苏南京' '联通'
		 speed_test '5097' '江西南昌' '联通'
		 speed_test '7230' '江西南昌' '联通'
		 speed_test '5131' '河南郑州' '联通'
		 speed_test '6810' '河南郑州' '联通'
		 speed_test '6245' '浙江宁波' '联通'
		 speed_test '5300' '浙江杭州' '联通'
		 speed_test '5985' '海南海口' '联通'
		 speed_test '5485' '湖北武汉' '联通'
		 speed_test '26677' '湖南株洲' '联通'
		 speed_test '4870' '湖南长沙' '联通'
		 speed_test '4690' '甘肃兰州' '联通'
		 speed_test '5506' '福建厦门' '联通'
		 speed_test '4884' '福建福州' '联通'
		 speed_test '5750' '西藏拉萨' '联通'
		 speed_test '5017' '辽宁沈阳' '联通'
		 speed_test '5726' '重庆' '联通'
		 speed_test '5992' '青海西宁' '联通'
		 speed_test '5460' '黑龙江哈尔滨' '联通'

		end=$(date +%s)  
		rm -rf speedtest*
		echo "——————————————————————————————————————————————————————————"
		time=$(( $end - $start ))
		if [[ $time -gt 60 ]]; then
			min=$(expr $time / 60)
			sec=$(expr $time % 60)
			echo -ne "  测试完成, 本次测速耗时: ${min} 分 ${sec} 秒"
		else
			echo -ne "  测试完成, 本次测速耗时: ${time} 秒"
		fi
		echo -ne "\n  当前时间: "
		echo $(date +%Y-%m-%d" "%H:%M:%S)
	fi

	if [[ ${selection} == 5 ]]; then
		echo "——————————————————————————————————————————————————————————"
		echo "ID    测速服务器信息       上传/Mbps   下载/Mbps   延迟/ms"
		start=$(date +%s) 

		 speed_test '4665' '上海' '移动'
		 speed_test '16719' '上海' '移动'
		 speed_test '16803' '上海' '移动'
		 speed_test '25637' '上海５Ｇ' '移动'
		 speed_test '5892' '云南昆明' '移动'
		 speed_test '26728' '云南昆明' '移动'
		 speed_test '17085' '内蒙古呼和浩特' '移动'
		 speed_test '27019' '内蒙古呼和浩特' '移动'
		 speed_test '17230' '内蒙古阿拉善' '移动'
		 speed_test '4713' '北京' '移动'
		 speed_test '25858' '北京' '移动'
		 speed_test '16375' '吉林长春' '移动'
		 speed_test '4575' '四川成都' '移动'
		 speed_test '24337' '四川成都' '移动'
		 speed_test '28211' '四川成都' '移动'
		 speed_test '17184' '天津' '移动'
		 speed_test '16392' '宁夏银川' '移动'
		 speed_test '26940' '宁夏银川' '移动'
		 speed_test '4377' '安徽合肥' '移动'
		 speed_test '26404' '安徽合肥' '移动'
		 speed_test '17388' '山东临沂' '移动'
		 speed_test '16314' '山东济南' '移动'
		 speed_test '17480' '山东济南' '移动'
		 speed_test '25881' '山东济南' '移动'
		 speed_test '17432' '山东青岛' '移动'
		 speed_test '16005' '山西太原' '移动'
		 speed_test '6611' '广东广州' '移动'
		 speed_test '4515' '广东深圳' '移动'
		 speed_test '15863' '广西南宁' '移动'
		 speed_test '3784' '新疆乌鲁木齐' '移动'
		 speed_test '16858' '新疆乌鲁木齐' '移动'
		 speed_test '26938' '新疆乌鲁木齐５Ｇ' '移动'
		 speed_test '17228' '新疆伊犁' '移动'
		 speed_test '17227' '新疆和田' '移动'
		 speed_test '17245' '新疆喀什' '移动'
		 speed_test '17222' '新疆阿勒泰' '移动'
		 speed_test '21590' '江苏南京' '移动'
		 speed_test '27249' '江苏南京５Ｇ' '移动'
		 speed_test '21530' '江苏南通' '移动'
		 speed_test '21722' '江苏宿迁' '移动'
		 speed_test '21845' '江苏常州' '移动'
		 speed_test '22349' '江苏徐州' '移动'
		 speed_test '21600' '江苏扬州' '移动'
		 speed_test '5122' '江苏无锡' '移动'
		 speed_test '21973' '江苏无锡' '移动'
		 speed_test '26850' '江苏无锡５Ｇ' '移动'
		 speed_test '21642' '江苏泰州' '移动'
		 speed_test '22037' '江苏淮安' '移动'
		 speed_test '21946' '江苏盐城' '移动'
		 speed_test '3927' '江苏苏州' '移动'
		 speed_test '21472' '江苏苏州' '移动'
		 speed_test '21584' '江苏连云港' '移动'
		 speed_test '17320' '江苏镇江' '移动'
		 speed_test '16294' '江西南昌' '移动'
		 speed_test '16332' '江西南昌' '移动'
		 speed_test '25883' '江西南昌' '移动'
		 speed_test '17223' '河北石家庄' '移动'
		 speed_test '10939' '河南商丘' '移动'
		 speed_test '4486' '河南郑州' '移动'
		 speed_test '18970' '河南郑州' '移动'
		 speed_test '26331' '河南郑州５Ｇ' '移动'
		 speed_test '6715' '浙江宁波' '移动'
		 speed_test '4647' '浙江杭州' '移动'
		 speed_test '12278' '浙江杭州' '移动'
		 speed_test '16503' '海南海口' '移动'
		 speed_test '16395' '湖北武汉' '移动'
		 speed_test '26357' '湖北武汉' '移动'
		 speed_test '26547' '湖北武汉' '移动'
		 speed_test '15862' '湖南长沙' '移动'
		 speed_test '28491' '湖南长沙５Ｇ' '移动'
		 speed_test '16145' '甘肃兰州' '移动'
		 speed_test '16171' '福建福州' '移动'
		 speed_test '17494' '西藏拉萨' '移动'
		 speed_test '18444' '西藏拉萨' '移动'
		 speed_test '7404' '贵州贵阳' '移动'
		 speed_test '16398' '贵州贵阳' '移动'
		 speed_test '25728' '辽宁大连' '移动'
		 speed_test '16167' '辽宁沈阳' '移动'
		 speed_test '16409' '重庆' '移动'
		 speed_test '17584' '重庆' '移动'
		 speed_test '26380' '陕西西安' '移动'
		 speed_test '16915' '青海西宁' '移动'
		 speed_test '18504' '青海西宁' '移动'
		 speed_test '29083' '青海西宁５Ｇ' '移动'
		 speed_test '17437' '黑龙江哈尔滨' '移动'
		 speed_test '26656' '黑龙江哈尔滨５Ｇ' '移动'

		end=$(date +%s)  
		rm -rf speedtest*
		echo "——————————————————————————————————————————————————————————"
		time=$(( $end - $start ))
		if [[ $time -gt 60 ]]; then
			min=$(expr $time / 60)
			sec=$(expr $time % 60)
			echo -ne "  测试完成, 本次测速耗时: ${min} 分 ${sec} 秒"
		else
			echo -ne "  测试完成, 本次测速耗时: ${time} 秒"
		fi
		echo -ne "\n  当前时间: "
		echo $(date +%Y-%m-%d" "%H:%M:%S)
	fi
}

runall() {
	checkroot;
	checksystem;
	checkpython;
	checkcurl;
	checkwget;
	checkspeedtest;
	clear
	speed_test;
	preinfo;
	selecttest;
	runtest;
	rm -rf speedtest*
}

runall
