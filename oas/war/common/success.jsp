<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>message</title>
 </head>
  <style type="text/css">
           body{ font-size:12px;}
        .l-table-edit {}
        .l-table-edit-td{ padding:4px;}
        .l-button-submit,.l-button-test{width:80px; float:left; margin-left:10px; padding-bottom:2px;}
        .l-verify-tip{ left:230px; top:120px;}
        #errorLabelContainer{ padding:10px; width:300px; border:1px solid #FF4466; display:none; background:#FFEEEE; color:Red;}
    </style>
<body style="padding:20px">
<s:if test="actionMessages!=null">
  <s:iterator value="actionMessages">
执行信息: 
   &nbsp;&nbsp; <s:property />
    </s:iterator>
</s:if>
<s:if test="actionErrors!=null">
<s:iterator value="actionErrors">
错误信息: 
&nbsp;&nbsp;<s:property />
</s:iterator>
</s:if>
</body>
</html>
