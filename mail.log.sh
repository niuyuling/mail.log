#!/bin/bash
#
# System authorization information.
# Email: aixiao@aixiao.me
# Time: 20170909
#

function run()
{
    pwd_path="/root";
    TIME=`date +"%Y%m%d"`;
    log_file="${pwd_path}/${TIME}.log";
    email_address="1605227279@qq.com";
    num=9;

    echo "Read-Only Memory,ROM:" &>> ${log_file}
    df -am &>> ${log_file}

    echo "" &>> ${log_file}
    echo "random access memory，RAM:" &>> ${log_file}
    free -hl &>> ${log_file}

    echo "" &>> ${log_file}
    echo "System process:" &>> ${log_file}
    ps -axjf &>> ${log_file}

    echo "" &>> ${log_file}
    echo "Network Connections" &>> ${log_file}
    netstat -tnulp &>> ${log_file}

    echo "" &>> ${log_file}
    echo "System authorization information:" &>> ${log_file}
    if test "`date | awk '{print $3}'`" -ge 10 ; then
        grep ^`date | awk '{print $2}'`.`date | awk '{print $3}'` /var/log/auth.log &>> ${log_file}
        grep -E "^`date | awk '{print $2}'`.`date | awk '{print $3}'`" /var/log/auth.log | grep failure | grep rhost | awk '{printf $14 "\n"}' | cut -d = -f 2 | awk '{a[$1]+=1;} END {for(i in a){print a[i]" "i;}}' &>> ${log_file}
        ip=$(grep -E "^`date | awk '{print $2}'`.`date | awk '{print $3}'`" /var/log/auth.log | grep failure | grep rhost | awk '{printf $14 "\n"}' | cut -d = -f 2 | awk -v num=${num} '{a[$1]+=1;} END {for(i in a){if (a[i] >= num) {print i;}}}')
    else
        grep ^`date | awk '{print $2}'`..`date | awk '{print $3}'` /var/log/auth.log &>> ${log_file}
        grep -E "^`date | awk '{print $2}'`..`date | awk '{print $3}'`" /var/log/auth.log | grep failure | grep rhost | awk '{printf $14 "\n"}' | cut -d = -f 2 | awk '{a[$1]+=1;} END {for(i in a){print a[i]" "i;}}' &>> ${log_file}
        ip=$(grep -E "^`date | awk '{print $2}'`..`date | awk '{print $3}'`" /var/log/auth.log | grep failure | grep rhost | awk '{printf $14 "\n"}' | cut -d = -f 2 | awk -v num=${num} '{a[$1]+=1;} END {for(i in a){if (a[i] >= num) {print i;}}}')
    fi

    ip_address=($ip)
    for i in ${ip_address[@]} ; do
        /sbin/iptables -I INPUT -s $i -j DROP
    done
    /sbin/iptables-save > /root/ipv4tables

    echo "" &>> ${log_file}
    echo "Iptables filter table" &>> ${log_file}
    /sbin/iptables -L -n --line-numbers &>> ${log_file} 
    echo "" &>> ${log_file}

    mail -s "System Log" ${email_address} < ${log_file}
    rm ${log_file}
    sync
    sync
}

run;
exit 0;
20190103
aixiao@aixiao.me

