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
        	<%
	        	String usertype = (String)session.getAttribute(Config.USER_TYPE);
				int utype = 1;
				if(usertype!=null)
					utype = Integer.valueOf(usertype);
				String action = request.getParameter("action");
				String title = "添加票款抵消费用";
				String required = "required:true,";
				String url="orderOffset";
				String listJsp=jspName.replace("info","list");
				if(!"add".equals(action)){
					title = "修改票款抵消费用";
					action = "change";
					required = "";
			 %>		
			 <%		
				}else{
			%>	
			<%}
				action = url+"?action="+action;
			%>
			$("#balance").ligerGetTextBoxManager().setDisabled();
			$("#customerId").ligerGetTextBoxManager().setDisabled();
			$("#transferId").ligerGetTextBoxManager().setDisabled();
			$("#transferAmount").ligerGetTextBoxManager().setDisabled();
			$("#offsetTransferAmounts").ligerGetTextBoxManager().setDisabled();
			$("#financialOrderCodes").ligerGetTextBoxManager().setDisabled();
			$("#offsetFinancialAmountsAll").ligerGetTextBoxManager().setDisabled();
            var v = $("form").validate({
                debug: false,
                rules: {
            	    "orderOffset.customerId": {required:true},
            	    "orderOffset.transferId": {required:true},
            	    "orderOffset.financialOrderCodes": {required:true},
            		"orderOffset.offsetTransferAmounts":{required:true,number : true,minlength:0,maxlength:10},
            		"orderOffset.offsetFinancialAmountsAll":{required:true,number : true,minlength:0,maxlength:10},
            		"orderOffset.balance":{required:true,number : true,minlength:0,maxlength:10}
                },
                errorPlacement: function (lable, element) {

                    if (element.hasClass("l-text-field")) {
                        element.parent().addClass("l-text-invalid");
                    }
                    var nextCell = element.parents("td:first").next("td");
                    if (nextCell.find("div.l-exclamation").length == 0) {
                        $('<div class="l-exclamation" title="' + lable.html() + '"></div>').appendTo(nextCell).ligerTip();
                    }
                },
                invalidHandler: function (form, validator) {
                    var errors = validator.numberOfInvalids();
                    if (errors) {
                        var message = errors == 1
                          ? 'You missed 1 field. It has been highlighted'
                          : 'You missed ' + errors + ' fields. They have been highlighted';
                        $("#errorLabelContainer").html(message).show();
                    }
                },
                success: function (lable) {
                    var element = $("#" + lable.attr("for"));
                    var nextCell = element.parents("td:first").next("td");
                    if (element.hasClass("l-text-field")) {
                        element.parent().removeClass("l-text-invalid");
                    }
                    nextCell.find("div.l-exclamation").remove();
                },
                submitHandler: function (form) {
                    $("#errorLabelContainer").html("").hide();
                    calculateAmount();
                    form.submit();
                }
            });
            
            $(".l-button-test").click(function ()
            {
            	location.href = "<%=listJsp%>" ;      
            });
        });
        
        function calculateAmount(){
        	var offsetTransferAmounts = $("#offsetTransferAmounts").val()!="" ? $("#offsetTransferAmounts").val() : 0;
        	var offsetFinancialAmountsAll = $("#offsetFinancialAmountsAll").val()!="" ? $("#offsetFinancialAmountsAll").val() : 0;
        	var amount = Math.floor(parseFloat(offsetTransferAmounts-offsetFinancialAmountsAll)*100)/100;
        	if(amount<0){
        		amount = 0;
        	}
        	$("#balance").val(amount);
        }

        function loadCustomer(){
			var qurl = '../manager/customer_query_list.jsp?query=true';
			$.ligerDialog.open({ title:'查询',name:'customerWins',url: qurl,height: 400,width: 800,isResize: true,showMax:true, 
				buttons: [
				{ text: '确定', 
					onclick: function (item, dialog) {
						var obj = document.getElementById('customerWins').contentWindow.doCommit(); 
					 	if(obj!='error'){
							$("#customerId").attr("value",obj.customerid);
							$("#name").html(obj.name);
							$("#phone").html(obj.phone);
							$("#qq").html(obj.qq);	
							$("#company").html(obj.company);	
							$("#residualValue").html(obj.residualValue);
							$("#paidAmount").html(obj.paidAmount);	
							dialog.close(); 
						}
					} },
				{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
		}

        function loadTransfer(){
        	var customerId = $("#customerId").val();
        	if(customerId==""){
        		$.ligerDialog.warn('<br/>请选择一个客户');
			 	return 'error';
        	}
			var qurl = "../financial/transfer_query_list.jsp?transfer_query_clientid="+customerId+"";
			$.ligerDialog.open({ title:'查询',name:'transferWins',url: qurl,height: 450,width: 980,isResize: true,showMax:true, 
				buttons: [
				{ text: '确定', 
					onclick: function (item, dialog) {
					var obj = document.getElementById('transferWins').contentWindow.doCommit(); 
				 	if(obj!='error'){
						$("#transferId").attr("value",obj.transferId);
						$("#transferAmount").attr("value",obj.transferAmount);
						$("#offsetTransferAmounts").attr("value",obj.usableAmount);
						dialog.close();
						calculateAmount(); 
					}
					} },
				{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
		}
        
        function loadFinancial(){
        	var customerId = $("#customerId").val();
        	if(customerId==""){
        		$.ligerDialog.warn('<br/>请选择一个客户');
			 	return 'error';
        	}
			var qurl = "../financial/financial_query_list.jsp?customerId="+customerId+"&check=true";
			$.ligerDialog.open({ title:'查询',name:'financialWins',url: qurl,height: 450,width: 980,isResize: true,showMax:true, 
				buttons: [
				{ text: '确定', 
					onclick: function (item, dialog) {
						var obj = document.getElementById('financialWins').contentWindow.doCommit(); 
					 	if(obj!='error'){
							var orders = "";
					 		var recmoneys = 0;
					 		for(var i=0;i<obj.length;i++){
					 			if(i==0){
					 				orders += obj[i].financialOrderCode;
					 			}else{
					 				orders += ","+obj[i].financialOrderCode;
					 			}
					 			
					 			recmoneys += parseFloat(obj[i].recmoney)-parseFloat(obj[i].receivedAmount);
					 		}
							$("#financialOrderCodes").attr("value",orders);	
							$("#offsetFinancialAmountsAll").attr("value",recmoneys);
							dialog.close();
							calculateAmount();  
						}
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

    <form name="form1" method="post" class="l-form" id="form1" action="<%=action%>" >

<div class="l-group l-group-hasicon">
<img src="../ui/lib/ligerUI/skins/icons/communication.gif"/>
<span><h2><%=title%></h2></span>
</div>
<div id="errorLabelContainer" class="l-text-invalid">
</div>
<table cellpadding="0" cellspacing="0" class="l-table-edit" >
<tr>
                <td align="right" class="l-table-edit-td">* 客户编号:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.customerId" id="customerId" ltype="text" value="<s:property value='orderOffset.customerId'/>" /></td>  <td align="left"></td>
            	<td align="left"></td>
	            <td colspan="2" class="l-table-edit-td"><input type="button" value="提取客户资料" id="Button2" class="l-button l-button-submit" onclick="loadCustomer()" /></td>
	            <td align="left"></td>
            </tr>
            <tr>
	            <td align="right" class="l-table-edit-td">客户名称:</td>
	            <td id="name" align="left" class="l-table-edit-td"><s:property value='customer.name'/>&nbsp;</td>
	            <td align="left"></td>
	            <td align="right" class="l-table-edit-td">公司名称:</td>
	            <td id="company" align="left" class="l-table-edit-td"><s:property value='customer.company'/>&nbsp;</td>
	            <td align="left"></td>
	        </tr>
	        <%
	        	if(utype==Config.USER_TYPE_TOP_MANERGER){
	        		%>
	        <tr><td align="right" class="l-table-edit-td">客户手机:</td>
	            <td id="phone" align="left" class="l-table-edit-td"><s:property value='customer.phone'/>&nbsp;</td>
	            <td align="left"></td>
	            <td align="right" class="l-table-edit-td">客户QQ:</td>
	            <td id="qq" align="left" class="l-table-edit-td"><s:property value='customer.qq'/>&nbsp;</td>
	            <td align="left"></td>
	        </tr>
	        <%
	        	}
	        %>
	        <tr>
	        	<td align="right" class="l-table-edit-td">可支付余额:</td>
	            <td id="residualValue" align="left" class="l-table-edit-td"><s:property value='customer.residualValue'/>&nbsp;</td>
	        	<td align="left"></td>
	            <td align="right" class="l-table-edit-td">待支付欠款:</td>
	            <td id="paidAmount" align="left" class="l-table-edit-td"><s:property value='customer.paidAmount'/>&nbsp;</td>
	            <td align="left"></td>
	        </tr>
            <tr>
                <input name="orderOffset.orderOffsetCode" type="hidden" id="orderOffsetCode" ltype="text" value="<s:property value='orderOffset.orderOffsetCode'/>" />
                <td align="right" class="l-table-edit-td">* 转账单号:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.transferId" id="transferId" ltype="text" value="<s:property value='orderOffset.transferId'/>" /></td>  <td align="left"></td>
            	<td align="left"></td>
	            <td colspan="2" class="l-table-edit-td"><input type="button" value="提取转账单" id="Button2" class="l-button l-button-submit" onclick="loadTransfer()" /></td>
	            <td align="left"></td>
            </tr>
           <tr>
                <td align="right" class="l-table-edit-td">转账单金额:</td>
                <td align="left" class="l-table-edit-td"><input name="transfer.transferAmount" type="text" id="transferAmount" ltype="text" value="<s:property value='transfer.transferAmount'/>"/></td> <td align="left"></td>
            	<td align="left"></td>
	            <td align="right" class="l-table-edit-td">可用金额:</td>
	            <td align="left" class="l-table-edit-td"><input name="orderOffset.offsetTransferAmounts" type="text" id="offsetTransferAmounts" ltype="text" value="<s:property value='orderOffset.offsetTransferAmounts'/>"/></td> <td align="left"></td>
	            <td align="left"></td>
            </tr>
            <tr>
            	<td align="right" class="l-table-edit-td">* 财务单号:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.financialOrderCodes" id="financialOrderCodes" ltype="text" value="<s:property value='orderOffset.financialOrderCodes'/>" /></td>  <td align="left"></td>
            	<td align="left"></td>
	            <td colspan="2" class="l-table-edit-td"><input type="button" value="提取财务单" id="Button3" class="l-button l-button-submit" onclick="loadFinancial()" /></td>
	            <td align="left"></td>
             </tr>
             <tr>
                <td align="right" class="l-table-edit-td">* 总计票款金额:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.offsetFinancialAmountsAll" type="text" id="offsetFinancialAmountsAll" ltype="text" value="<s:property value='orderOffset.offsetFinancialAmountsAll'/>"/></td> <td align="left"></td>
             </tr>
             <tr>
                <td align="right" class="l-table-edit-td">* 剩余金额:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.balance" type="text" id="balance" ltype="text" value="<s:property value='orderOffset.balance'/>" /></td> <td align="left"></td>
            </tr> 
        </table>
 <br />
<input type="submit" value="提交" id="Button1" class="l-button l-button-submit" /> 
<input type="button" value="取消" class="l-button l-button-test"/>
    </form>
    <div style="display:none">
    <!--  数据统计代码 --></div>

    
</body>
</html>