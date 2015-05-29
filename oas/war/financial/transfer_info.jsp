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
        	<%
	        	String usertype = (String)session.getAttribute(Config.USER_TYPE);
				int utype = 1;
				if(usertype!=null)
					utype = Integer.valueOf(usertype);
				int sta = 0;
				Object o = request.getAttribute("transfer.transferState");
				if(o!=null)
					sta = Integer.valueOf(String.valueOf(o));
				String action = request.getParameter("action");
				String title = "添加转账信息";
				String required = "required:true,";
				String url="transfer";
				String listJsp=jspName.replace("info","list");
				if(!"add".equals(action)){
					title = "修改转账信息";
					action = "change";
					required = "";
			 %>		
			 <%		
				}else{
			%>	
			<%}
				action = url+"?action="+action;
			%>
			//init();
			$("#transferType").ligerComboBox({
                data: [
                { id: 1, text: '票款' },
             	{ id: 2, text: '其他费用' }
                ], valueFieldID: 'type0'
            });
 			 $("#transferType").ligerGetComboBoxManager().setValue(<s:property value='transfer.transferType'/>);
			$("form").ligerForm();
			$("#customerId").ligerGetTextBoxManager().setDisabled();
            var v = $("form").validate({
                debug: false,
                rules: {
            	    "transfer.customerId": {required:true},
            	    "transfer.orderCodes": {required:true},
            	    "transfer.transferAccount": {required:true},
            	    "transfer.transferType": {required:true},
            		"transfer.transferAmount":{required:true,number : true,minlength:0,maxlength:12}
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
                  	$("#transferType").attr("value",$("#type0").val());
                  	$(form).find(":submit").attr("disabled", true).attr("value", "Submitting..."); 
                    form.submit();
                }
            });
            
            $(".l-button-test").click(function ()
            {
            	location.href = "<%=listJsp%>" ;      
            });
            
        });
        
        function init(){
			var url = "query?moduleName=transferAccount";
			$.getJSON(url,function(json){
				//alert(json.Rows);
		       	var combobox = $("#transferAccount").ligerComboBox({  
	                data: json.Rows,
	                emptyText: '（空）',  
	                addRowButton: '新增',           //新增按钮
		            addRowButtonClick: function ()  //新增事件
		            {
		                combobox.clear();
		                $.ligerDialog.open({ target: $("#target2"),title:'转账账号输入',height: 300,width: 500,
						buttons: [
						{ text: '确定', 
							onclick: function (item, dialog) {
								dialog.close(); 
								$("#transferAccount").val($("#accountInput"));
							} },
						{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
		            },valueFieldID: 'transferAccount0'
	            }); 
		       	
	        });
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
							$("#operator").html(obj.salesman);		
							dialog.close(); 
						}
					} },
				{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
		}
        
        function loadOrder(){
        	var customerId = $("#customerId").val();
        	if(customerId==""){
        		$.ligerDialog.warn('<br/>请选择一个客户');
			 	return 'error';
        	}
			var qurl = "../financial/financial_query_list.jsp?customerId="+customerId+"&check=true";
			$.ligerDialog.open({ title:'查询',name:'orderWins',url: qurl,height: 600,width: 980,isResize: true,showMax:true, 
				buttons: [
				{ text: '确定', 
					onclick: function (item, dialog) {
						var obj = document.getElementById('orderWins').contentWindow.doCommit(); 
					 	if(obj!='error'){
							var orders = "";
					 		var recmoneys = 0;
					 		for(var i=0;i<obj.length;i++){
					 			if(i==0){
					 				orders += obj[i].financialOrderCode;
					 			}else{
					 				orders += ","+obj[i].financialOrderCode;
					 			}
					 			
					 			recmoneys += parseFloat(obj[i].recmoney);
					 		}
							$("#orderCodes").attr("value",orders);	
							$("#recmoneys").attr("value",recmoneys);
							dialog.close(); 
						}
					} },
				{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
		}
        
        function loadAccount(){
			var qurl = "../financial/account_query_list.jsp";
			$.ligerDialog.open({ title:'以往转账账号列表',name:'orderWins',url: qurl,height: 420,width: 300,
				buttons: [
				{ text: '确定', 
					onclick: function (item, dialog) {
						var obj = document.getElementById('orderWins').contentWindow.doCommit(); 
					 	if(obj!='error'){
					 		$("#chtext").html(obj.transferAccount);
					 		$("#transferAccount").val($("#chtext").html());	
							dialog.close(); 
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
                <input name="transfer.transferId" type="hidden" id="transferId" ltype="text" value="<s:property value='transfer.transferId'/>" />
                <td align="right" class="l-table-edit-td">* 客户编号:</td>
                <td align="left" class="l-table-edit-td"><input name="transfer.customerId" id="customerId" ltype="text" value="<s:property value='transfer.customerId'/>" /></td>  <td align="left"></td>
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
	            <td align="right" class="l-table-edit-td">所属业务员:</td>
	            <td id="operator" align="left" class="l-table-edit-td"><s:property value='customer.operator'/>&nbsp;</td>
	            <td colspan="4" align="left"></td>
	        </tr>
	        <tr>
	        	<td align="right" class="l-table-edit-td">可支付余额:</td>
	            <td id="residualValue" align="left" class="l-table-edit-td"><s:property value='customer.residualValue'/>&nbsp;</td>
	        	<td align="left"></td>
	            <td align="right" class="l-table-edit-td">待支付欠款:</td>
	            <td id="paidAmount" align="left" class="l-table-edit-td"><s:property value='customer.paidAmount'/>&nbsp;</td>
	            <td align="left"></td>
	        </tr>
            <tr>
                <td align="right" class="l-table-edit-td">* 转账账号:</td>
                <td align="left" class="l-table-edit-td"><input name="transfer.transferAccount" type="text" id="transferAccount" ltype="text" value="<s:property value='transfer.transferAccount'/>"/></td> <td align="left"></td>
            	<td align="left"></td>
	            <td colspan="2" class="l-table-edit-td"><input type="button" value="提取以往账号" id="Button2" class="l-button l-button-submit" onclick="loadAccount()" /></td>
	            <td align="left"></td>
            </tr>
            <tr>
                <td align="right" class="l-table-edit-td">* 转账类型:</td>
                <td align="left" class="l-table-edit-td"><input name="transfer.transferType" type="text" id="transferType" ltype="text" value="<s:property value='transfer.transferType'/>"/></td> <td align="left"></td>
            </tr>
            <tr>
                <td align="right" class="l-table-edit-td">* 转账金额:</td>
                <td align="left" class="l-table-edit-td"><input name="transfer.transferAmount" type="text" id="transferAmount" ltype="text" value="<s:property value='transfer.transferAmount'/>"/></td> <td align="left"></td>
            </tr>
            <tr>
                <td align="right" class="l-table-edit-td"> 说明:</td>
                <td align="left" colspan="5" class="l-table-edit-td"> 
                	<textarea cols="100" rows="4" name="transfer.remark" id="remark" ltype="text" class="l-textarea" style="width:400px"><s:property value='transfer.remark'/></textarea>
                </td><td align="left"></td>
            </tr>
        </table>
 <br />
<input type="submit" value="提交" id="Button1" class="l-button l-button-submit" /> 
<input type="button" value="取消" class="l-button l-button-test"/>
    </form>
    <div style="display:none">
    <!--  数据统计代码 --></div>
<div id="chtext" style='display:none'></div>
</body>
</html>