#!/bin/sh

WORKDIR=$PWD
GSD_CONFIG_PATH=$WORKDIR"/server/gsd/gsd.config.xml"
GSD_XIO_PATH=$WORKDIR"/server/gsd/gsd.xio.xml"
AUANY_CONFIG_PATH=$WORKDIR"/auany/xauany.config.my.xml"
SERVICED_CONFIG_PATH=$WORKDIR"/serviced/serviced.config.my.xml"

IPREG='[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'

for i in {1..5}
do
	my_ip=`curl -s www.ip.cn | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
	if [ "${my_ip}" = "" ] 
	then
		sleep 1
		continue
	else
		break
	fi
done

if [ "${my_ip}" = "" ]
then 
	echo "自动获取IP失败"
else
	echo "自动获取的公网IP为${my_ip}"
	read -p "是否使用该ip进行配置(y/n):" use_auto
fi

if [ "${my_ip}" = "" ] || [ "${use_auto} | tr 'A-Z' 'a-z'" = "n" ]
then
	read -p "请输入您要配置的IP：" my_ip
fi

echo "更新gsd配置文件..."
sed -i "s/rmi.host=\"${IPREG}\"/rmi.host=\"${my_ip}\"/g" $GSD_CONFIG_PATH

echo "更新gsd.xio配置文件..."
sed -i "s/remoteIp=\"${IPREG}\"/remoteIp=\"${my_ip}\"/g" $GSD_XIO_PATH

echo "更新auany配置文件..."
sed -i "s/checkTokenUrl=\"http:\/\/${IPREG}\/qyz\/sdkCheckToken.php\"/checkTokenUrl=\"http:\/\/${my_ip}\/qyz\/sdkCheckToken.php\"/g" $AUANY_CONFIG_PATH

echo "更新serviced配置文件..."
sed -i "s/rmi.host=\"${IPREG}\"/rmi.host=\"${my_ip}\"/g" $SERVICED_CONFIG_PATH

echo "更新完成"