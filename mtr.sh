#!/bin/bash


################################################系统部ping测试专用脚本###################################################
#                                                                                                                       #
#   使用说明:                                                                                                           #
#             1、请将脚本放在/root目录或其他目录下,赋于755权限。                                                        #
#                                                                                                                       #
#             2、请在/root目录下新建ip.txt文件，并在此文件里添加要被测试服务器的ip地址。                                #
#                                                                                                                       #
#             3、请在定时任务crontab里，按实际情况添加定时任务。                                                        #
#                                                                                                                       #
#            *4、请校准服务器的时间。                                                                                   #
#                                                                                                                       #
#             5、测试数据产生在/var/log/mtr目录下                                                                       #
#                                                                                                                       #
#########################################################################################################################



#!/bin/bash
m_date=$(date +%Y%m%d)
time=$( date +%Y-%m-%d_%H:%M:%S )
rpm -qa|grep mtr &>/dev/null 

if [ $? -eq 0  ] ;then

	for i in $(cat /root/ip.txt)

	do
		  if [ -d /var/log/mtr/$i  ]  ;then

				/usr/sbin/mtr -n -r -c 20 -i 0.5 $i  > /tmp/ping.log
				awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"}' /tmp/ping.log >/tmp/ping_awk.log
				head -n1 /tmp/ping_awk.log >>/var/log/mtr/$i/$i'_'$m_date  && grep -v "HOST" /tmp/ping_awk.log |sed "s/$/&$time/g" >>/var/log/mtr/$i/$i'_'$m_date

		  else

				mkdir -p /var/log/mtr/$i
				/usr/sbin/mtr -n -r -c 20 -i 0.5 $i  > /tmp/ping.log
				awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"}' /tmp/ping.log >/tmp/ping_awk.log
				head -n1 /tmp/ping_awk.log >>/var/log/mtr/$i/$i'_'$m_date  && grep -v "HOST" /tmp/ping_awk.log |sed "s/$/&$time/g" >>/var/log/mtr/$i/$i'_'$m_date

		  fi

	done



else

	yum -y install mtr
	[ $? -ne 0 ] && echo -e "\n\n\e[1;31m mtr install error\e[0m\n\n" && exit
	
	for i in $(cat /root/ip.txt)

	do

		if [ -d /var/log/mtr/$i  ]  ;then
			
		        	/usr/sbin/mtr -n -r -c 20 -i 0.5 $i  > /tmp/ping.log
        			awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"}' /tmp/ping.log >/tmp/ping_awk.log
       		 		head -n1 /tmp/ping_awk.log >>/var/log/mtr/$i/$i'_'$m_date  && grep -v "HOST" /tmp/ping_awk.log |sed "s/$/&$time/g">>/var/log/mtr/$i/$i'_'$m_date

          	else
			 
        			mkdir -p /var/log/mtr/$i
        			/usr/sbin/mtr -n -r -c 20 -i 0.5 $i  > /tmp/ping.log
        			awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"}' /tmp/ping.log >/tmp/ping_awk.log
        			head -n1 /tmp/ping_awk.log >>/var/log/mtr/$i/$i'_'$m_date  && grep -v "HOST" /tmp/ping_awk.log |sed "s/$/&$time/g" >>/var/log/mtr/$i/$i'_'$m_date

           	fi

	
	done

fi
