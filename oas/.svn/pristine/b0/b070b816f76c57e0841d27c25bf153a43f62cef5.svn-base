<%@page language="java" contentType="text/html;charset=UTF-8" %><%@ include file="/common/taglibs.jsp"%>
<%
	String action = "query";
	String title = "财务单查询";
	String url = action+"?moduleName=transferRela&t="+Utils.getSystemMillis();

	
 	String term = "";
 	String orderId = request.getParameter("orderId");
	if(Utils.isNull(orderId)){
		orderId = "";
	}else{
		term += "order.orderid ="+orderId+"";
	}
	String financialOrderCode = request.getParameter("financialOrderCode");
	if(Utils.isNull(financialOrderCode)){
		financialOrderCode = "";
	}else{
		term += "financial.financialOrderCode ="+financialOrderCode+"";
	}
 	String usertype = (String)session.getAttribute(Config.USER_TYPE);
		int utype = 1;
		if(usertype!=null)
			utype = Integer.valueOf(usertype);
	
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
	  		$("form").ligerForm();
            var url1 = '<%=url%>&<%=term%>';
	  		myGrid= $("#grids").ligerGrid({
                 columns:[	{ display: '转账单编码', name: 'transferId', width: 150},
                             { display: '转账账号', name: 'transferAccount', width: 150 },
                             { display: '转账金额', name: 'transferAmount', width: 150,type:'float' },
                             { display: '冲账金额', name: 'offsetFinancialAmounts', width: 150,type:'float' }
                             ], 
                             isScroll: true, showToggleColBtn: false, width: '100%',
                             height:'98%',
                             url: url1,
                 			 showTitle: false, columnWidth: 100  , frozen:false
         
             });
    });  
	function f_totalRender(){
		return datas.totalRender;
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
</form> 
</body>
</html>
