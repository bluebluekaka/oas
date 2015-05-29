<%@page contentType="text/html;charset=UTF-8" language="java" import="java.util.*"%><%@ include file="../common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>
</title>
    <link href="../ui/lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" /> 
    <link href="../ui/lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    <link href="../ui/lib/ligerUI/skins/Gray/css/dialog.css" rel="stylesheet" type="text/css" />
	<script src="../ui/lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>  
	<script src="../ui/lib/ligerUI/js/ligerui.all.min.js" type="text/javascript"></script> 
    <script src="../ui/lib/jquery-validation/jquery.validate.min.js" type="text/javascript"></script> 
    <script src="../ui/lib/jquery-validation/jquery.metadata.js" type="text/javascript"></script> 
    <script src="../ui/lib/jquery-validation/messages_cn.js" type="text/javascript"></script> 
    <script type="text/javascript"> 
        var eee;
		
        $(function () {	
		 	$("form").ligerForm();	  
		});
    	function getID(){
			var qurl = 'user_list4select.jsp?query=true';
			$.ligerDialog.open({ title:'查询',name:'wins',url: qurl,height: 500,width: 700,isResize: true,showMax:true, 
				buttons: [
				{ text: '确定', 
					onclick: function (item, dialog) {
						var values = document.getElementById('wins').contentWindow.getSelceted(); 
					 	if(values!='error'){
						$("#userid").attr("value",values);	
						dialog.close(); }
					} },
				{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
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

    <form name="form1" method="post" class="l-form" id="form1" action="order" >

<div class="l-group l-group-hasicon">
<img src="../ui/lib/ligerUI/skins/icons/communication.gif"/>
<span>
<h2>查询</h2></span>
</div>
<div id="errorLabelContainer" class="l-text-invalid">
</div>
 <textarea id="action" name="action" style=" display:none;" ><s:property value='action'/></textarea>
<table  width="850" cellpadding="0" cellspacing="0" class="l-table-edit"  >
 
<tr>
              <td align="right" class="l-table-edit-td">用户ID:</td>
              <td align="left" class="l-table-edit-td"><input name="user.userid" id="userid" ltype="text" value="" /></td>
              <td align="left"></td>
              <td  class="l-table-edit-td"><input type="button" value="选择用户" id="Button2" class="l-button l-button-submit" onclick="getID()" /></td>
          
            </tr>


      </table>
 

 
</form>
    <div style="display:none">
    <!--  数据统计代码 --></div>

    
</body>
</html>