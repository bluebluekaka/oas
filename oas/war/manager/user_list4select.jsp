<%@page language="java" contentType="text/html;charset=UTF-8" %><%@ include file="/common/taglibs.jsp"%>
<%
	String id = request.getParameter("id");
	String action = "user";
	String url = action+"?t="+Utils.getSystemMillis();
	if(id!=null) url += "&user.uid="+id;
	else id = "";	
	String editJsp = jspName.replace("list","info");
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
    $(function () {   
	  		$("form").ligerForm();
            $.getJSON('<%=url%>',
            function(json) 
            {
                var colnames="";
                for(var i in json.Rows[0])  
                {
   	             		var hides='';
                        if(i=='HideID') 
                        	hides = ',hide:true';
                        colnames+=",{name:'"+i+"',display:'"+i+"',width: 120" + hides +"}";
                }
                colnames=colnames.substr(1,colnames.length);
                datas=json;
                eval(                
                        "grid=$('#grids').ligerGrid({"+
                        "checkbox: true,"+
                        "columns:["+colnames+"],"+   
                        "data:datas,"+    
                        "dataAction:'local',"+
                        "height: '100%',"+
                        "pageSize:<%=Config.PAGE_SIZE%>,"+
                        "toolbar: { items: ["+
                        "{ text: '查询',click:f_inputUser, icon: 'search2'},{ line:true }"+
                        "]},"+
                        "totalRender: f_totalRender,"+
                        "heightDiff:-12,"+
                        "isChecked: f_isChecked, onCheckRow: f_onCheckRow, onCheckAllRow: f_onCheckAllRow"+
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
		form1.action = "../common/download.jsp?name=<%=jspName%>"; 
		form1.fb.value = getDatasValue(datas);	
		form1.submit();
	}
	
	 function f_onCheckAllRow(checked)
        {	 
            for (var rowid in this.records)
            {
                if(checked)
                    addCheckedCustomer(this.records[rowid]['HideID']);
                else
                    removeCheckedCustomer(this.records[rowid]['HideID']);
            }
        }
 
        var checkedCustomer = [];
        function findCheckedCustomer(HideID)
        {
            for(var i =0;i<checkedCustomer.length;i++)
            {
                if(checkedCustomer[i] == HideID) return i;
            }
            return -1;
        }
        function addCheckedCustomer(HideID)
        {
            if(findCheckedCustomer(HideID) == -1)
                checkedCustomer.push(HideID);
        }
        function removeCheckedCustomer(HideID)
        {
            var i = findCheckedCustomer(HideID);
            if(i==-1) return;
            checkedCustomer.splice(i,1);
        }
        function f_isChecked(rowdata)
        {
            if (findCheckedCustomer(rowdata.HideID) == -1)
                return false;
            return true;
        }
        function f_onCheckRow(checked, data)
        {
            if (checked) addCheckedCustomer(data.HideID);
            else removeCheckedCustomer(data.HideID);
        }
        function f_getChecked()
        {
            alert(checkedCustomer.join(','));
        }
        function f_addUser(){
			location.href = "<%=editJsp%>?action=add" ;      
        }
		function f_editUser(){
			if(checkedCustomer.length==0){
				 $.ligerDialog.warn('<br/>请选择一个用户');
				 return ;	
			}else if(checkedCustomer.length>1){
				$.ligerDialog.warn('<br/>您选择了'+checkedCustomer.length+'个用户<br/><br/>请选择单个用户');
				return;
			}
			form1.action = "<%=action%>?action=display&sid="+checkedCustomer;
			form1.submit();   
        }

       	function f_inputUser(){
       		 $.ligerDialog.prompt('请输入用户ID,不输入则查询全部','', function (yes, value)
             {
                      	if (yes){
                         	f_findUser(value);
                        }
             });
       	}
        
        function f_findUser(uid){
			location.href = '<%=jspName%>?id='+uid;
        }
        function f_delUser()
        {
        	if(checkedCustomer.length==0){
				 $.ligerDialog.warn('<br/>请选择一个用户');
				 return ;	
			} 
			if(checkedCustomer.length>1){
				 $.ligerDialog.warn('<br/>你选择了多个用户,请选择单个用户');
				 return ;	
			}
			$.ligerDialog.confirm('<br/>确定要删除'+checkedCustomer+'用户吗？',
                 	function (yes) {
	                 	if(yes==true) {
	                 		form1.action = "<%=action%>?action=delete&sid="+checkedCustomer.join("','");
							form1.submit();   
	                 	}
                 	} 
            );
            //alert(checkedCustomer.join(','));
        }
		function getSelceted(){
			var rows = grid.getCheckedRows();
			var str = "";
            /* $(rows).each(function ()
            {
                alert(this);
            }); */
			 
			if(checkedCustomer.length==0){
				 $.ligerDialog.warn('<br/>请选择一个用户');
				 return 'error';	
			}else if(checkedCustomer.length>1){
				$.ligerDialog.warn('<br/>您选择了'+checkedCustomer.length+'个用户<br/><br/>请选择单个用户');
				return 'error';
			}
			return (checkedCustomer); 
        }
</script>
	 
</head>
<body style="padding:0 2px 2px 2px;overflow:hidden;" >
<form name="form1" method="post" id="form1">
<textarea name="fb"  style="display:none" ></textarea> 
<textarea id="uid" name="id"  style="display:none" ><%=id%></textarea> 
<!-- 
<div class="l-menubar"  >
	<table border="0"  style="margin-top:1px;"   ><tr><td width="40" align="right">HideID：</td><td><input id="uid" name="id" type="text" value="<%=id%>" /></td>
	 <td width="80" align="right" >
    <input type="button" value="查询" id="Button1" class="l-button l-button-submit" onclick="f_findUser()" /></td>
     <td width="80" align="right" >
    <input type="button" value="添加" id="Button3" class="l-button l-button-submit" onclick="f_addUser()" /></td>
     <td width="80" align="right" >
    <input type="button" value="修改" id="Button4" class="l-button l-button-submit" onclick="f_editUser()" /></td>
     <td width="80" align="right" >
    <input type="button" value="删除" id="Button5" class="l-button l-button-submit" onclick="f_delUser()" /></td>
    <td width="80" align="right"  >
    <input type="button" value="导出" id="Button2" class="l-button l-button-submit" onclick="downloadThis()" /></td></tr>
</table></div>
-->
</form> 
<div >
<div id='grids' ></div></div>
</body>
</html>
