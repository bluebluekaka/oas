<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%
	String name = request.getParameter("name");
	String start_date = request.getParameter("start_date");
	String end_date = request.getParameter("end_date");
	if(start_date==null){
		start_date = com.oas.common.Utils.getNowDate();
		end_date = start_date;
	}
	String url = name+"_"+start_date+"_"+end_date;
	
	String fb = request.getParameter("fb");
 	response.setCharacterEncoding("GBK");
 	request.setCharacterEncoding("GBK");
	response.setContentType("application/x-msdownload");
	response.setHeader("Content-Disposition", "attachment; filename=\""+url+".csv\"");  
	out.print(fb);
%>
 