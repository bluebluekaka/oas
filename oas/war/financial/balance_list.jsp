<%@page language="java" contentType="text/html;charset=UTF-8" %><%@ include file="/common/taglibs.jsp"%>
<%
	String action = "query";
	String title = "财务单查询";
	String url = action+"?moduleName=balance&t="+Utils.getSystemMillis();
	 
	String stime = request.getParameter("stime");
	String etime = request.getParameter("etime"); 
	if(Utils.isNull(stime)||Utils.isNull(etime)){
		stime = "";
		etime = "";
	}
	String customerId = request.getParameter("customerId");
	if(Utils.isNull(customerId)){
		customerId = "";
	}
 	String term = "query.stime="+stime+"&query.etime="+etime;
 	
 	String usertype = (String)session.getAttribute(Config.USER_TYPE);
		int utype = 1;
		if(usertype!=null)
			utype = Integer.valueOf(usertype);
	if(!Utils.isNull(customerId)){
		term +="&customer.customerID="+customerId;
	}
	
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
            var url1 = '<%=url%>&<%=term%>';
            $.getJSON(url1,
	  	            function(json) 
	  	            {
                datas=json;
	  		myGrid= $("#grids").ligerGrid({
        		 checkbox: true,
                 columns:[	{ display: '客户编码', name: 'customerID', width: 80},
                             { display: '客户名称', name: 'name', width: 80 },
                             { display: '公司名称', name: 'company', width: 80 },
                             { display: '客户可用总余额', name: 'residualValue', width: 120,type:'float' },
                             { display: '转账单可用总额', name: 'usableAmounts', width: 120,type:'float' },
                             { display: '转账单总额', name: 'transferAmounts', width: 120,type:'float' },
                             { display: '客户总欠款', name: 'paidAmount', width: 120,type:'float' },
                             { display: '总欠款（对账）', name: 'paidCompareAmounts', width: 120,type:'float' },
                             { display: '订单总欠款', name: 'orderRecmoneys', width: 120,type:'float' },
                             { display: '待付欠款（已入账）', name: 'recmoney11', width: 120,type:'float' },
                             { display: '待付欠款（未入账）', name: 'recmoney5', width: 120,type:'float' },
                             { display: '财务应收款', name: 'recmoneys', width: 120,type:'float' },
                             { display: '财务已收款', name: 'receivedAmounts', width: 120,type:'float' }
                             ], 
                             isScroll: true, showToggleColBtn: false, width: '100%',
                             height:'93%',
                             data:datas,
                             usePager : false,
                 			 showTitle: false, columnWidth: 100  , frozen:false,
                 			toolbar: { items: [{ text: '开始时间：<%=stime%>'},{ line:true },
				          					   { text: '结束时间：<%=etime%>'},{ line:true },
				          					   { text: '自定义查询',click:f_inputQuery, icon: 'search2'},{ line:true }
                                               ]
                                               },
                                               onSelectRow: function (data, rowindex, rowobj)
                                               {
                                            		//queryOtherExpensesList(data.financialOrderCode);
                                               },totalRender: f_totalRender,isChecked: f_isChecked, onCheckRow: f_onCheckRow, onCheckAllRow: f_onCheckAllRow 
         
            	 });
    		});  
      });
	function f_totalRender(){
		return datas.totalRender;
	}

	function f_display(data, rowindex, rowobj){
		$.ligerDialog.open({ url:'order?action=display&edit=not&sid='+data.orderCode,title:'查看订单',height: 600,width: 980,isResize: true,showMax:true, 
			buttons: [
			{ text: '关闭', onclick: function (item, dialog) { dialog.hide(); } } ] });
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
	
	 function f_onCheckAllRow(checked)
        {	 
            for (var rowid in this.records)
            {
                if(checked)
                    addCheckedObj(this.records[rowid]);
                else
                    removeCheckedObj(this.records[rowid]);
            }
        }
 
        var checkedObj = [];
        function findCheckedObj(obj)
        {
            for(var i =0;i<checkedObj.length;i++)
            {
                if(checkedObj[i] == obj) return i;
            }
            return -1;
        }
        function addCheckedObj(obj)
        {
            if(findCheckedObj(obj) == -1)
                checkedObj.push(obj);
        }
        function removeCheckedObj(obj)
        {
            var i = findCheckedObj(obj);
            if(i==-1) return;
            checkedObj.splice(i,1);
        }
        function f_isChecked(rowdata)
        {
            if (findCheckedObj(rowdata) == -1)
                return false;
            return true;
        }
        function f_onCheckRow(checked, data)
        {
            if (checked) addCheckedObj(data);
            else removeCheckedObj(data);
        }	
	function f_inputQuery(){
		$.ligerDialog.open({ target: $("#target1"),title:'<%=title%>',height: 300,width: 500,isResize: true,showMax:true, 
			buttons: [
			{ text: '确定', 
				onclick: function (item, dialog) {
						if($("#stime").val()>=$("#etime").val()){
							$.ligerDialog.warn('开始时间不能大于结束时间');
							return;
						}
						var url = "<%=jspName%>?stime="+ $("#stime").val()
					 	+"&etime="+$("#etime").val()+"&customerId=<%=customerId%>";
					 	location.href = url;
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
<body style="padding:0 2px 2px 2px;overflow:hidden;" >
<form name="form1" method="post" id="form1">
<textarea name="fb"  style="display:none" ></textarea>

<div >
<div id='grids' ></div></div>
<div id="target1"  style="display:none" >
  <table height="72" cellpadding="0" cellspacing="0" class="l-table-edit" >
    <tr>
  	  	<td width="59"   align="right" class="l-table-edit-td">开始日期:</td>
    	<td width="128"   align="left" class="l-table-edit-td"><input type="text" id="stime" name="stime" /></td>
    	<td colspan="2" align="right" class="l-table-edit-td">开始时间:</td>
  	  	<td width="201"  colspan="2" align="left" class="l-table-edit-td"><input type="text" id="etime" name="etime" /></td>
	</tr>
</table> 
 </div>
</form> 
</body>
</html>
