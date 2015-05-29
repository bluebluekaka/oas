<%@page contentType="text/html;charset=UTF-8" language="java" import="java.util.*,java.sql.*"%><%@ include file="taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>
</title>

    <%
    	String title="";
    	String action = request.getParameter("action");
    	if(action==null) action ="";
    	String station = request.getParameter("station");
    	String agent = request.getParameter("agent");
		String phone = (String)session.getAttribute(Config.USER_PHONE);
		String msg = "";
		if(action.equals(String.valueOf(Config.LISTEN_OLAY_STATUS))){
			title="监听";
		}else if(action.equals(String.valueOf(Config.LISTEN_TALK_STATUS))){
			title="强插";
		}else if(action.equals(String.valueOf(Config.MEETING_STATUS))){
			title="会议";
		} 
		if(Helper.isNull(phone)){
			msg = "您尚未设置自己的坐席号，请在用户管理设置您的坐席号";
		}else{
			Connection conn = null;
			try {
				conn = Helper.getConnection();
				Statement stmt = conn.createStatement();
				ResultSet rs ;
				String sql = "select station from agents where id='"+phone+"' and state<>2";
				rs = stmt.executeQuery(sql);
				if(rs.next()){
					phone = rs.getString(1);	
					msg = "确定使用您登录的话机（"+phone+"） </p>"+title+"话机"+station+"("+agent+")的通话吗？ ";		
				}else{
					msg = "您在用户管理设置的坐席号（"+phone+"）尚未登录话机，请使用坐席号登录一部话机进行操作";
				}
			} catch (Exception ee) { 
				msg = ee.toString();
			} finally {
				if (conn != null) {
					try {
						conn.close();
					} catch (Exception ex) {
					}
				}
			}
		}
		if(action.equals(String.valueOf(Config.LOOUT_STATUS))){
			msg = "确定要强制注销话机"+station+"("+agent+")吗？ ";
		}else if(action.equals(String.valueOf(Config.HANGUP_STATUS))){
			msg = "确定结束监听或强插功能吗？ ";
		}
		String url = "listen?action="+action+"&agent="+agent+"&station="+station+"&phone="+phone;
    %>
    <script type="text/javascript"> 
        
        function doCommit(){
        	form1.action = '<%=url%>';
			form1.submit();
        }
    </script>
    <style type="text/css">
           body{ font-size:12px;}
        .l-table-edit {}
        .l-table-edit-td{ padding:4px;}
        .l-button-submit,.l-button-test{width:80px; float:left; margin-left:10px; padding-bottom:2px;}
        .l-verify-tip{ left:230px; top:120px;}
        #errorLabelContainer{ padding:10px; width:300px; border:1px solid #FF4466; display:none; background:#FFEEEE; color:Red;}
    </style>

</head>

<body style="padding:20px">

<form name="form1" method="post" class="l-form" id="form1" action="" >
<%=msg%>
</form>
    <div style="display:none">
    <!--  数据统计代码 --></div>

    
</body>
</html>