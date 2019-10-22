# denyhosts
ssh防止暴力破解,适用Debian 8、9  


cd /root
git clone https://github.com/niuyuling/denyhosts.git  
cd denyhosts  
make clean; make  
chmod a+x /root/denyhosts/denyhosts.sh  
crontab 定时任务,像这样.  
0 22 * * * /root/denyhosts/denyhosts.sh  

