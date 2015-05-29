<%@page language="java" contentType="text/html;charset=UTF-8" %><%@ include file="/common/taglibs.jsp"%>
<%
	String id = request.getParameter("id");
	String action = "otherExpenses";
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
    		$("#type").ligerComboBox({
                data: [
	                { id: <%=Config.OTHER_EXPENSES_RELA_ORDER_ADJUSTMENT%>, text: '调整金额' },
	                { id: <%=Config.OTHER_EXPENSES_RELA_ORDER_FEES%>, text: '杂费' }
                ], valueFieldID: 'type0'
            });
        	$("#type").ligerGetComboBoxManager().setValue(<%=Config.OTHER_EXPENSES_RELA_ORDER_TRANSFER%>);
	  		$("form").ligerForm();
            $.getJSON('<%=url%>',
            function(json) 
            {
                var colnames="";
                for(var i in json.Rows[0])  
                {
   	             		var hides='';
                        if(i=='HideID'){
                        	hides = ',hide:true';
                        }
                        	
                        colnames+=",{name:'"+i+"',display:'"+i+"',width: 150" + hides +"}";
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
                        "{ text: '添加',click:f_addOtherExpenses, icon: 'plus'},{ line:true }"+
                        ",{ text: '修改',click:f_editOtherExpenses, icon: 'edit'},{ line:true }"+
                        ",{ text: '删除',click:f_delOtherExpenses, icon: 'delete'},{ line:true }"+
                        ",{ text: '导出Excel',click:downloadThis,icon: 'save'}"+
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
                    addCheckedOtherExpenses(this.records[rowid]['HideID']);
                else
                    removeCheckedOtherExpenses(this.records[rowid]['HideID']);
            }
        }
 
        var checkedOtherExpenses = [];
        function findCheckedOtherExpenses(obj)
        {
            for(var i =0;i<checkedOtherExpenses.length;i++)
            {
                if(checkedOtherExpenses[i] == obj) return i;
            }
            return -1;
        }
        function addCheckedOtherExpenses(obj)
        {
            if(findCheckedOtherExpenses(obj) == -1)
                checkedOtherExpenses.push(obj);
        }
        function removeCheckedOtherExpenses(obj)
        {
            var i = findCheckedOtherExpenses(obj);
            if(i==-1) return;
            checkedOtherExpenses.splice(i,1);
        }
        function f_isChecked(rowdata)
        {
            if (findCheckedOtherExpenses(rowdata) == -1)
                return false;
            return true;
        }
        function f_onCheckRow(checked, data)
        {
            if (checked) addCheckedOtherExpenses(data);
            else removeCheckedOtherExpenses(data);
        }
        function f_getChecked()
        {
            alert(checkedOtherExpenses.join(','));
        }
        function f_addOtherExpenses(){
        	$.ligerDialog.open({ target: $("#target2"),title:'选择其他费用类型',height: 120,width: 350,isResize: true,showMax:true, 
				buttons: [
				{ text: '确定', 
					onclick: function (item, dialog) {
						var type = $("#type0").val();
						var jsp = "<%=jspName%>";
						if(type==0){
							jsp = jsp.replace("list","info1");
						}else if(type==1||type==3){
							jsp = jsp.replace("list","info2");
						}else if(type==2){
							jsp = jsp.replace("list","info3");
						}
						location.href = jsp+"?action=add&type="+type ; 
					} },
				{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
	    }
		function f_editOtherExpenses(){
			if(checkedOtherExpenses.length==0){
				 $.ligerDialog.warn('<br/>请选择一笔费用');
				 return ;	
			}else if(checkedOtherExpenses.length>1){
				$.ligerDialog.warn('<br/>您选择了'+checkedOtherExpenses.length+'笔费用<br/><br/>请选择单笔费用');
				return;
			}
			if(checkedOtherExpenses[0].otherExpensesType!='2'){
				$.ligerDialog.warn('<br/>请选择票款抵消费用类型的记录');
				return;
			}
			var type = $("#type0").val();
			var jsp = "<%=jspName%>";
			if(type==0){
				jsp = jsp.replace("list","info1");
			}else if(type==1||type==3){
				jsp = jsp.replace("list","info2");
			}else if(type==2){
				jsp = jsp.replace("list","info3");
			}
			alert('<%=action%>')
			form1.action = "<%=action%>?action=display&otherExpensesId="+checkedOtherExpenses[0].HideID;
			form1.submit();   
        }

       	function f_inputOtherExpenses(){
       		 $.ligerDialog.prompt('请输入用户ID,不输入则查询全部','', function (yes, value)
             {
                      	if (yes){
                         	f_findUser(value);
                        }
             });
       	}
        
        function f_findOtherExpenses(uid){
			location.href = '<%=jspName%>?id='+uid;
        }
        function f_delOtherExpenses()
        {
        	if(checkedOtherExpenses.length==0){
				 $.ligerDialog.warn('<br/>请选择一笔费用');
				 return ;	
			} 
			if(checkedOtherExpenses.length>1){
				 $.ligerDialog.warn('<br/>你选择了多笔费用,请选择单笔费用');
				 return ;	
			}
			$.ligerDialog.confirm('<br/>确定要删除'+checkedOtherExpenses[0].HideID+'费用吗？',
                 	function (yes) {
	                 	if(yes==true) {
	                 		form1.action = "<%=action%>?action=delete&type="+checkedOtherExpenses[0].otherExpensesType+"&otherExpensesId="+checkedOtherExpenses[0].HideID;
							form1.submit();   
	                 	}
                 	} 
            );
            //alert(checkedCustomer.join(','));
        }
</script>
	 
</head>
<body style="padding:0 2px 2px 2px;overflow:hidden;" >
<form name="form1" method="post" id="form1">
<textarea name="fb"  style="display:none" ></textarea> 
<textarea id="uid" name="id"  style="display:none" ><%=id%></textarea>
</form> 
<div >
<div id='grids' ></div></div>
<div id="target2"  >
  <table height="72" cellpadding="0" cellspacing="0" class="l-table-edit" >
    <tr>
  	  	<td align="right" class="l-table-edit-td">其他费用类型:</td>
      	<td align="left" class="l-table-edit-td"><input name="type" type="text" id="type" ltype="text"  value="" /></td>
    </tr>
</table> 
 </div>
</body>
</html>
