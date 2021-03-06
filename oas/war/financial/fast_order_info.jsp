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
				String url="fastOrder";
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
			$("#type").ligerComboBox({
                data: [
                { id: 0, text: '订票' },
             	{ id: 1, text: '退票' }
                ], valueFieldID: 'type0'
            });
 			 $("#type").ligerGetComboBoxManager().setValue(<s:property value='fastOrder.type'/>);
			$("form").ligerForm();
			$("#customerId").ligerGetTextBoxManager().setDisabled();
            var v = $("form").validate({
                debug: false,
                rules: {
            	    "fastOrder.customerId": {required:true},
            	    "fastOrder.type": {required:true},
            	    "fastOrder.pnr": {required:true},
            		"fastOrder.recmoney":{required:true,number : true,minlength:0,maxlength:12},
            		"fastOrder.paymoney":{required:true,number : true,minlength:0,maxlength:12},
            		"fastOrder.profit":{required:true,number : true,minlength:0,maxlength:12}
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
                  	
                  	if($("#type0").val()==0&&$("#recmoney").val()<0){
                  		$.ligerDialog.warn('订票的应付款不能为负数！');
                      	return;
                  	}
                  	if($("#type0").val()==1&&$("#recmoney").val()>0){
                  		$.ligerDialog.warn('退票的应付款不能为正数！');
                      	return;
                  	}
                    $("#errorLabelContainer").html("").hide();
                  	$("#type").attr("value",$("#type0").val());
                  	$(form).find(":submit").attr("disabled", true).attr("value", "Submitting..."); 
                    form.submit();
                }
            });
            
            $(".l-button-test").click(function ()
            {
            	location.href = "<%=listJsp%>" ;      
            });
            
        });
        
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
                <input name="fastOrder.fastOrderId" type="hidden" id="fastOrderId" ltype="text" value="<s:property value='fastOrder.fastOrderId'/>" />
                <td align="right" class="l-table-edit-td">* 客户编号:</td>
                <td align="left" class="l-table-edit-td"><input name="fastOrder.clientid" id="customerId" ltype="text" value="<s:property value='fastOrder.clientid'/>" /></td>  <td align="left"></td>
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
                <td align="right" class="l-table-edit-td">* 订单类型:</td>
                <td align="left" class="l-table-edit-td"><input name="fastOrder.type" type="text" id="type" ltype="text" value="<s:property value='fastOrder.type'/>"/></td> <td align="left"></td>
                <td align="right" class="l-table-edit-td">* PNR:</td>
                <td align="left" class="l-table-edit-td"><input name="fastOrder.pnr" type="text" id="pnr" ltype="text" value="<s:property value='fastOrder.pnr'/>"/></td> <td align="left"></td>
            </tr>
            <tr>
                <td align="right" class="l-table-edit-td">* 应收款:</td>
                <td align="left" class="l-table-edit-td"><input name="fastOrder.recmoney" type="text" id="recmoney" ltype="text" value="<s:property value='fastOrder.recmoney'/>"/></td> <td align="left"></td>
                <td align="right" class="l-table-edit-td">* 应付款:</td>
                <td align="left" class="l-table-edit-td"><input name="fastOrder.paymoney" type="text" id="paymoney" ltype="text" value="<s:property value='fastOrder.paymoney'/>"/></td> <td align="left"></td>
            </tr>
            <tr>
            	<td align="right" class="l-table-edit-td">* 利润:</td>
                <td align="left" class="l-table-edit-td"><input name="fastOrder.profit" type="text" id="profit" ltype="text" value="<s:property value='fastOrder.profit'/>"/></td> <td align="left"></td>
            </tr>
            <tr>
                <td align="right" class="l-table-edit-td"> 说明:</td>
                <td align="left" colspan="5" class="l-table-edit-td"> 
                	<textarea cols="100" rows="4" name="fastOrder.mark" id="mark" ltype="text" class="l-textarea" style="width:400px"><s:property value='fastOrder.mark'/></textarea>
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