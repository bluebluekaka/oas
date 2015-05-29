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
        	
        	 $("#birthday").ligerDateEditor({ initValue:'<s:property value="offer.birthday"/>'});
        	 $("form").ligerForm();
        	<%
				String action = request.getParameter("action");
				String title = "添加供应商";
				String required = "required:true,";
				String url="offer";
				String listJsp=jspName.replace("info","list");
				if(!"add".equals(action)){
					title = "修改供应商";
					action = "change";
					required = "";
			 %>			     
		 
				
			 <%		
				}else{
			%>	
		 
        		 
			<%}
			
			%>
            var v = $("form").validate({
                debug: false,
                rules: {
                	"offer.name":{required:true,minlength:3,maxlength:50,remote:'<%=url%>?action=check&sid=<s:property value="offer.id"/>&t='+Math.random(100000)}
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
                          ? '红色框的输入有误，请您检查填写的内容，然后在提交'
                          : '红色框的输入有误，请您检查填写的内容，然后在提交';
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
                   
                    form.submit();
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

    <form name="form1" method="post" class="l-form" id="form1" action="<%=url+"?action="+action%>&sid=<s:property value='offer.id'/>" >

<div class="l-group l-group-hasicon">
<img src="../ui/lib/ligerUI/skins/icons/communication.gif"/>
<span><h2><%=title%></h2></span>
</div>
<div id="errorLabelContainer" class="l-text-invalid">
</div>
<table cellpadding="0" cellspacing="0" class="l-table-edit" >
            
                <tr>
                <td align="right" class="l-table-edit-td">* 名称:</td>
                <td colspan="3" align="left" class="l-table-edit-td"><input name="offer.name" type="text" id="uname" ltype="text"  value="<s:property value='offer.name'/>" /></td> <td align="left"></td>
                </tr>
                 
                  <tr>
                
          <td align="right" class="l-table-edit-td">联系人:</td>
                <td colspan="3" align="left" class="l-table-edit-td"><input name="offer.man" type="text" id="man" ltype="text"  value="<s:property value='offer.man'/>" /></td>
            </tr>
             
            <tr>
               <td align="right" class="l-table-edit-td" >电话:</td>
               <td colspan="3" align="left" class="l-table-edit-td"><input name="offer.phone" type="text" id="uphone" ltype="text" value="<s:property value='offer.phone'/>"   /></td>
    </tr>
    <tr>
               <td align="right" class="l-table-edit-td" >QQ:</td>
               <td colspan="3" align="left" class="l-table-edit-td"><input name="offer.qq" type="text" id="uqq" ltype="text" value="<s:property value='offer.qq'/>"   /></td>
    </tr>
     <tr>
       <td align="right" class="l-table-edit-td" >传真:</td>
       <td colspan="3" align="left" class="l-table-edit-td"><input name="offer.fox" type="text" id="fox" ltype="text" value="<s:property value='offer.fox'/>"   /></td>
     </tr>
     <tr>
       <td align="right" class="l-table-edit-td" >配置号:</td>
       <td colspan="3" align="left" class="l-table-edit-td"><input name="offer.num_code" type="text" id="num_code" ltype="text"  value="<s:property value='offer.num_code'/>" /></td>
     </tr>
     <tr>
               <td align="right" class="l-table-edit-td" >地址:</td>
               <td colspan="3" align="left" class="l-table-edit-td"><input name="offer.addr" type="text" id="uaddr" ltype="text" value="<s:property value='offer.addr'/>"   /></td>
    </tr> 
    
<%--       <tr>
               <td align="right" class="l-table-edit-td" >直属上级:</td>
               <td width="135" align="left" class="l-table-edit-td"><input name="offer.leaderid" type="text" id="leaderid" ltype="text" value="<s:property value='offer.leaderid'/>"/></td>
               <td width="101" align="left" ></td>
               <td width="173" align="left" class="l-table-edit-td"><input type="button" value="选择用户" id="Button2" class="l-button l-button-submit" onclick="getID()" /></td>
               <td align="left" ></td>
    </tr>
           --%>
           
            <tr>
                <td align="right" class="l-table-edit-td">备注:</td>
                <td colspan="3" align="left" class="l-table-edit-td"> 
                <textarea cols="100" name="offer.cmnt" id="ucmnt" rows="4" class="l-textarea"  style="width:400px" ><s:property value="offer.cmnt"/></textarea>
                </td>
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