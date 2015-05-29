<%@page language="java" contentType="text/html;charset=UTF-8" %><%@ include file="/common/taglibs.jsp"%>
<%
	String financial_stime = request.getParameter("financial_stime");
	if(financial_stime==null) financial_stime = (String)session.getAttribute("financial_stime");
	String financial_etime = request.getParameter("financial_etime"); 
	if(financial_etime==null) financial_etime = (String)session.getAttribute("financial_etime");
	if(Utils.isNull(financial_stime)||Utils.isNull(financial_etime)){
		financial_stime = Utils.getAddDate(Utils.getNowDate(),-30)+" 00:00";
		financial_etime = Utils.getNowDate()+" 23:59";
	}else{
		session.setAttribute("financial_stime",financial_stime);
		session.setAttribute("financial_etime",financial_etime);
	}
	String financial_orderCode = request.getParameter("financial_orderCode");
	if(Utils.isNull(financial_orderCode)){
		financial_orderCode = "";
	}
	String financial_pnr = request.getParameter("financial_pnr");
	if(Utils.isNull(financial_pnr)){
		financial_pnr = "";
	}else{
		financial_pnr = java.net.URLDecoder.decode(financial_pnr,"UTF-8");
	}
	 
	String financial_type = request.getParameter("financial_type");
	if(Utils.isNull(financial_type)){
		financial_type = Config.ORDER_TYPE_ALL+"";
	}
	
	String financial_auditState = request.getParameter("financial_auditState");
	if(Utils.isNull(financial_auditState)){
		financial_auditState = Config.ORDER_TYPE_ALL+"";
	}
 
	String financial_clientid = request.getParameter("financial_clientid");
	if(Utils.isNull(financial_clientid)){
		financial_clientid = "";
	}
	
	String financial_workno = request.getParameter("financial_workno");
	if(Utils.isNull(financial_workno)){
		financial_workno = "";
	}
 
	String financial_custcompany = request.getParameter("financial_custcompany");
	if(Utils.isNull(financial_custcompany)){
		financial_custcompany = "";
	}else{
		financial_custcompany = java.net.URLDecoder.decode(financial_custcompany,"UTF-8");
	}
	String usertype = (String)session.getAttribute(Config.USER_TYPE);
	String workno = (String)session.getAttribute(Config.USER_WORKNO);
	int utype = 1;
	if(usertype!=null)
		utype = Integer.valueOf(usertype);
	if(utype==1||utype==2){
		financial_workno = workno;
	}
	
	String financial_order_state = request.getParameter("financial_order_state");
	if(financial_order_state==null) financial_order_state = (String)session.getAttribute("financial_order_state");
	
	String financial_received_state = request.getParameter("financial_received_state");
	if(financial_received_state==null) financial_received_state = (String)session.getAttribute("financial_received_state");

	session.setAttribute("financial_order_state",financial_order_state);
	session.setAttribute("financial_received_state",financial_received_state);
	
	String queryName = "&order.pnr="+financial_pnr+"&order.custcompany="+financial_custcompany+"";
	String term = "query.stime="+financial_stime+"&query.etime="+financial_etime
	+"&financial.receivedState="+financial_received_state+"&financial.auditState="+financial_auditState
	+"&financial.orderCode="+financial_orderCode+"&financial.orderState="+financial_order_state+"&order.clientid="+financial_clientid+"&workno="+financial_workno+"&order.type="+financial_type;
	String editJsp = jspName.replace("financial_list","other_expenses_info");
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
    		$("#stime").ligerDateEditor({ showTime: true,initValue:'<%=financial_stime%>'});
        	$("#etime").ligerDateEditor({ showTime: true,initValue:'<%=financial_etime%>'}); 
        	$("#type").ligerComboBox({
                data: [
				{ id: <%=Config.ORDER_TYPE_ALL%>, text: '全部' },
                { id: <%=Config.ORDER_TYPE_ORDER%>, text: '订票' },
             	{ id: <%=Config.ORDER_TYPE_CANCEL%>, text: '退票' }
                ], valueFieldID: 'type2'
            });
 			$("#type").ligerGetComboBoxManager().setValue(<%=financial_type%>);
 			
 			$("#auditState").ligerComboBox({
                data: [
                { id: 99, text: '全部' },
				{ id: 0, text: '业务处理中' },
                { id: 1, text: '待审核' },
             	{ id: 2, text: '审核结束' }
                ], valueFieldID: 'type4'
            });
 			$("#auditState").ligerGetComboBoxManager().setValue('99');
    		$("#otherExpensesType").ligerComboBox({
                data: [
	                { id: <%=Config.OTHER_EXPENSES_RELA_ORDER_ADJUSTMENT%>, text: '调整金额' },
	                { id: <%=Config.OTHER_EXPENSES_RELA_ORDER_FEES%>, text: '杂费' }
                ], valueFieldID: 'type0'
            });
        	$("#otherExpensesType").ligerGetComboBoxManager().setValue(<%=Config.OTHER_EXPENSES_RELA_ORDER_ADJUSTMENT%>);
	  		$("#auditType").ligerComboBox({
                data: [
	                { id: <%=Config.STATE_AUDIT_SUC%>, text: '审核通过' },
	                { id: <%=Config.STATE_AUDIT_FAIL%>, text: '审核不通过' }
                ], valueFieldID: 'type1'
            });
        	$("#auditType").ligerGetComboBoxManager().setValue(<%=Config.STATE_AUDIT_SUC%>);
        	$("form").ligerForm();
	  		var url1 = 'financial?'+'<%=term%>'+encodeURI(encodeURI('<%=queryName%>'));
	  		$.getJSON(url1,
	  	            function(json) 
	  	            {
                datas=json;
	  			myGrid= $("#grids1").ligerGrid({
	        		 checkbox: false,
	                 columns:[	{ display: '编号', name: 'financialOrderCode', width: 80},
	                            { display: '关联订单', name: 'orderCode', width: 120 },
	                            { display: '订单状态', name: 'orderType',width: 100,render: function (rowdata, rowindex){
	                            	if(rowdata.orderType=='0'){
	                            		return '订票';
	                            	}else if(rowdata.orderType=='1'){
	                            		return '退票';
	                            	}
	                             }},
	                            { display: 'PNR', name: 'pnr', width: 120 },
	                             { display: '客户编码', name: 'cid', width: 100 },
	                             { display: '客户名称', name: 'name', width: 100 },
	                             { display: '公司名称', name: 'company', width: 120 },
	                             { display: '应收款', name: 'recmoney', width: 100,type:'float' },
	                             { display: '应付款', name: 'paymoney', width: 100,type:'float' },
	                             { display: '利润', name: 'profit', width: 100,type:'float' },
	                             { display: '调整后利润', name: 'adjustProfit', width: 100,type:'float' },
	                             { display: '已收款', name: 'receivedAmount', width: 100,type:'float' },
	                             { display: '收款状态', name: 'receiveState',width: 100,render: function (rowdata, rowindex){
	                            	if(rowdata.receiveState=='0'){
	                            		return '未收款';
	                            	}else if(rowdata.receiveState=='1'){
	                            		return '已收款';
	                            	}else if(rowdata.receiveState=='2'){
	                            		return '部分收款';
	                            	}else if(rowdata.receiveState=='3'){
	                            		return '已结转';
	                            	}
	                             }},
	                             { display: '状态', name: 'orderState',width: 100,render: function (rowdata, rowindex){
	                            	if(rowdata.orderState=='0'){
	                            		return '生效';
	                            	}else if(rowdata.orderState=='1'){
	                            		return '失效';
	                            	}
	                             }},
	                             { display: '审核状态', name: 'auditState',width: 100,render: function (rowdata, rowindex){
	                            	if(rowdata.auditState=='-1'){
		                            	return '业务初始化';
		                            }else if(rowdata.auditState=='0'){
	                            		return '业务处理中';
	                            	}else if(rowdata.auditState=='1'){
	                            		return '待审核';
	                            	}else if(rowdata.auditState=='2'){
	                            		return '审核结束';
	                            	}
	                             }},
	                             { display: '创建人', name: 'userName' },
	                             { display: '创建时间', name: 'createTime' },
	                             //{ display: '添加时间', name: 'createDate' ,width: 150,type:'date',render: function (item){
	                            	//return new Date( item.createDate).pattern("yyyy-MM-dd HH:mm:ss");
	                             //} },
	                             { display: '最后操作人', name: 'luserName' },
	                             { display: '最后操作时间', name: 'updateTime' }
	                             ], 
	                             isScroll: true, showToggleColBtn: false, width: '100%',
	                             height:'95%',
	                             data:datas,
	                             usePager : false,
	                 			 showTitle: false, columnWidth: 100  , frozen:false,
	                 			toolbar: { items: [
					                 			   { text: '开始时间：<%=financial_stime%>'},
					          					   { line:true },
					          					   { text: '结束时间：<%=financial_etime%>'},
					          					   { line:true },
				                 				   { text: '自定义查询',click:f_inputQuery, icon: 'search2'},
				                 				   { line:true },
				                 				   { text: '查看转账情况',click:f_lookTransferRela, icon: 'search2'},
				                 				   { line:true },
				                 				   { text: '退票结转', click: carryOver, icon: 'edit' },
	                                               { line: true },
	                                               { text: '导出Excel', id : 'orderSumbit' ,click: downloadThis, icon: 'add' ,icon: 'save' }
	                                               ]
	                                               },totalRender: f_totalRender,onDblClickRow:f_display,
	                                               onSelectRow: function (data, rowindex, rowobj)
	                                               {
	                                            		//queryOtherExpensesList(data.financialOrderCode);
	                                               }
	         
	             });
	  	            });
	  	/*
          myGrid2= $("#grids2").ligerGrid({
        	  checkbox: false,
              columns: [
                        { display: '财务单编号', name: 'financialOrderCode', width: 50,hide:"true"},
                        { display: '其他费用编号', name: 'otherExpensesId', width: 120},
                        { display: '类型', name: 'otherExpensesType', width: 120,render: function (rowdata, rowindex){
                            	if(rowdata.otherExpensesType=='0'){
                            		return '调整金额';
                            	}else if(rowdata.otherExpensesType=='1'){
                            		return '杂费';
                            	}
                             }},
                        { display: '状态', name: 'otherExpensesState',render: function (rowdata, rowindex){
                            	if(rowdata.otherExpensesState=='0'){
                            		return '新建';
                            	}else if(rowdata.otherExpensesState=='1'){
                            		return '审核中';
                            	}else if(rowdata.otherExpensesState=='2'){
                            		return '审核通过';
                            	}else if(rowdata.otherExpensesState=='3'){
                            		return '审核不通过';
                            	}else if(rowdata.otherExpensesState=='4'){
                            		return '完成';
                            	}
                             }},
                        { display: '调整金额', width: 120, name: 'adjustAmount', type: 'float' },
                        { display: '费用说明', name: 'amountExplain',width: 150 },
                        { display: '创建人', name: 'userName',width: 120 },
                        { display: '创建时间', name: 'createTime',width: 120 },
                        { display: '最后操作人', name: 'luserName',width: 120 },
                        { display: '最后操作时间', name: 'updateTime',width: 120 }
                        ],
                       // url:"${pageContext.request.contextPath}/product/view2",
                        
                        width: '100%', height: '40%', pkName: 'otherExpensesId', pageSizeOptions: [5, 10, 15, 20],
                        onAfterShowData   : function(data){
                        },
          				toolbar: { items: [
          					 { text: '增加', id : 'addOtherExpenses' , click: f_addOtherExpenses, icon: 'add' , icon: 'plus', id: 'add' },
                             { line: true },
                             { text: '修改', id : 'editOtherExpenses' , click: f_editOtherExpenses, icon: 'edit', id: 'edit'},
                             { line: true },
                             { text: '提交',click:f_submitTransfer, icon: 'edit',id : 'submit'},
                             { line:true },
					         { text: '审核',click:f_auditTransfer, icon: 'edit',id : 'audit'},
					         { line:true },
                             { text: '删除', id : 'delOtherExpenses' , click: f_delOtherExpenses, icon: 'delete', id: 'del' }
                             ]
                             },
                             onSelectRow: function (data, rowindex, rowobj)
                             {
                          	      showButton(data);
                             },onDblClickRow : f_onSelectRow

                    });
            showButton();
             */
    });

    function f_lookTransferRela(){
    	var row = myGrid.getSelectedRow();
    	if(!row){
         	$.ligerDialog.warn("请选择一张财务单！");
         	return;
        }
    	var qurl = "../financial/transfer_relaOrderView_list.jsp?financialOrderCode="+row.financialOrderCode+"";
		$.ligerDialog.open({ url:qurl,title:'查看转账情况',height: 450,width: 980,isResize: true,showMax:true, 
			buttons: [
			{ text: '关闭', onclick: function (item, dialog) { dialog.hide(); } } ] });
	}

    function f_display(data, rowindex, rowobj){
		$.ligerDialog.open({ url:'order?action=display&edit=not&sid='+data.orderCode,title:'查看订单',height: 600,width: 980,isResize: true,showMax:true, 
			buttons: [
			{ text: '关闭', onclick: function (item, dialog) { dialog.hide(); } } ] });
	}
    
    function queryOtherExpensesList(financialOrderCode){
    	
    	var url2 = "otherExpenses?otherExpenses.financialOrderCode="+financialOrderCode+"&"+"<%=term%>";
       $.getJSON(url2,function(json){
	       	myGrid2.set({ data: json }); 
       });
    }

    function carryOver(){
    	var utype = '<%=utype%>';
        if(utype==1||utype==2){
        	$.ligerDialog.warn("非财务人员不允许操作！");
         	return;
        }
    	var row = myGrid.getSelectedRow();
    	if(!row){
         	$.ligerDialog.warn("请选择一张财务单！");
         	return;
        }
        if(row.orderType!=1||row.receiveState!=0||row.orderState!=0){
        	$.ligerDialog.warn("请选择生效的未收款的退票单！");
         	return;
        }
        if(confirm("确定要结转选中的财务单吗？")){
         	  var url2="financial?action=carryOver&clientid="+row.cid+"&order.recmoney="+row.recmoney+"&financial.financialOrderCode="+row.financialOrderCode+"";
		   	  //alert(url2);
         	  $.getJSON(url2,function(json){
					myGrid.set({ data: json });
          			myGrid.reload();
	          })
        }
    }
    
    function f_inputQuery(){
		clearQuery();
		$.ligerDialog.open({ target: $("#target1"),title:'自定义查询',height: 300,width: 500,isResize: true,showMax:true, 
			buttons: [
			{ text: '清空', 
			onclick: function (item, dialog) {
				//$("#stime").val("");
				//$("#etime").val("");
				clearQuery();
			} },
			{ text: '确定', 
				onclick: function (item, dialog) {
					var url = '<%=jspName%>?financial_stime='+ $("#stime").val()
					 	+'&financial_etime='+$("#etime").val()+'&financial_orderCode='+ $("#orderCode").val()+'&financial_pnr='+ encodeURI(encodeURI($("#pnr").val()))+'&financial_workno='+ $("#workno").val()+'&financial_custcompany='+ encodeURI(encodeURI($("#custcompany").val()))+'&financial_clientid='+ $("#clientid").val()+'&financial_auditState='+ $("#type4").val()+'&financial_type='+ $("#type2").val();

					 location.href = url;
				} },
			{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
    }

    function clearQuery(){
    	$("#orderCode").val("");
		$("#pnr").val("");
		$("#clientid").val("");
		$("#workno").val("");
		$("#clientName").val("");
		$("#type").ligerGetComboBoxManager().setValue(<%=Config.ORDER_TYPE_ALL%>);
		$("#auditState").ligerGetComboBoxManager().setValue(<%=Config.ORDER_TYPE_ALL%>);
    }
    
	function f_totalRender(){
		return datas.totalRender;
	}
	
	function submitThis(){
		form1.action = "<%=jspName%>"; 
		form1.submit();
	}
	
	function showButton(row){
			var toolManager = myGrid2.toolbarManager;
            var utype = '<%=utype%>';
            if(utype=='3'){
            	if(row!=null){
	        		if(row.otherExpensesState=='0'){
	           			toolManager.setEnabled('submit');
	           			toolManager.setEnabled('edit');
            			toolManager.setDisabled('audit');
	           			toolManager.setEnabled('del');
	           		}
	        		if(row.otherExpensesState=='1'){
	           			toolManager.setDisabled('submit');
	           			toolManager.setDisabled('edit');
            			toolManager.setDisabled('audit');
	           			toolManager.setDisabled('del');
	           		}
	        		if(row.otherExpensesState=='2'){
	           			toolManager.setDisabled('submit');
	           			toolManager.setDisabled('edit');
            			toolManager.setDisabled('audit');
	           			toolManager.setDisabled('del');
	           		}
	        		if(row.otherExpensesState=='3'){
	           			toolManager.setEnabled('submit');
	           			toolManager.setEnabled('edit');
            			toolManager.setDisabled('audit');
	           			toolManager.setDisabled('del');
	           		}
           		}
            }else{
            	if(row!=null){
            		
            		if(row.otherExpensesState=='1'){
            			toolManager.setEnabled('audit');
            			toolManager.setDisabled('submit');
            			toolManager.setDisabled('edit');
            			toolManager.setDisabled('del');
            		}
            		if(row.otherExpensesState=='2'){
            			toolManager.setDisabled('audit');
            			toolManager.setDisabled('submit');
            			toolManager.setDisabled('edit');
            			toolManager.setDisabled('del');
            		}
            		if(row.otherExpensesState=='3'){
            			toolManager.setDisabled('audit');
            			toolManager.setEnabled('submit');
            			toolManager.setEnabled('edit');
            			toolManager.setEnabled('del');
            		}
            	}
            	
            }
    }
	
	function f_submitTransfer(){
		var row = myGrid2.getSelectedRow();
    	if(!row){
         	$.ligerDialog.warn("请选择一条转账单！");
         	return;
        }
    	
		if(confirm("确定要提交选中的记录吗？")){
           	  var url2="otherExpenses?action=audit&otherExpenses.financialOrderCode="+row.financialOrderCode+"&otherExpenses.otherExpensesState=1&otherExpenses.otherExpensesId="+row.otherExpensesId+"";
		   	  
           	  $.getJSON(url2,function(json){
					myGrid2.set({ data: json });
            		myGrid2.reload();
	          })
        }
    	
	}
	
	function f_auditTransfer(){
			var row = myGrid2.getSelectedRow();
	    	if(!row){
	         	$.ligerDialog.warn("请选择一条其他费用！");
	         	return;
	        }
	    	$.ligerDialog.open({ target: $("#target3"),title:'审核',height: 120,width: 250,isResize: true,showMax:true, 
			buttons: [
				{ text: '确定', 
				onclick: function (item, dialog) {
					var state = $("#type1").val();
	    			var url2="otherExpenses?action=audit&otherExpenses.otherExpensesType="+row.otherExpensesType+"&otherExpenses.adjustAmount="+row.adjustAmount+"&otherExpenses.financialOrderCode="+row.financialOrderCode+"&otherExpenses.otherExpensesState="+state+"&otherExpenses.otherExpensesId="+row.otherExpensesId+"";
					$.getJSON(url2,function(json){
							myGrid2.set({ data: json });
            				myGrid2.reload();
             		});
					dialog.hide();
				} },
			{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
		}
	
	function f_onSelectRow(data, rowindex, rowobj){
    	var row2 = myGrid.getSelectedRow();
		var qurl = "otherExpenses?action=view&otherExpenses.otherExpensesId="+data.otherExpensesId;
		$.ligerDialog.open({ title:'查看',name:'wins',url: qurl,height: 420,width: 700,isResize: true,showMax:true, 
			buttons: [ { text: '确定', onclick: function (item, dialog) { dialog.hide(); } } ] });
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
        	
        }
        function f_addOtherExpenses(){
        	var row = myGrid.getSelectedRow();
	    	if(!row){
	         	$.ligerDialog.warn("请选择一条财务单！");
	         	return;
	        }
        	$.ligerDialog.open({ target: $("#target2"),title:'选择其他费用类型',height: 120,width: 350,isResize: true,showMax:true, 
				buttons: [
				{ text: '确定', 
					onclick: function (item, dialog) {
						var type = $("#type0").val();
						var jsp = "<%=editJsp%>";
						location.href = jsp+"?action=add&name="+row.name+"&company="+row.company+"&code="+row.financialOrderCode+"&type="+type;
					} },
				{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
	    }
		function f_editOtherExpenses(){
			var row = myGrid2.getSelectedRow();
	    	if(!row){
	         	$.ligerDialog.warn("请选择一条其他费用！");
	         	return;
	        }
			var type = $("#type0").val();
			form1.action = "otherExpenses?action=display&otherExpenses.otherExpensesId="+row.otherExpensesId;
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
        	var row = myGrid2.getSelectedRow();
	    	if(!row){
	         	$.ligerDialog.warn("请选择一条其他费用！");
	         	return;
	        }
			if(confirm('确定要删除选中的记录吗？')){
		    	form1.action = "otherExpenses?action=delete&otherExpenses.otherExpensesType="+row.otherExpensesType+"&otherExpenses.otherExpensesId="+row.otherExpensesId;
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
<div id='grids1' ></div></div>
<%--<div id='grids2' ></div></div>
--%><div id="target1"  style="display:none" >
  <table height="72" cellpadding="0" cellspacing="0" class="l-table-edit" >
    <tr>
  	  	<td width="59"   align="right" class="l-table-edit-td">开始时间:</td>
    	<td width="128"   align="left" class="l-table-edit-td"><input type="text" id="stime" name="stime" /></td>
    	<td colspan="2" align="right" class="l-table-edit-td">结束时间:</td>
  	  	<td width="201"  colspan="2" align="left" class="l-table-edit-td"><input type="text" id="etime" name="etime" /></td>
	</tr>
    <tr>
      <td align="right" class="l-table-edit-td">订单号:</td>
      <td align="left" class="l-table-edit-td"><input type="text" id="orderCode" name="orderCode" value="" /></td>
      <td colspan="2" align="right" class="l-table-edit-td">订单类型:</td>
      <td colspan="2" align="left" class="l-table-edit-td"><input name="type" type="text" id="type" ltype="text"  value="" /></td>
    </tr> 
    <tr>
      <td align="right" class="l-table-edit-td">公司名称:</td>
      <td align="left" class="l-table-edit-td"><input type="text" id="custcompany" name="custcompany" value="" /></td>
      <td colspan="2" align="right" class="l-table-edit-td">PNR:</td>
      <td colspan="2" align="left" class="l-table-edit-td"><input type="text" id="pnr" name="pnr" value="" /></td>
    </tr>
    <tr>
      <td align="right" class="l-table-edit-td">客户ID:</td>
      <td align="left" class="l-table-edit-td"><input type="text" id="clientid" name="clientid" value="" /></td>
      <td colspan="2" align="right" class="l-table-edit-td">创建人工号:</td>
      <td colspan="2" align="left" class="l-table-edit-td"><input type="text" id="workno" name="workno" value="" /></td>
    </tr>
    <tr>
      <td align="right" class="l-table-edit-td">审核状态:</td>
      <td align="left" class="l-table-edit-td"><input name="auditState" type="text" id="auditState" ltype="text"  value="" /></td>
      <td colspan="4" align="right" class="l-table-edit-td"></td>
    </tr>
</table> 
</div>
<div id="target2"  style="display:none" >
  <table height="72" cellpadding="0" cellspacing="0" class="l-table-edit" >
    <tr>
  	  	<td align="right" class="l-table-edit-td">其他费用类型:</td>
      	<td align="left" class="l-table-edit-td"><input name="otherExpensesType" type="text" id="otherExpensesType" ltype="text"  value="" /></td>
    </tr>
</table> 
</div>
<div id="target3" style="display:none" >
  <table height="72" cellpadding="0" cellspacing="0" class="l-table-edit" >
    <tr>
  	  	<td align="right" class="l-table-edit-td">审核操作:</td>
      	<td align="left" class="l-table-edit-td"><input name="auditType" type="text" id="auditType" ltype="text"  value="" /></td>
    </tr>
</table> 
</div>
</body>
</html>
