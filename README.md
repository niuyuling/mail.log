# denyhosts
ssh防止暴力破解.  
记录mail server的一些信息,攻击IP等.  
- 适用Debian 8、9  


cd /root
git clone https://github.com/niuyuling/denyhosts.git
chmod a+x /root/denyhosts/denyhosts.sh
crontab 定时任务,像这样.
0 22 * * * /root/denyhosts/denyhosts.sh

