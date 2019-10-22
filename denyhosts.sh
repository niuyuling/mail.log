#!/bin/bash
#
# System authorization information.
# SSH prevents violent cracking
# Email: aixiao@aixiao.me
# Time: 20170909
#

function init() {
    num=20;
    send_mail=1;
    pwd_path="/root";
    TIME=`date +"%Y%m%d%H%M"`;
    log_file="${pwd_path}/${TIME}.log";
    email_address="1605227279@qq.com";
}

function run()
{
    echo "Read-Only Memory,ROM:" &>> ${log_file}
    df -am &>> ${log_file}

    echo "random access memory，RAM:" &>> ${log_file}
    free -hl &>> ${log_file}

    echo "System process:" &>> ${log_file}
    ps -axjf &>> ${log_file}

    echo "Network Connections" &>> ${log_file}
    netstat -tnulp &>> ${log_file}

    echo "System SSH authorization information:" &>> ${log_file}
    /root/denyhosts/rhost | awk '{a[$1]+=1;} END {for(i in a){print a[i]" "i;}}' &>> ${log_file}
    ip=$(echo $(/root/denyhosts/rhost | awk -v num=${num} '{a[$1]+=1;} END {for(i in a){if (a[i] >= num) {print i;}}}'))
    
    
    ip_address=($ip)
    for i in ${ip_address[@]} ; do
        /sbin/iptables -I INPUT -s $i -j DROP
    done
    /sbin/iptables-save > /root/ipv4tables

    echo "" &>> ${log_file}
    echo "Iptables filter table" &>> ${log_file}
    /sbin/iptables -L -n --line-numbers &>> ${log_file}
    echo "" &>> ${log_file}

    if test $send_mail = 1; then
        mail -s "System Log" ${email_address} < ${log_file}
        rm ${log_file}
    fi
    sync
}


init;
run;
exit 0;
20190103
20190911
20191008
aixiao@aixiao.me

