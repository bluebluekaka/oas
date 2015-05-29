<%@page language="java" contentType="text/html; charset=UTF-8"%><%@ include file="common/taglibs.jsp"%>
<html >
<head>
<title>Office Automation System</title>

<link href="common/common.css" rel="stylesheet" type="text/css">
<style type="text/css">
body,td,th {
	font-family: Verdana, Geneva, sans-serif;
}
body {
	background-color: #FFF;
	margin-left: 25px;
	margin-right: 25px;
	margin-top: 15px;
}
input.btn0{
	cursor: hand;
	color: #444;
	font-size:14px;
	font-family: "Courier New", Verdana;
}
.ja0 {
	height: 23px;
	font-family: Verdana;
	color: #555;
}
input.btn01 {	cursor: hand;
	color: #444;
	font-size:14px;
	font-family: "Courier New", Verdana;
}
</style></head>

<body  style="overflow:hidden">
<table width="100%" border="0">
  <tr>
   <td width="38%"  > </td>
    <td width="28%"><img src="images/icons/title.gif" align="left" /></td>
    <td width="34%">&nbsp;</td>
  </tr>
    <tr>
    <td height="23" colspan="3" bgcolor="#718BA6">&nbsp;</td>
  </tr>

    <tr>
    <td height="30" colspan="3">&nbsp;</td>
  </tr>
    <tr>
    <td height="130" colspan="3" align="center">
<form method="POST" action="logon" name="myfrm" onSubmit="jscript:return checkfrm();">
  <table class="tbl" bgcolor="white" cellpadding="0" cellspacing="0" style="border:1px solid gray; background:#F8F8F8" width="400">
    <tr height="30">
      <td height="27" colspan="2"  background="images/logbg.jpg">&nbsp;&nbsp; <b  >登&nbsp;&nbsp;录</b></td>
    </tr>
    <tr>
      <td colspan="2 " height="25">&nbsp;<br></td>
    </tr>
    <tr height="30">
      <td align="right" width="30%"><b>用户名:</b>&nbsp;</td>
      <td><input id="uid" type="text" name="user.uid" size="25" class="ja0" value=""></td>
    </tr>
    <tr height="30">
      <td align="right" width="30%"><b><span id="muidmsg"></span> 密&nbsp;&nbsp;&nbsp;码:</b>&nbsp;</td>
      <td><input type="password" id="pwd" name="user.pwd" size="25" class="ja0" value="">
        &nbsp; </td>
    </tr>
    <tr>
      <td valign="middle" align="center" colspan="2" height="45"><font color="red"><b><span id="msgspn">
        <s:if test="actionErrors!=null">
          <s:iterator value="actionErrors">
            <s:property />
            <br/>
          </s:iterator>
        </s:if>
        </span> </b></font> 

        <input id="login" type="submit" value=" 登录 " class="btn01">
        &nbsp;
        <input type="reset" value=" 重填 " class="btn01"></td>
    </tr>
    <tr >
      <td colspan="4"  style="line-height:20px; padding-left:5px;"  >
&nbsp;&nbsp;&nbsp;&nbsp;如果您碰到问题或者需要协助， 请联系系统管理员或者<a href="mailto:email@email.com">写邮件</a>给我们 
<p></td>
    </tr>
  </table>
</form>
    </td>
    <td width="0%"></td>
 </tr>
     <tr>
    <td height="40" colspan="3">&nbsp;</td>
  </tr>
     <tr>
    <td height="23" colspan="3" bgcolor="#718BA6">&nbsp;</td>
  </tr>
     <tr>
     <td height="25" colspan="3" align="center"><span style="font-size: 13px;">v<%=Config.version%>, Copyright(C) 2013 OAS, Inc. All Rights Reserved.</span></td>  
  </tr>
</table>
 
</body>
</html>
<script language="jscript">
//window.moveTo(0,0);   
//window.resizeTo(screen.availWidth,screen.availHeight);  
function checkfrm(){
	if(myfrm.uid.value==""){
		msgspn.innerText = "请输入用户名";
		myfrm.uid.focus();
		return false;
	}
	if(myfrm.pwd.value==""){
		msgspn.innerText = "请输入密码";
		myfrm.pwd.focus();
		return false;
	}
	return true;
}

//var acturl = location.href;
//if(acturl.indexOf("http://")==0){
//	acturl = "https://" + acturl.substring(7);
//	setTimeout(function e(){location.href = acturl;},500);
//}
</script>
