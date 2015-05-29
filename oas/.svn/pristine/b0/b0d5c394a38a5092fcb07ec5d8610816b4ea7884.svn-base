<%@page language="java" contentType="text/html;charset=UTF-8" %><%@ include file="/common/taglibs.jsp"%>
<%
	String action = "userlogs";
	String title = "查询";
	String url = action+"?t="+Utils.getSystemMillis();
	 
	String stime = request.getParameter("stime");
	String etime = request.getParameter("etime"); 
	if(Utils.isNull(stime)||Utils.isNull(etime)){
		stime = Utils.getNowDate()+" 00:00";
		etime = Utils.getNowDate()+" 23:59";
	}
	String sid = request.getParameter("sid");
	if(Utils.isNull(sid)){
		sid = "";
	}
 	String term = "query.stime="+stime+"&query.etime="+etime+"&sid="+sid;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>    
	<link href="../ui/lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
	<link href="../ui/lib/ligerUI/skins/Gray/css/dialog.css" rel="stylesheet" type="text/css" />
	<script src="../ui/lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>   
    <script src="../ui/lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../ui/lib/ligerUI/js/ligerui.all.min.js" type="text/javascript"></script> 
    <link href="../ui/lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    
	<script src="../ui/helper.js" type="text/javascript"></script> 
	<script type="text/javascript">
    var grid=null; 
    var datas;
    var max = 0;
    $(function () {  
			$("#stime").ligerDateEditor({ showTime: true,initValue:'<%=stime%>'});
        	$("#etime").ligerDateEditor({ showTime: true,initValue:'<%=etime%>'}); 
	  		$("form").ligerForm();
	  		 
            
	  		var i0 = 0;
            $.getJSON('<%=url%>&<%=term%>',
            function(json) 
            {
                var colnames="";
                for(var i in json.Rows[0])  
                {		
                		var w = 150;
						if(i0==4)
							w = 215;
                        var hides='';
                        if(i=='HideID') 
                        	hides = ',hide:true';
                        colnames+=",{name:'"+i+"',display:'"+i+"',width:" + w + hides+"}";
                        i0++;
                }
                colnames=colnames.substr(1,colnames.length);
                datas=json;
                eval(                
                        "grid=$('#grids').ligerGrid({"+
                        "columns:["+colnames+"],"+   
                        "data:datas,"+    
                        "dataAction:'local',"+
                        "height: '100%',"+
                        "pageSize:30,"+
                        "rownumbers:true,"+
                        "toolbar: { items: ["+
                        "{ text: '开始时间：<%=stime%>',click:f_inputUser},{ line:true }"+
                        ",{ text: '结束时间：<%=etime%>',click:f_inputUser},{ line:true }"+
                        ",{ text: '自定义查询',click:f_inputUser, icon: 'search2'},{ line:true }"+
                        ",{ text: '导出Excel',click:downloadThis,icon: 'save'}"+
                        "]},"+
                        "totalRender: f_totalRender,"+
                        "heightDiff:-12"+
                        "});"
                    ); 
            }); 
    });  
	function f_totalRender(){
		return datas.totalRender;
	}
	
	function submitThis(){
		form1.action = "<%=jspName%>"; 
		form1.submit();
	}
	
 	function downloadThis(){
		form1.action = "../../common/download.jsp?name=<%=jspName%>&start_date=<%=stime%>&end_date=<%=etime%>"; 
		form1.fb.value = getDatasValue(datas);	
		form1.submit();
	}
	
	function f_inputUser(){
		$.ligerDialog.open({ target: $("#target1"),title:'<%=title%>',height: 300,width: 500,isResize: true,showMax:true, 
			buttons: [
			{ text: '确定', 
				onclick: function (item, dialog) {
					 location.href = '<%=jspName%>?stime='+ $("#stime").val()
					 	+'&etime='+$("#etime").val()+'&sid='+ $("#sid").val();
				} },
			{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
    }
	
    function f_findUser(uid){
		location.href = '<%=jspName%>?id='+uid;
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
<body style="padding:0 2px 2px 2px;overflow:hidden;" >
<form name="form1" method="post" id="form1">
<textarea name="fb"  style="display:none" ></textarea>

<div >
<div id='grids' ></div></div>
<div id="target1" style="displiay:none" >
  <table height="72" cellpadding="0" cellspacing="0" class="l-table-edit" >
    <tr>
  	  	<td width="59"   align="right" class="l-table-edit-td">开始日期:</td>
    	<td width="128"   align="left" class="l-table-edit-td"><input type="text" id="stime" name="stime" /></td>
    	<td colspan="2" align="right" class="l-table-edit-td">开始时间:</td>
  	  	<td width="201"  colspan="2" align="left" class="l-table-edit-td"><input type="text" id="etime" name="etime" /></td>
	</tr>
    <tr>
      <td align="right" class="l-table-edit-td">用户号:</td>
      <td align="left" class="l-table-edit-td"><input type="text" id="sid" name="sid" value="<%=sid%>" /></td>
      <td colspan="2" align="right" class="l-table-edit-td">&nbsp;</td>
      <td colspan="2" align="left" class="l-table-edit-td">&nbsp;</td>
    </tr>
</table> 
 </div>
</form> 
</body>
</html>
