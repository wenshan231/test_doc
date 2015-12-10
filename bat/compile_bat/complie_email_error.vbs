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
.Subject = " " & wscript.Arguments(0) & "编译失败,请及时处理！"
.HtmlBody="<p>您好！</p>公司产品型号:" & wscript.Arguments(0) & "编译失败，具体参数如下<p>1 测试包名称:" & wscript.Arguments(1) & "</p><p>2 源代码类型:" & wscript.Arguments(2) & "</p><p>3 源代码标签:" & wscript.Arguments(3) & "</p><p>4 源代码路径:" & wscript.Arguments(4) & "</p><p>========================================</p><p><font size=2>配置组</font></p><p ><font size=2>深圳市同洲电子股份有限公司<br />  地址：深圳市南山区高新科技园北区彩虹科技大厦(邮编：518057)<br />   <br />   <br /></font></p>"
.Configuration(strCfg& "smtpauthenticate" )=1
.Configuration(strCfg& "SendUsing" )=2
.Configuration(strCfg& "smtpserver")="192.168.99.183"
.Configuration(strCfg& "smtpserverport" )= 25
.Configuration(strCfg& "sendusername ")="weijiang"
.Configuration(strCfg& "sendpassword ")="905171"
.Configuration.Fields.Update
.send
End With