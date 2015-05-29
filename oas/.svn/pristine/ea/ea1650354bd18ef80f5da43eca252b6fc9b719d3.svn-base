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
				String code = request.getParameter("code");
				String type = request.getParameter("type");
				String cName = request.getParameter("name");
				String company = request.getParameter("company");
				String title = "添加其他费用";
				String required = "required:true,";
				String url="otherExpenses";
				String listJsp=jspName.replace("other_expenses_view","financial_list");
				if(!"add".equals(action)){
					title = "查看其他费用";
					action = "change";
					required = "";
			 %>		
			 <%		
				}else{
			%>
				$("#cName").html('<%=cName%>');
	        	$("#company").html('<%=company%>');
	        	$("#otherExpensesType").val('<%=type%>');
	        	$("#financialOrderCode").val('<%=code%>');
			<%}
				action = url+"?action="+action;
			%>
			
			$("#financialOrderCode").ligerGetTextBoxManager().setDisabled();
            var v = $("form").validate({
                debug: false,
                rules: {
                	
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
                    location.href = "<%=listJsp%>" ;
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
                <input name="otherExpenses.otherExpensesId" type="hidden" id="otherExpensesId" ltype="text" value="<s:property value='otherExpenses.otherExpensesId'/>" />
                <input name="otherExpenses.otherExpensesType" type="hidden" id="otherExpensesType" ltype="text" value="<s:property value='otherExpenses.otherExpensesType'/>" />
                <td align="right" class="l-table-edit-td">* 关联财务单号:</td>
                <td align="left" class="l-table-edit-td"><input name="otherExpenses.financialOrderCode" id="financialOrderCode" ltype="text" value="<s:property value='otherExpenses.financialOrderCode'/>" /></td>  <td align="left"></td>
            </tr>
            <%
            	if("add".equals(action)){
            		%>
            		<tr>
                	<td align="right" class="l-table-edit-td">客户名称:</td>
    	            <td id="cName" align="left" class="l-table-edit-td"></td>
    	            <td align="left"></td>
    	        </tr>
    	        <tr>
    	            <td align="right" class="l-table-edit-td">公司名称:</td>
    	            <td id="company" align="left" class="l-table-edit-td"></td>
    	            <td align="left"></td>
    	        </tr>
            		<%
            	}
            %>
            
            <tr>
                <td align="right" class="l-table-edit-td">* 调整金额:</td>
                <td align="left" class="l-table-edit-td"><input name="otherExpenses.adjustAmount" type="text" id="adjustAmount" ltype="text" value="<s:property value='otherExpenses.adjustAmount'/>" /></td> <td align="left"></td>
            </tr>
            <tr>
            	<td align="right" class="l-table-edit-td"> 费用说明:</td>
                <td align="left" class="l-table-edit-td"><textarea name="otherExpenses.amountExplain" id="amountExplain" style="width:400px; height:150px;" ><s:property value='otherExpenses.amountExplain'/></textarea></td>  <td align="left"></td>
            </tr> 
        </table>
 <br />
    </form>
    <div style="display:none">
    <!--  数据统计代码 --></div>

    
</body>
</html>