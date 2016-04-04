#!/bin/bash


################################################系统部下载测试专用脚本###################################################
#                                                                                                                       #
#   使用说明:                                                                                                           #
#             1、请将脚本放在/root目录或其他目录下,赋于755权限。                                                        #
#                                                                                                                       #
#             2、请在/root目录下新建ip.txt文件，并在此文件里添加要被测试服务器的ip地址。                                #
#                                                                                                                       #
#             3、请修改下载连接。此脚本默认的连接是 http://ip地址:8080/1m.jpg，请修改成你的下载连接。	                #
#                                                                                                                       #	         
#             4、请在定时任务crontab里，按实际情况添加定时任务。                                                        #
#                                                                                                                       #
#            *5、为了方便测试,请将服务器的下载连接做成统一的格式。                                                      #
#                                                                                                                       #
#            *6、请校准服务器的时间。                                                                                   #
#                                                                                                                       #
#             7、测试数据产生在/var/log/wget目录下。                                                                    #   
#                                                                                                                       #
#########################################################################################################################


m_date=$(date +%Y%m%d)
rpm -qa|grep wget &>/dev/null

if [ $? -eq 0 ] ;then



		for i in $(cat /root/ip.txt)

		do
			  if [ -d /var/log/wget/$i  ]  ;then

						/usr/bin/wget -SO  /dev/null -o /root/$i'_'wget.log -T 80 -c http://$i:8080/1m.jpg
						cat /root/$i'_'wget.log |grep -Ev ^$ |tail -n 1|awk '{print $1"_"$2"\t"$3$4}'|sed "s/(//g;s/)//g" >> /var/log/wget/$i/$i'_'$m_date


				else

						mkdir -p /var/log/wget/$i
						/usr/bin/wget -SO /dev/null -o /root/$i'_'wget.log -T 80 -c http://$i:8080/1m.jpg
						cat /root/$i'_'wget.log |grep -Ev ^$ |tail -n 1|awk '{print $1"_"$2"\t"$3$4}'|sed "s/(//g;s/)//g" >> /var/log/wget/$i/$i'_'$m_date


			  fi

		done



else

	yum -y install wget
	[ $? -ne 0 ] && echo -e "\n\n\e[1;31m wget install error\e[0m\n\n" && exit
	
	for i in $(cat /root/ip.txt)

		do
			  if [ -d /var/log/wget/$i  ]  ;then

						/usr/bin/wget -SO  /dev/null -o /root/$i'_'wget.log -T 80 -c http://$i:8080/1m.jpg
						cat /root/$i'_'wget.log |grep -Ev ^$ |tail -n 1|awk '{print $1"_"$2"\t"$3$4}'|sed "s/(//g;s/)//g" >> /var/log/wget/$i/$i'_'$m_date


				else

						mkdir -p /var/log/wget/$i
						/usr/bin/wget -SO /dev/null -o /root/$i'_'wget.log -T 80 -c http://$i:8080/1m.jpg
						cat /root/$i'_'wget.log |grep -Ev ^$ |tail -n 1|awk '{print $1"_"$2"\t"$3$4}'|sed "s/(//g;s/)//g" >> /var/log/wget/$i/$i'_'$m_date


			  fi

		done

fi

