set objArgs = wscript.Arguments

Set CDO=CreateObject("CDO.Message") 
strCfg="http://schemas.microsoft.com/cdo/configuration/" 
With  cdo 
.Sender = "weijiang@coship.com " 
.From = "weijiang@coship.com " 
.To = "weijiang@coship.com,maxiuhong@coship.com"
.cc = "weijiang@coship.com" 
.Fields("urn:schemas:mailheader:X-Priority") =1   
.Fields.Update
.Subject = " " & wscript.Arguments(0) & "����ʧ��,�뼰ʱ����"
.HtmlBody="<p>���ã�</p>��˾��Ʒ�ͺ�:" & wscript.Arguments(0) & "����ʧ�ܣ������������<p>1 ���԰�����:" & wscript.Arguments(1) & "</p><p>2 Դ��������:" & wscript.Arguments(2) & "</p><p>3 Դ�����ǩ:" & wscript.Arguments(3) & "</p><p>4 Դ����·��:" & wscript.Arguments(4) & "</p><p>========================================</p><p><font size=2>������</font></p><p ><font size=2>������ͬ�޵��ӹɷ����޹�˾<br />  ��ַ����������ɽ�����¿Ƽ�԰�����ʺ�Ƽ�����(�ʱࣺ518057)<br />   <br />   <br /></font></p>"
.Configuration(strCfg& "smtpauthenticate" )=1
.Configuration(strCfg& "SendUsing" )=2
.Configuration(strCfg& "smtpserver")="192.168.99.183"
.Configuration(strCfg& "smtpserverport" )= 25
.Configuration(strCfg& "sendusername ")="weijiang"
.Configuration(strCfg& "sendpassword ")="905171"
.Configuration.Fields.Update
.send
End With