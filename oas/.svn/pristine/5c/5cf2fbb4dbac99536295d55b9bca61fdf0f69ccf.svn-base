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
        	
        	 $("#birthday").ligerDateEditor({ initValue:'<s:property value="user.birthday"/>'});
        	 $("form").ligerForm();
        	<%
				String action = request.getParameter("action");
				String title = "添加用户";
				String required = "required:true,";
				String url="user";
				String listJsp=jspName.replace("info","list");
				if(!"add".equals(action)){
					title = "修改用户(不输入密码，则原密码不修改)";
					action = "change";
					required = "";
			 %>		
			     
		 
					$("#rbtnl_<s:property value='user.state'/>").ligerRadio().setValue(true);
					$("#usex_<s:property value='user.sex'/>").ligerRadio().setValue(true);
					$("#usertype_<s:property value='user.usertype'/>").ligerRadio().setValue(true);
					// document.getElementById('uid').disabled = true;
					$("#uworkcardno").ligerGetTextBoxManager().setDisabled();
			 <%		
				}else{
			%>	
		 
        		$("#rbtnl_1").ligerRadio().setValue(true);
        		$("#usex_1").ligerRadio().setValue(true);
        		$("#usertype_1").ligerRadio().setValue(true);
			<%}
			
			%>
            var v = $("form").validate({
                debug: false,
                rules: {
                	"user.uid": {required:true,minlength:3,maxlength:10,remote:'<%=url%>?action=check&old='+'<s:property value="user.uid"/>'+'&t='+Math.random(100000)},
					"user.pwd":{<%=required%>minlength:3,maxlength:10 },
					 checkpwd:{<%=required%>minlength:3,maxlength:10,equalTo:'#pwd'},
					"user.name":{required:true,minlength:2,maxlength:10},
					"user.sex":{required:true},
					"user.workcardno":{required:true,minlength:3,maxlength:3,number:true<%if("add".equals(action)){%>,remote:'<%=url%>?action=checkCardno&t='+Math.random(100000)<%}%>},
					"user.email":{email:true},
					"user.qq":{minlength:5,maxlength:12,number:true},
					"user.address":{minlength:6,maxlength:12}
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
                    $("#uid").attr("disabled", false);
                    $("#uworkcardno").attr("disabled", false);
                   
                    form.submit();
                }
            });
         
            $(".l-button-test").click(function ()
            {
            	location.href = "<%=listJsp%>" ;      
            });
        });  
    </script>
     <script type="text/javascript"> 
    	function getID(){
			var qurl = 'user_list4select.jsp?query=true';
			$.ligerDialog.open({ title:'查询',name:'wins',url: qurl,height: 500,width: 700,isResize: true,showMax:true, 
				buttons: [
				{ text: '确定', 
					onclick: function (item, dialog) {
						var values = document.getElementById('wins').contentWindow.getSelceted(); 
					 	if(values!='error'){
						$("#leaderid").attr("value",values);	
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

    <form name="form1" method="post" class="l-form" id="form1" action="<%=url+"?action="+action%>" >

<div class="l-group l-group-hasicon">
<img src="../ui/lib/ligerUI/skins/icons/communication.gif"/>
<span><h2><%=title%></h2></span>
</div>
<div id="errorLabelContainer" class="l-text-invalid">
</div>
<table cellpadding="0" cellspacing="0" class="l-table-edit" >
            <tr>
                <td width="64" align="right" class="l-table-edit-td">* ID:</td>
                <td colspan="3" align="left" class="l-table-edit-td"><input name="user.uid" id="uid" ltype="text" value="<s:property value='user.uid'/>" /></td>  <td width="10" align="left"></td>
            </tr>
            <tr>
                <td align="right" class="l-table-edit-td">* 工卡号:</td>
                <td colspan="3" align="left" class="l-table-edit-td"><input name="user.workcardno" type="text" id="uworkcardno" ltype="text"  value="<s:property value='user.workcardno'/>" /></td> <td align="left"></td>
                </tr>
           <tr>
                <td align="right" class="l-table-edit-td">* 密码:</td>
                <td colspan="3" align="left" class="l-table-edit-td"><input name="user.pwd" type="password" id="pwd" /></td> <td align="left"></td>
            </tr><tr>
                <td align="right" class="l-table-edit-td">* 确认密码:</td>
                <td colspan="3" align="left" class="l-table-edit-td"><input name="checkpwd" type="password" id="checkpwd" /></td> <td align="left"></td>
                </tr>
                <tr>
                <td align="right" class="l-table-edit-td">* 姓名:</td>
                <td colspan="3" align="left" class="l-table-edit-td"><input name="user.name" type="text" id="uname" ltype="text"  value="<s:property value='user.name'/>" /></td> <td align="left"></td>
                </tr>
                  <tr>
                
          <td align="right" class="l-table-edit-td">性别:</td>
                <td colspan="3" align="left" class="l-table-edit-td">
                <input id="usex_1" type="radio" name="user.sex" value="1"   /><label for="usex_1">男</label> 
                <input id="usex_0" type="radio" name="user.sex" value="0"  /><label for="usex_0">女</label> 
                </td>
            </tr>
            <tr>
               <td align="right" class="l-table-edit-td" valign="top">出生日期:</td>
               <td colspan="3" align="left" class="l-table-edit-td"><input type="text" id="birthday" name="user.birthday" /></td>
          </tr> 
                
            
             <tr>
                <td align="right" class="l-table-edit-td" valign="top">状态:</td>
                <td colspan="3" align="left" class="l-table-edit-td">
                    <input id="rbtnl_1" type="radio" name="user.state" value="1" />启用 
                    <input id="rbtnl_0" type="radio" name="user.state" value="0" />禁用</td>
            </tr>  
              <tr>
                <td align="right" class="l-table-edit-td" valign="top">权限:</td>
                <td colspan="3" align="left" class="l-table-edit-td">
                    <input id="usertype_0" type="radio" name="user.usertype" value="0"  /><label for="usertype_0">管理员</label> 
                    <input id="usertype_1" type="radio" name="user.usertype" value="1"   /><label for="usertype_1">业务员</label> 
                     <input id="usertype_2" type="radio" name="user.usertype" value="2"   /><label for="usertype_2">业务员经理</label> 
                      <input id="usertype_3" type="radio" name="user.usertype" value="3"   /><label for="usertype_3">财务员</label> 
                       <input id="usertype_4" type="radio" name="user.usertype" value="4"   /><label for="usertype_4">财务经理</label> 
                       <input id="usertype_5" type="radio" name="user.usertype" value="5"   /><label for="usertype_5">总经理</label> 
            </tr>
             <tr>
                <td align="right" class="l-table-edit-td"> 邮箱:</td>
                <td colspan="3" align="left" class="l-table-edit-td"><input name="user.email" type="text" id="uemail" ltype="text" value="<s:property value='user.email'/>" /></td> <td align="left"></td>
            </tr> 
            <tr>
               <td align="right" class="l-table-edit-td" valign="top">工作电话:</td>
               <td colspan="3" align="left" class="l-table-edit-td"><input name="user.mobile" type="text" id="umobile" ltype="text" value="<s:property value='user.mobile'/>" /></td>
    </tr>
            <tr>
               <td align="right" class="l-table-edit-td" valign="top">手机号:</td>
               <td colspan="3" align="left" class="l-table-edit-td"><input name="user.phone" type="text" id="uphone" ltype="text" value="<s:property value='user.phone'/>"   /></td>
    </tr>
    <tr>
               <td align="right" class="l-table-edit-td" valign="top">QQ号:</td>
               <td colspan="3" align="left" class="l-table-edit-td"><input name="user.qq" type="text" id="uqq" ltype="text" value="<s:property value='user.qq'/>"   /></td>
    </tr>
     <tr>
               <td align="right" class="l-table-edit-td" valign="top">地址:</td>
               <td colspan="3" align="left" class="l-table-edit-td"><input name="user.address" type="text" id="uaddress" ltype="text" value="<s:property value='user.address'/>"   /></td>
    </tr> 
    
<%--       <tr>
               <td align="right" class="l-table-edit-td" valign="top">直属上级:</td>
               <td width="135" align="left" class="l-table-edit-td"><input name="user.leaderid" type="text" id="leaderid" ltype="text" value="<s:property value='user.leaderid'/>"/></td>
               <td width="101" align="left" ></td>
               <td width="173" align="left" class="l-table-edit-td"><input type="button" value="选择用户" id="Button2" class="l-button l-button-submit" onclick="getID()" /></td>
               <td align="left" ></td>
    </tr>
           --%>
           
            <tr>
                <td align="right" class="l-table-edit-td">说明:</td>
                <td colspan="3" align="left" class="l-table-edit-td"> 
                <textarea cols="100" name="user.cmnt" id="ucmnt" rows="4" class="l-textarea"  style="width:400px" ><s:property value="user.cmnt"/></textarea>
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