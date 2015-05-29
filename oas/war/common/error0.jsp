<%@page language="java" contentType="text/html;charset=gbk" isErrorPage="true" %>
<html>
<head>
    <title>message</title>
</head>

<body>
<h2>ERROR</h2>
<div id="screen">
    <div id="content">
<br/>
 <% if (exception != null) { %>
    <pre><% exception.printStackTrace(new java.io.PrintWriter(out)); %></pre>
 <% } else if ((Exception)request.getAttribute("javax.servlet.error.exception") != null) { %>
    <pre><% ((Exception)request.getAttribute("javax.servlet.error.exception"))
                           .printStackTrace(new java.io.PrintWriter(out)); %></pre>
 <% } %>
 <br>
<input type="button" value="back" onclick="jscript:history.go(-1);" />
 
    </div>
</body>
</html>
