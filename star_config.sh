#!/bin/bash
#Linux服务器初始环境配置
#01 增加历史命令时间显示

if grep -q 'HISTTIMEFORMAT="%F %T "' /etc/bashrc && grep -q 'export HISTTIMEFORMAT' /etc/bashrc ;then
     echo "HISTTIMEFORMAT is exist."
  else   	 
     echo 'HISTTIMEFORMAT="%F %T "' >>/etc/bashrc
     echo 'export HISTTIMEFORMAT'>>/etc/bashrc
   fi
#02 修改DNS
if grep -q 'nameserver 114.114.114.114' /etc/resolv ; then
     echo "nameserver is exsit."
   else	 
      echo 'nameserver 114.114.114.114' >>/etc/resolv.conf
   fi  
#03 安装常用软件
yum install -y wget gcc make ntpdate lrzsz dmidecode openssh-clients bind-utils nc net-tools
if [ $? -ne 0 ];then
     echo "安装出现错误，请检查" && exit 1
   fi	 
#04 同步系统时间
TMZONE=`cat /etc/sysconfig/clock | awk -F '"' '{print $2}'`
if [ $TMZONE != Asia/Shanghai ];then
     \cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	 echo '5 2-3 * * * /usr/sbin/ntpdate time.nist.gov' >>/var/spool/cron/root
     ntpdate time.nist.gov
     hwclock -w
  else
     echo "当前时区已是上海时区，开始同步时间..."
     ntpdate time.nist.gov		 
   fi	   
sleep 3
#05 修改hostname
#sed -i 's/localhost//g' /etc/sysconfig/network
#06 关闭Selinux
setenforce 0
echo 'setenforce 0'>> /etc/rc.d/rc.local
#07 设置超时时间
if grep -q 'TMOUT=600' /etc/profile;then
     echo "TMOUT is already set."
  else   	 
     echo 'TMOUT=600'>> /etc/profile
   fi

#08 设置防火墙策略
cd /root
touch iprule.sh
echo 'iptables -F' >>/root/iprule.sh
echo 'iptables -Z' >>/root/iprule.sh
echo 'iptables -X' >>/root/iprule.sh
echo 'iptables -F -t filter' >>/root/iprule.sh
echo 'iptables -F -t nat' >>/root/iprule.sh
echo 'iptables -X -t nat' >>/root/iprule.sh
echo 'iptables -Z -t nat' >>/root/iprule.sh
echo 'iptables -P INPUT DROP' >>/root/iprule.sh
echo 'iptables -p OUTPUT ACCEPT' >>/root/iprule.sh
echo 'iptables -P FORWARD DROP' >>/root/iprule.sh
echo 'iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT' >>/root/iprule.sh
echo 'iptables -t nat -P PREROUTING ACCEPT' >>/root/iprule.sh                            
echo 'iptables -t nat -P POSTROUTING ACCEPT' >>/root/iprule.sh                          
echo 'iptables -t nat -P OUTPUT ACCEPT' >>/root/iprule.sh
echo 'iptables -A INPUT -p icmp -j ACCEPT' >>/root/iprule.sh
echo 'iptables -A INPUT -p tcp --dport 22  -j ACCEPT' >>/root/iprule.sh
echo 'iptables -A INPUT -p tcp --dport 80 -j ACCEPT' >>/root/iprule.sh
echo 'iptables -t nat -A POSTROUTING -o docker -s 172.17.42.1/16 -j MASQUERADE' >>/root/iprule.sh
echo '/etc/init.d/iptables save' >>/root/iprule.sh
chmod u+x /root/iprule.sh
/root/iprule.sh

