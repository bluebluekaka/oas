<%@page language="java" contentType="text/html;charset=UTF-8" %><%@ include file="/common/taglibs.jsp"%>
<%
	String action = "query";
	String title = "转账单查询";
	String url = action+"?moduleName=transfer&t="+Utils.getSystemMillis();
    
	String transfer_stime = request.getParameter("transfer_query_stime");
	if(transfer_stime==null) transfer_stime = (String)session.getAttribute("transfer_stime");
	String transfer_etime = request.getParameter("transfer_query_etime"); 
	if(transfer_etime==null) transfer_etime = (String)session.getAttribute("transfer_etime");
	if(Utils.isNull(transfer_stime)||Utils.isNull(transfer_etime)){
		transfer_stime = Utils.getAddDate(Utils.getNowDate(),-1)+" 00:00";
		transfer_etime = Utils.getNowDate()+" 23:59";
	}else{
		session.setAttribute("transfer_query_stime",transfer_stime);
		session.setAttribute("transfer_query_etime",transfer_etime);
	}
 
	String transfer_clientid = request.getParameter("transfer_query_clientid");
	if(transfer_clientid==null) transfer_clientid = (String)session.getAttribute("transfer_query_clientid");
	if(Utils.isNull(transfer_clientid)){
		transfer_clientid = "";
	}else{
		session.setAttribute("transfer_query_clientid",transfer_clientid);
	}
	String usertype = (String)session.getAttribute(Config.USER_TYPE);
	int utype = 1;
	if(usertype!=null)
		utype = Integer.valueOf(usertype);
	String term = "query.stime="+transfer_stime+"&query.etime="+transfer_etime+"&customer.customerID="+transfer_clientid+"";
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
			$("#stime").ligerDateEditor({ showTime: true,initValue:'<%=transfer_stime%>'});
        	$("#etime").ligerDateEditor({ showTime: true,initValue:'<%=transfer_etime%>'}); 
        	
	  		$("form").ligerForm();
	  		var url1 = '<%=url%>&<%=term%>';

            eval(      
                 "myGrid= $('#grids').ligerGrid({"+
                 "columns:[	{ display: '编号', name: 'transferId', width: 150, type: 'int' },"+
                             "{ display: '客户编码', name: 'customerId' },"+
                             "{ display: '客户名称', name: 'customerName' },"+
                             "{ display: '公司名称', name: 'company' },"+
                             "{ display: '转账类型', name: 'transferType',render: function (rowdata, rowindex){"+
	                         	"if(rowdata.transferType=='1'){"+
	                         		"return '票款';"+
	                         	"}else if(rowdata.transferType=='2'){"+
	                         		"return '其他费用';"+
	                         	"}"+
	                          "}},"+
                             "{ display: '状态', name: 'transferState',render: function (rowdata, rowindex){"+
                            	"if(rowdata.transferState=='0'){"+
                            		"return '新建';"+
                            	"}else if(rowdata.transferState=='1'){"+
                            		"return '审核中';"+
                            	"}else if(rowdata.transferState=='2'){"+
                            		"return '审核通过';"+
                            	"}else if(rowdata.transferState=='3'){"+
                            		"return '审核不通过';"+
                            	"}else if(rowdata.transferState=='4'){"+
                            		"return '完成';"+
                            	"}"+
                             "}},"+
                             "{ display: '转账账号', name: 'transferAccount', width: 150 },"+
                             "{ display: '转账金额', name: 'transferAmount', width: 120,type:'float' },"+
                             "{ display: '可用金额', name: 'usableAmount', width: 120,type:'float' },"+
                             "{ display: '说明', name: 'remark', width: 150 },"+
                             "{ display: '创建人', name: 'userName' },"+
                             "{ display: '创建时间', name: 'createTime' },"+
                             "{ display: '最后操作人', name: 'luserName' },"+
                             "{ display: '最后操作时间', name: 'updateTime' }"+
                             "], "+
                             "isScroll: true, showToggleColBtn: false, width: '100%',"+
                             "height:'98%',"+
                             "url: url1,"+
                             "method : 'post',"+
                 			 "showTitle: false, columnWidth: 100  , frozen:false,"+
                 			 "toolbar: { items: [{ text: '开始时间：<%=transfer_stime%>'},{ line:true },"+
				          					   "{ text: '结束时间：<%=transfer_etime%>'},{ line:true },"+
				          					   "{ text: '自定义查询',click:f_inputQuery, icon: 'search2'},{ line:true }"+
                                               "]"+
                                               "},"+
                                               "onDblClickRow : f_onSelectRow,isChecked: f_isChecked, onCheckRow: f_onCheckRow, onCheckAllRow: f_onCheckAllRow, totalRender: f_totalRender"+         
             "});"
            ); 
    });
	
	function f_totalRender(data, currentPageData)
        {
            return data.totalRender; 
        }
	
	
	function submitThis(){
		form1.action = "<%=jspName%>"; 
		form1.submit();
	}
	
	function f_onSelectRow(data, rowindex, rowobj){
 		form1.action = "transfer?action=view&transfer.transferId="+data.transferId;
		form1.submit();
 	}
	
 	function downloadThis(){
		form1.action = "../common/download.jsp?name=<%=jspName%>"; 
		form1.fb.value = getDatasValue(datas);	
		form1.submit();
	}
 	
 	function f_onSelectRow(data, rowindex, rowobj){
 		var qurl = "<%=action%>?action=view&transfer.transferId="+data.transferId+"";
		$.ligerDialog.open({ title:'查看',name:'wins',url: qurl,height: 420,width: 700,isResize: true,showMax:true, 
			buttons: [ { text: '确定', onclick: function (item, dialog) { dialog.hide(); } } ] });
 	}
 	
 	function f_inputQuery(){
		$.ligerDialog.open({ target: $("#target1"),title:'<%=title%>',height: 300,width: 500,isResize: true,showMax:true, 
			buttons: [
			{ text: '清空', 
			onclick: function (item, dialog) {
				//$("#stime").val("");
				//$("#etime").val("");
				$("#orderCode").val("");
				$("#pnr").val("");
 				$("#type").ligerGetComboBoxManager().setValue(<%=Config.ORDER_TYPE_ALL%>);
			} },
			{ text: '确定', 
				onclick: function (item, dialog) {
					var url = '<%=jspName%>?transfer_query_stime='+ $("#stime").val()
					 	+'&transfer_query_etime='+$("#etime").val()+'&transfer_query_orderCode='+ $("#orderCode").val()+'&transfer_query_pnr='+ $("#pnr").val()+'&transfer_query_clientid='+ $("#clientid").val()+'&transfer_query_type='+ $("#type0").val();
					
					location.href = url;
				} },
			{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
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
			}
			var transferIds = new Array();
			for(var i=0;i<checkedTransfer.length;i++){
				transferIds.push(checkedTransfer[i].transferId);
			}
        	
			if(confirm('确定要删除选中的记录吗？')){
             	form1.action = "<%=action%>?action=delete&transfer.transferIds="+transferIds.join()+"";
				form1.submit();   
            }
        }
        function doCommit(){
        	var row = myGrid.getSelectedRow();
        	if(!row){
             	$.ligerDialog.warn('<br/>请选择一张转账单');
    		 	return 'error';
            }
            return row;
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
</table> 
</div>
</body>
</html>
