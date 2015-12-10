echo 		******************************************************
echo 		         when reboot 10.10.5.66 could reload 
echo			Y： 10.10.5.163    编译ISS samba  用户名：qiaoting  密码：123456 echo			
echo			Z： 10..10.5.165  samba  用户名：qiaoting  密码：123987 
echo
echo			Q： 10.10.5.161   samba qiaoting  789125
echo			G：10.10.96.172   samba ott-admin 789456456
echo			net use \\10.10.96.171\share_windows\SCV500R002_iepg\builds /USER:C906070c\share coship7000?
echo 		******************************************************

net use \\10.10.96.171\share_windows\SCV500R002_iepg\builds /USER:C906070c\share coship7000?
net use  G：\\10.10.96.172\ott-admin  /USER:ott-admin  789456456
net use  O: \\10.10.96.177\ott-admin  /USER:ott-admin  789456456
net use  Z：\\10.10.5.165\qiaoting /USER:qiaoting  123987
net use  Q：\\10.10.5.161\qiaoting /USER:qiaoting  789125
net use  Y: \\10.10.5.163\qiaoting /USER:qiaoting  123456

echo if you reboot 5.166,please confirm  G: Z: Q: Y: is exist
pause
