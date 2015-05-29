<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>注销成功</title>
<style type="text/css">
<!--
.STYLE1 {
	color: #FF0000;
	font-weight: bold;
	font-size: 24px;
}
-->
</style>
</head>
<body>
<div align="center"><br><br>
  <p>
    <%
	session.invalidate();
%>
     <span class="STYLE1">注销成功</span></p>
</div>
<script>
	 setTimeout("jscript:location.href='../logon.jsp'",1000);
</script>
</body>
</html>
