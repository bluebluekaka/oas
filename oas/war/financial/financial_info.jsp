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
				String action = request.getParameter("action");
				String title = "添加票款抵消费用";
				String required = "required:true,";
				String url="otherExpenses";
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
			$("#amount").ligerGetTextBoxManager().setDisabled();
            var v = $("form").validate({
                debug: false,
                rules: {
            	    "offsetOtherExpenses.orderCode": {required:true},
            		"offsetOtherExpenses.returnAmount":{required:true,number : true,minlength:0,maxlength:10},
            		"offsetOtherExpenses.allOffsetAmount":{required:true,number : true,minlength:0,maxlength:10},
                	//"user.uid": {required:true,minlength:3,maxlength:10,remote:'<%=url%>?action=check&t='+Math.random(100000)},
					//"user.pwd":{<%=required%>minlength:3,maxlength:10 },
					 //checkpwd:{<%=required%>minlength:3,maxlength:10,equalTo:'#pwd'},
					//"user.name":{required:true,minlength:2,maxlength:10},
					//"user.email":{email:true}
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
        	var returnAmount = $("#returnAmount").val()!="" ? $("#returnAmount").val() : 0;
        	var allOffsetAmount = $("#allOffsetAmount").val()!="" ? $("#allOffsetAmount").val() : 0;
        	var amount = Math.floor(parseFloat(returnAmount-allOffsetAmount)*100)/100;
        	//alert(amount)
        	$("#amount").val(amount);
        }
        
        function loadOrder(){
			var qurl = '../order/order_list.jsp?query=true';
			$.ligerDialog.open({ title:'查询',name:'wins',url: qurl,height: 500,width: 700,isResize: true,showMax:true, 
				buttons: [
				{ text: '确定', 
					onclick: function (item, dialog) {
						var values = document.getElementById('wins').contentWindow.doCommit(); 
					 	if(values!='error'){
						$("#orderCode").attr("value",values);	
						dialog.close(); }
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
                <input name="offsetOtherExpenses.otherExpensesId" type="hidden" id="otherExpensesId" ltype="text" value="<s:property value='offsetOtherExpenses.otherExpensesId'/>" />
                <td align="right" class="l-table-edit-td">* 退票订单号:</td>
                <td align="left" class="l-table-edit-td"><input name="offsetOtherExpenses.orderCode" id="orderCode" ltype="text" value="<s:property value='offsetOtherExpenses.orderCode'/>" /></td>  <td align="left"></td>
            	<td align="left"></td>
	            <td colspan="2" class="l-table-edit-td"><input type="button" value="提取订单资料" id="Button2" class="l-button l-button-submit" onclick="loadOrder()" /></td>
	            <td align="left"></td>
            </tr>
           <tr>
                <td align="right" class="l-table-edit-td">* 退票金额:</td>
                <td align="left" class="l-table-edit-td"><input name="offsetOtherExpenses.returnAmount" type="text" id="returnAmount" ltype="text" value="<s:property value='offsetOtherExpenses.returnAmount'/>" onchange="calculateAmount()"/></td> <td align="left"></td>
            </tr><tr>
                <td align="right" class="l-table-edit-td">* 抵消票款订单号和金额:</td>
                <td align="left" class="l-table-edit-td"> 
                <textarea cols="100" rows="4" name="offsetOtherExpenses.offsetRemark" id="offsetRemark" ltype="text" class="l-textarea" style="width:400px"><s:property value='offsetOtherExpenses.offsetRemark'/></textarea>
                </td><td align="left"></td>
                </tr><tr>
                <td align="right" class="l-table-edit-td">* 总计抵消票款金额:</td>
                <td align="left" class="l-table-edit-td"><input name="offsetOtherExpenses.allOffsetAmount" type="text" id="allOffsetAmount" ltype="text" value="<s:property value='offsetOtherExpenses.allOffsetAmount'/>" onchange="calculateAmount()"/></td> <td align="left"></td>
                </tr>
             <tr>
                <td align="right" class="l-table-edit-td">* 剩余金额:</td>
                <td align="left" class="l-table-edit-td"><input name="offsetOtherExpenses.amount" type="text" id="amount" ltype="text" value="<s:property value='offsetOtherExpenses.amount'/>" /></td> <td align="left"></td>
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