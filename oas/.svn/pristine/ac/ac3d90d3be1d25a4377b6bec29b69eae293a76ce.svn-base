<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>message</title>
 </head>
  <link href="../ui/lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" /> 
  	<link href="../ui/lib/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css" /> 
 <style>
 .l-button-submit,.l-button-test{width:80px; float:left; margin-left:10px; padding-bottom:2px;}
 </style>
<body ><br>
<div id="screen" align="center">
<br>
 <h1>操作结果</h1>
 <p>&nbsp;</p> 
<script language="jscript">
var errmsg = false;
</script>
<table width="50%" border="0"  align="center"   cellpadding="0" cellspacing="0">
<s:if test="actionMessages!=null">
  <s:iterator value="actionMessages">
  <tr><td >执行信息: 
   &nbsp;&nbsp; <s:property />
  </td></tr>
    </s:iterator>
</s:if>
<s:if test="actionErrors!=null">
	<s:iterator value="actionErrors">
<tr style="color:red"><td >错误信息: 
&nbsp;&nbsp;<s:property />
</td></tr>
<script language="jscript">
	errmsg = true;
	var errmsg = "<s:property />";
	if(errmsg.length>90) errmsg = errmsg.substring(0, 90);
</script>
	</s:iterator>
</s:if>
<tr>
  <td >&nbsp; </td>
</tr>
<tr>
  <td> <table align="center"><tr><td>    <input type="button"  value=" 后退 " class="l-button l-button-test" onclick="jscript:history.go(-1);" /> </td></tr></table> </td>
</tr>
</table>
    </div>
</body>
</html>
