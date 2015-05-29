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
				String title = "查看票款抵消费用";
				String required = "required:true,";
				String url="orderOffset";
				String listJsp=jspName.replace("view","list");
				action = url+"?action="+action;
			%>
            var v = $("form").validate({
                debug: false,
                rules: {
            	    //"orderOffset.orderCode": {required:true},
            		//"orderOffset.returnAmount":{required:true,number : true,minlength:0,maxlength:10},
            		//"orderOffset.allOffsetAmount":{required:true,number : true,minlength:0,maxlength:10},
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
            		location.href = "<%=listJsp%>" ;     
                }
            });
            
            $(".l-button-test").click(function ()
            {
            	location.href = "<%=listJsp%>" ;      
            });
        });
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
                <input name="orderOffset.orderOffsetCode" type="hidden" id="orderOffsetCode" ltype="text" value="<s:property value='orderOffset.orderOffsetCode'/>" />
                <td align="right" class="l-table-edit-td">* 退票订单号:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.orderCode" id="orderCode" ltype="text" value="<s:property value='orderOffset.orderCode'/>" /></td>  <td align="left"></td>
            	<td align="left"></td>
	            <td colspan="2" class="l-table-edit-td"></td>
	            <td align="left"></td>
            </tr>
           <tr>
                <td align="right" class="l-table-edit-td">* 退票金额:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.returnAmount" type="text" id="returnAmount" ltype="text" value="<s:property value='orderOffset.returnAmount'/>"/></td> <td align="left"></td>
            </tr>
            <tr>
            <td align="right" class="l-table-edit-td">* 抵消票款订单号:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.offsetOrders" id="offsetOrders" ltype="text" value="<s:property value='orderOffset.offsetOrders'/>" /></td>  <td align="left"></td>
            	<td align="left"></td>
	            <td colspan="2" class="l-table-edit-td"></td>
	            <td align="left"></td>
                </tr>
                <tr>
                <td align="right" class="l-table-edit-td">* 总计抵消票款金额:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.allOffsetAmount" type="text" id="allOffsetAmount" ltype="text" value="<s:property value='orderOffset.allOffsetAmount'/>"/></td> <td align="left"></td>
                </tr>
             <tr>
                <td align="right" class="l-table-edit-td">* 剩余金额:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.balance" type="text" id="balance" ltype="text" value="<s:property value='orderOffset.balance'/>" /></td> <td align="left"></td>
            </tr> 
        </table>
 <br />
<input type="submit" value="确定" id="Button1" class="l-button l-button-submit" /> 
<input type="button" value="取消" class="l-button l-button-test"/>
    </form>
    <div style="display:none">
    <!--  数据统计代码 --></div>

    
</body>
</html>