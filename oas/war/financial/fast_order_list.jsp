<%@page language="java" contentType="text/html;charset=UTF-8" %><%@ include file="/common/taglibs.jsp"%>
<%
	String action = "fastOrder";
	String title = "查询";
	String url = action+"?t="+Utils.getSystemMillis();
	String fso_stime = request.getParameter("fso_stime");
	if(fso_stime==null) fso_stime = (String)session.getAttribute("fso_stime");
	String fso_etime = request.getParameter("fso_etime"); 
	if(fso_etime==null) fso_etime = (String)session.getAttribute("fso_etime");
	if(Utils.isNull(fso_stime)||Utils.isNull(fso_etime)){
		fso_stime = Utils.getAddDate(Utils.getNowDate(),-30)+" 00:00";
		fso_etime = Utils.getNowDate()+" 23:59";
	}else{
		session.setAttribute("fso_stime",fso_stime);
		session.setAttribute("fso_etime",fso_etime);
	}
	String usertype = (String)session.getAttribute(Config.USER_TYPE);
	int utype = 1;
	if(usertype!=null)
		utype = Integer.valueOf(usertype);
	
	String fso_pnr = request.getParameter("fso_pnr");
	if(Utils.isNull(fso_pnr)){
		fso_pnr = "";
	}else{
		fso_pnr = java.net.URLDecoder.decode(fso_pnr,"UTF-8");
	}
	String fso_clientid = request.getParameter("fso_clientid");
	if(Utils.isNull(fso_clientid)){
		fso_clientid = "";
	}
	String fso_name = request.getParameter("fso_name");
	if(!Utils.isNull(fso_name)){
		fso_name = java.net.URLDecoder.decode(fso_name,"UTF-8");
	}else{
		fso_name = "";
	}
 
	String fso_company = request.getParameter("fso_company");
	if(Utils.isNull(fso_company)){
		fso_company = "";
	}else{
		fso_company = java.net.URLDecoder.decode(fso_company,"UTF-8");
	}
	
	String queryName = "&customer.name="+fso_name+"&customer.company="+fso_company+"";
	String term = "query.stime="+fso_stime+"&query.etime="+fso_etime+"&order.pnr="+fso_pnr+"&customer.customerID="+fso_clientid+"";

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
			$("#stime").ligerDateEditor({ showTime: true,initValue:'<%=fso_stime%>'});
        	$("#etime").ligerDateEditor({ showTime: true,initValue:'<%=fso_etime%>'}); 
        	
        	$("#auditType").ligerComboBox({
                data: [
	                { id: <%=Config.STATE_AUDIT_SUC%>, text: '审核通过' },
	                { id: <%=Config.STATE_AUDIT_FAIL%>, text: '审核不通过' }
                ], valueFieldID: 'type1'
            });
        	$("#auditType").ligerGetComboBoxManager().setValue(<%=Config.STATE_AUDIT_SUC%>);
	  		$("form").ligerForm();
	  		var url1 = '<%=url%>&<%=term%>'+encodeURI(encodeURI('<%=queryName%>'));
	  		
	  		var x = $.getJSON(url1,
	  	            function(json) 
	  	            {
	  			datas=json;
            eval(      
                 "myGrid= $('#grids').ligerGrid({"+
        		 "checkbox: true,"+
                 "columns:[	{ display: 'ID', name: 'fastOrderId', width: 150, type: 'int' },"+
			                 "{ display: '关联订单编码', name: 'relaOrderId', width :180 },"+
			                 "{ display: 'PNR', name: 'pnr' },"+
			                 "{ display: '客户编码', name: 'customerId' },"+
                             "{ display: '客户名称', name: 'name' },"+
                             "{ display: '公司名称', name: 'company' },"+
                             "{ display: '转账类型', name: 'type',render: function (rowdata, rowindex){"+
	                         	"if(rowdata.type=='0'){"+
	                         		"return '订票';"+
	                         	"}else if(rowdata.type=='1'){"+
	                         		"return '退票';"+
	                         	"}"+
	                          "}},"+
                             "{ display: '处理状态', name: 'state',render: function (rowdata, rowindex){"+
                            	"if(rowdata.state=='0'){"+
                            		"return '新建';"+
                            	"}else if(rowdata.state=='1'){"+
                            		"return '提交审核中';"+
                            	"}else if(rowdata.state=='2'){"+
                            		"return '审核通过';"+
                            	"}else if(rowdata.state=='3'){"+
                            		"return '审核不通过';"+
                            	"}else if(rowdata.state=='4'){"+
                            		"return '完成';"+
                            	"}"+
                             "}},"+
                             "{ display: '收款状态', name: 'receivedState',render: function (rowdata, rowindex){"+
	                         	"if(rowdata.receivedState=='0'){"+
	                         		"return '未收款';"+
	                         	"}if(rowdata.receivedState=='1'){"+
	                         		"return '已收款';"+
	                         	"}if(rowdata.receivedState=='2'){"+
	                         		"return '部分收款';"+
	                         	"}else if(rowdata.receivedState=='3'){"+
	                         		"return '已结转';"+
	                         	"}"+
	                          "}},"+
                             "{ display: '订单状态', name: 'orderState',render: function (rowdata, rowindex){"+
	                         	"if(rowdata.orderState=='0'){"+
	                         		"return '启用';"+
	                         	"}else if(rowdata.orderState=='1'){"+
	                         		"return '作废';"+
	                         	"}"+
	                          "}},"+
                             "{ display: '应收款', name: 'recmoney', width: 150 },"+
                             "{ display: '应付款', name: 'paymoney', width: 120,type:'float' },"+
                             "{ display: '利润', name: 'profit', width: 120,type:'float' },"+
                             "{ display: '说明', name: 'mark' },"+
                             "{ display: '创建人', name: 'userName' },"+
                             "{ display: '创建时间', name: 'createTime' },"+
                             "{ display: '最后操作人', name: 'luserName' },"+
                             "{ display: '最后操作时间', name: 'updateTime' }"+
                             "], "+
                             "isScroll: true, showToggleColBtn: false, width: '100%',"+
                             "height:'98%',"+
                             "data:datas,"+    
                             "usePager : false,"+
                             "method : 'post',"+
                 			 "showTitle: false, columnWidth: 100  , frozen:false,"+
                 			 "toolbar: { items: [{ text: '开始时间：<%=fso_stime%>'},{ line:true },"+
				          					   "{ text: '结束时间：<%=fso_etime%>'},{ line:true },"+
				          					   "{ text: '自定义查询',click:f_inputQuery, icon: 'search2'},{ line:true },"+
                 							   "{ text: '添加',click:f_addTransfer, icon: 'plus',id : 'add'},{ line:true },"+          
					                           "{ text: '提交',click:f_submitTransfer, icon: 'edit',id : 'submit'},{ line:true },"+
					                           
					                           <%if((utype==Config.USER_TYPE_TOP_MANERGER||utype==Config.USER_TYPE_FINANCE_MANERGER)){%>
					                           "{ text: '审核',click:f_auditTransfer, icon: 'edit',id : 'audit'},{ line:true },"+
					                           <%}%>
					                           "{ text: '删除',click:f_delTransfer, icon: 'delete',id : 'del'},{ line:true },"+
					                           
					                           <%if((utype==Config.USER_TYPE_TOP_MANERGER||utype==Config.USER_TYPE_FINANCE_MANERGER)){%>
					                           "{ text: '作废',click:f_cancelTransfer, icon: 'delete',id : 'del'},{ line:true },"+
					                           <%}%>
                                               "{ text: '导出Excel', id : 'orderSumbit' ,click: downloadThis, icon: 'add' ,icon: 'save' }"+
                                               "]"+
                                               "},"+
                                               "onDblClickRow:f_onSelectRow,isChecked: f_isChecked, onCheckRow: f_onCheckRow, onCheckAllRow: f_onCheckAllRow, totalRender: f_totalRender"+         
             "});"
            );
	  	          }); 
    });
    function f_onSelectRow(data, rowindex, rowobj){
 		form1.action = "fastOrder?action=view&fastOrderId="+data.fastOrderId;
		form1.submit();
 	}
	
	function f_totalRender()
        {
            return datas.totalRender; 
        }
	
	
	function submitThis(){
		form1.action = "<%=jspName%>"; 
		form1.submit();
	}
	
	function f_submitTransfer(){
		if(checkedTransfer.length==0){
			 $.ligerDialog.warn('<br/>请选择一张单子');
			 return ;	
		}
		var flag = true;
		var delObj = [];
		var fastOrderIds = new Array();
		for(var i=0;i<checkedTransfer.length;i++){
			if(checkedTransfer[i].state!=0){
				flag = false;
			}
			fastOrderIds.push(checkedTransfer[i].fastOrderId);
			delObj.push(checkedTransfer[i]);
		}
		if(!flag){
			for(var i=0;i<delObj.length;i++){
            	removeCheckedTransfer(delObj[i]);
    		}
			$.ligerDialog.warn('<br/>请选择状态为新建的单子!');
			return ;	
		}
    	if(confirm("确定要提交选中的记录吗？")){
    		var url2="fastOrder?action=sm&fastOrder.fastOrderIds="+fastOrderIds.join()+"&query.stime=<%=fso_stime%>&query.etime=<%=fso_etime%>";
	   	    $.getJSON(url2,function(json){
			  	myGrid.set({ data: json });
            })
            for(var i=0;i<delObj.length;i++){
            	removeCheckedTransfer(delObj[i]);
    		}
    	}
    	
	}
	
 	function downloadThis(){
		form1.action = "../common/download.jsp?name=<%=jspName%>"; 
		form1.fb.value = getDatasValue(datas);	
		form1.submit();
	}
 	
 	function f_inputQuery(){
 		clearQuery();
		$.ligerDialog.open({ target: $("#target1"),title:'<%=title%>',height: 300,width: 500,isResize: true,showMax:true, 
			buttons: [
			{ text: '清空', 
			onclick: function (item, dialog) {
				//$("#stime").val("");
				//$("#etime").val("");
				clearQuery();
			} },
			{ text: '确定', 
				onclick: function (item, dialog) {
					var url = '<%=jspName%>?fso_stime='+ $("#stime").val()
					 	+'&fso_etime='+$("#etime").val()+'&fso_pnr='+ encodeURI(encodeURI($("#pnr").val()))+'&fso_clientid='+ $("#clientid").val()+'&fso_company='+ encodeURI(encodeURI($("#company").val()))+'&fso_name='+ encodeURI(encodeURI($("#name").val()));
					
					location.href = url;
				} },
			{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
    }

    function clearQuery(){
    	$("#orderCode").val("");
		$("#pnr").val("");
		$("#clientid").val("");
		$("#name").val("");
    }
	
	 function f_onCheckAllRow(checked)
        {	 
            for (var rowid in this.records)
            {
                if(checked)
                    addCheckedTransfer(this.records[rowid]);
                else
                    removeCheckedTransfer(this.records[rowid]);
            }
        }
 
        var checkedTransfer = [];
        function findCheckedTransfer(obj)
        {
            for(var i =0;i<checkedTransfer.length;i++)
            {
                if(checkedTransfer[i] == obj) return i;
            }
            return -1;
        }
        function addCheckedTransfer(obj)
        {
            if(findCheckedTransfer(obj) == -1)
                checkedTransfer.push(obj);
        }
        function removeCheckedTransfer(obj)
        {
            var i = findCheckedTransfer(obj);
            if(i==-1) return;
            checkedTransfer.splice(i,1);
        }
        function f_isChecked(rowdata)
        {
            if (findCheckedTransfer(rowdata) == -1)
                return false;
            return true;
        }
        function f_onCheckRow(checked, data)
        {
            if (checked) addCheckedTransfer(data);
            else removeCheckedTransfer(data);
        }
        function f_getChecked()
        {
            alert(checkedTransfer.join(','));
        }
        function f_addTransfer(){
				location.href = "<%=editJsp%>?action=add" ;  
	    }
		function f_editTransfer(){
			if(checkedTransfer.length==0){
				 $.ligerDialog.warn('<br/>请选择一张单子');
				 return ;	
			}else if(checkedTransfer.length>1){
				$.ligerDialog.warn('<br/>您选择了'+checkedTransfer.length+'张单子<br/><br/>请选择单张单子');
				return;
			}	
			form1.action = "<%=action%>?action=display&transfer.transferId="+checkedTransfer[0].transferId+"";
			form1.submit();   
        }
		
		function f_auditTransfer(){
			if(checkedTransfer.length==0){
				 $.ligerDialog.warn('<br/>请选择一张单子');
				 return ;	
			}
			var delObj = [];
			var fastOrderIds = new Array();
			var flag = true;
			for(var i=0;i<checkedTransfer.length;i++){
				if(checkedTransfer[i].state!=1){
					flag = false;
				}
				fastOrderIds.push(checkedTransfer[i].fastOrderId);
				delObj.push(checkedTransfer[i]);
			}
			if(!flag){
				for(var i=0;i<delObj.length;i++){
	            	removeCheckedTransfer(delObj[i]);
	    		}
				$.ligerDialog.warn('<br/>请选择状态为待审核的单子!');
				return ;	
			}
	    	$.ligerDialog.open({ target: $("#target2"),title:'审核',height: 120,width: 250,isResize: true,showMax:true, 
			buttons: [
				{ text: '确定', 
				onclick: function (item, dialog) {
					var state = $("#type1").val();
					var remark = $("#remark").val();
	    			var url2="fastOrder?action=audit&fastOrder.state="+state+"&fastOrder.fastOrderIds="+fastOrderIds.join()+"&query.stime=<%=fso_stime%>&query.etime=<%=fso_etime%>";
					$.getJSON(url2,function(json){
						myGrid.set({ data: json });
             		});
					for(var i=0;i<delObj.length;i++){
		            	removeCheckedTransfer(delObj[i]);
		    		}
					dialog.hide();
				} },
			{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
		}

       	function f_inputOrderOffset(){
       		 $.ligerDialog.prompt('请输入用户ID,不输入则查询全部','', function (yes, value)
             {
                      	if (yes){
                         	f_findUser(value);
                        }
             });
       	}
        
        function f_delTransfer()
        {
        	if(checkedTransfer.length==0){
				 $.ligerDialog.warn('<br/>请选择一张单子');
				 return ;	
			}else if(checkedTransfer.length>1){
				$.ligerDialog.warn('<br/>您选择了'+checkedTransfer.length+'张单子<br/><br/>请选择单张单子');
				return;
			}
        	if(checkedTransfer[0].state==2){
				 $.ligerDialog.warn('<br/>不能删除审核通过的单子');
				 return ;	
			}
			if(confirm('确定要删除选中的记录吗？')){
             	form1.action = "<%=action%>?action=delete&fastOrderId="+checkedTransfer[0].fastOrderId+"";
				form1.submit();   
            }
        }
        function f_cancelTransfer()
        {
        	if(checkedTransfer.length==0){
				 $.ligerDialog.warn('<br/>请选择一张单子');
				 return ;	
			}else if(checkedTransfer.length>1){
				$.ligerDialog.warn('<br/>您选择了'+checkedTransfer.length+'张单子<br/><br/>请选择单张单子');
				return;
			}

			if(checkedTransfer[0].state==0||checkedTransfer[0].state==1){
				$.ligerDialog.warn('<br/>新建或未审核的单子不支持作废，如需作废请删除！');
				 return ;
			}
        	
			if(confirm('确定要作废选中的记录吗？')){
             	form1.action = "<%=action%>?action=cancel&fastOrder.state="+checkedTransfer[0].state+"&fastOrder.orderid="+checkedTransfer[0].fastOrderId+"";
				form1.submit();   
            }
        }
</script>
	 
</head>
<body style="padding:0 2px 2px 2px;overflow:hidden;" >
<form name="form1" method="post" id="form1">
<textarea name="fb"  style="display:none" ></textarea> 
</form> 
<div >
<div id='grids' ></div></div>
<div id="target1" style="display:none" >
  <table height="72" cellpadding="0" cellspacing="0" class="l-table-edit" >
    <tr>
  	  	<td width="59"   align="right" class="l-table-edit-td">开始时间:</td>
    	<td width="128"   align="left" class="l-table-edit-td"><input type="text" id="stime" name="stime" /></td>
    	<td colspan="2" align="right" class="l-table-edit-td">结束时间:</td>
  	  	<td width="201"  colspan="2" align="left" class="l-table-edit-td"><input type="text" id="etime" name="etime" /></td>
	</tr>
    <tr>
      <td align="right" class="l-table-edit-td">PNR:</td>
      <td align="left" class="l-table-edit-td"><input type="text" id="pnr" name="pnr" value="" /></td>
      <td colspan="2" align="right" class="l-table-edit-td">公司名称:</td>
      <td colspan="2" align="left" class="l-table-edit-td"><input type="text" id="company" name="company" value="" /></td>
    </tr>
    <tr>
      <td align="right" class="l-table-edit-td">客户编码:</td>
      <td align="left" class="l-table-edit-td"><input type="text" id="clientid" name="clientid" value="" /></td>
      <td colspan="2" align="right" class="l-table-edit-td">客户名称:</td>
      <td colspan="2" align="left" class="l-table-edit-td"><input type="text" id="name" name="name" value="" /></td>
    </tr>
</table> 
</div>
<div id="target2" style="display:none" >
  <table height="72" cellpadding="0" cellspacing="0" class="l-table-edit" >
    <tr>
  	  	<td align="right" class="l-table-edit-td">审核操作:</td>
      	<td align="left" class="l-table-edit-td"><input name="auditType" type="text" id="auditType" ltype="text"  value="" /></td>
    </tr>
</table> 
</div>
</body>
</html>
