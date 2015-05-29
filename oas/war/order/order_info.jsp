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
 	<script src="../ui/helper.js" type="text/javascript"></script> 
    <script type="text/javascript"> 
        var eee;
        var bid = 'productname'; 
		var tline = 0; 
		<%
			 	String usertype = (String)session.getAttribute(Config.USER_TYPE);
				int utype = 1;
				if(usertype!=null)
					utype = Integer.valueOf(usertype);
				int sta = 0;
				Object o = request.getAttribute("order.state");
				if(o!=null)
					sta = Integer.valueOf(String.valueOf(o));
			 
				String gotos = "";
				String required = "required:true,";
				String url="order";
				String listJsp=jspName.replace("info","list");
				String state = "生成中";
			 	
		%>	
        $(function () {	
		 	
			 $("#producttype").ligerComboBox({
                data: [
                { id: <%=Config.ORDER_PRC_TYPE_INTERNATIONL%>, text: '国际航班' },
             	{ id: <%=Config.ORDER_PRC_TYPE_INTERNAL%>, text: '国内航班' },
             	{ id: <%=Config.ORDER_PRC_TYPE_HOTEL%>, text: '酒店' },
             	{ id: <%=Config.ORDER_PRC_TYPE_MARK%>, text: '签证' }
                ], valueFieldID: 'type1'
            });
 			 $("#producttype").ligerGetComboBoxManager().setValue(<s:property value='order.producttype'/>);
			var pdata ={"Rows":[<s:property value='order.pdata' escape="false"/> ],"Total": "0"};
			$grid = $("#prcgrid").ligerGrid({
                columns: [
                { display: '承运人', name: 'carrier', width: 90<% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%> ,  editor: { type: 'string'} <%}%>  },
                { display: '航班号', name: 'flight', width: 90 <% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%> ,  editor: { type: 'string'} <%}%>},
                { display: '仓位', name: 'position', width: 90 <% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%> ,  editor: { type: 'string'} <%}%>},
                { display: '行程', name: 'trip', width: 90  <% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%> ,  editor: { type: 'string'} <%}%>},
                { display: '出发日期', name: 'sdate', width: 90  <% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%> ,  editor: { type: 'string'} <%}%>},
                { display: '出发时间', name: 'stime', width: 90 <% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%> ,  editor: { type: 'string'} <%}%>},
                { display: '到达日期', name: 'edate', width: 90 <% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%> ,  editor: { type: 'string'} <%}%>},
                { display: '到达时间', name: 'etime', width: 90 <% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%> ,  editor: { type: 'string'} <%}%>}
                ], data:pdata, width: '100%' ,usePager:false,height:150,rownumbers:true,
                enabledEdit: true, isScroll: false,onAfterEdit: f_onAfterEditP,onBeforeSubmitEdit: f_onBeforeSubmitEdit,
                toolbar: { items: [
                	{ text: '添加', click:f_addpro, icon: 'plus'},{ line:true }
                	,{ text: '删除',click:f_deletepro, icon: 'delete'},{ line:true },{ text: '修改', click:f_updatecdata, icon: 'edit'},{ line:true }]
            	}
            }
            );
						
			function  f_addpro(e){
				<% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER){%>
            		$grid.addEditRow( 
            			{'carrier':' ','flight':' ','position':' ','trip':' ','sdate':' ','stime':' ','edate':' ','etime':' ','HideID':' '}
            		 );
            		
            	<%}else{%>
            		alert('生成中的订单，或初审不通过的订单才可以执行该操作。');
            	<%}%>
			}
		 
			function  f_deletepro(e){
			 	<% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER){%>
            		var row = $grid.getSelectedRow();
	            	if (!row) { alert('请选择产品信息中的一行进行删除'); return; }
					$.ligerDialog.confirm('<br/>确定删除吗？',
	                 	function (yes) {
		                 	if(yes==true) {
		                 		 $grid.deleteSelectedRow();
		                 	}
	                 	} 
					);	
            	<%}else{%>
            		alert('生成中的订单，或初审不通过的订单才可以执行该操作。');
            	<%}%>
			}
			var ctypeData = [{ type:<%=Config.ADULT%>, text: '成人' }, { type: <%=Config.CHILD%>, text: '儿童'}, { type: <%=Config.BABY%>, text: '婴儿'}];
			var offerData = "<s:property value='offerdata' escape='false'/>"; 
			var cdata ={"Rows":[<s:property value='order.cdata' escape="false"/> ],"Total": "0"};
         	$grid1 = $("#cgrid").ligerGrid({
                columns: [
                { display: '旅客姓名', name: 'name', width: 280<% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%> ,  editor: { type: 'string'} <%}%>},
                { display: '旅客类型', name: 'type', width: 90
				<% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%>, editor: { type: 'select', data: ctypeData, valueField: 'type' }<%}%>,
                    render: function (item)
                    {
                        if (parseInt(item.type) == <%=Config.BABY%>) return '婴儿';
						else if (parseInt(item.type) == <%=Config.CHILD%>) return '儿童';
                        else if (parseInt(item.type) == <%=Config.ADULT%>) return '成人';
					 				 
                    }
 },
                { display: '应收款', name: 'recmoney', width: 90<% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%> ,  editor: { type: 'string'} <%}%>},
                { display: '票号', name: 'pnum', width: 115 <% if(sta==Config.ORDER_STATE_ALLOW_COMMON_MANAGER||sta==Config.ORDER_STATE_DISALLOW_FINANCE ){%> ,editor: { type: 'text'} <%}%> },
                { display: '供应商', name: 'supplier', width: 115 <% if(sta==Config.ORDER_STATE_ALLOW_COMMON_MANAGER||sta==Config.ORDER_STATE_DISALLOW_FINANCE ){%> ,editor: { 
				type: 'select',
				url:'offer?action=data',
                valueField : 'id',
                textField: 'name'  } <%}%>
				,render: function (item)
                    { 
						var offerData0 = offerData.split(",");
                        for(var a in offerData0){
							var as = offerData0[a].split(":::"); 
							if (item.supplier  == as[0]) {
								return as[1];
							} 
						}
                    }},
                { display: '应付款', name: 'paymoney', width: 90 <% if(sta==Config.ORDER_STATE_ALLOW_COMMON_MANAGER||sta==Config.ORDER_STATE_DISALLOW_FINANCE ){%>,editor: { type: 'string'} <%}%>  }
                ],data:cdata, width: '100%' ,onBeforeEdit: f_onBeforeEdit,onAfterEdit: f_onAfterEditC,usePager:false,height:220,rownumbers:true,enabledEdit: true,onBeforeSubmitEdit: f_onBeforeSubmitEdit 
                , isScroll: false,toolbar: { items: [
                	{ text: '添加', click:f_addcdata, icon: 'plus'},{ line:true }
                	,{ text: '删除',click: f_deletecdata, icon: 'delete'},{ line:true },
                	{ text: '修改', click:f_updatecdata, icon: 'edit'},{ line:true },
                	{ text: '票号递增设置', click:f_pnum, icon: 'edit'},{ line:true }
                	]
            	}
            }
            );
            $("#type").ligerComboBox({
                data: [
                { id: <%=Config.ORDER_TYPE_ORDER%>, text: '订票' },
             	{ id: <%=Config.ORDER_TYPE_CANCEL%>, text: '退票' }
                ], valueFieldID: 'type0', onSelected: function (newvalue)
                {
					var a = $("#orderid").val();
                    if(newvalue==<%=Config.ORDER_TYPE_CANCEL%>) {// -
						$("#orderid").attr("value",'TP'+a.substring(2));
						for(var i in $grid1.getData()){
							var e = $grid1.getRow(i);
							if((e.paymoney).indexOf("-")==-1){
								$grid1.updateCell('paymoney','-'+e.paymoney, e); 
							}
							if((e.recmoney).indexOf("-")==-1){
								$grid1.updateCell('recmoney','-'+e.recmoney, e);
							} 
						}	
						$("#lorder").show();
					}else{ 
						$("#orderid").attr("value",'JP'+a.substring(2));
						for(var i in $grid1.getData()){
							var e = $grid1.getRow(i);
							if((e.paymoney).indexOf("-")!=-1){
								$grid1.updateCell('paymoney',getReplace(e.paymoney,'-',''), e); 
							}
							if((e.recmoney).indexOf("-")!=-1){
								$grid1.updateCell('recmoney',getReplace(e.recmoney,'-',''), e);
							} 
						}	
						$("#lorder").hide();
					}
                }

            });
            $("#type").ligerGetComboBoxManager().setValue(<s:property value='order.type'/>);
            function  f_addcdata(e){
            	<% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER){%>
            		$grid1.addEditRow(
            		{'name':' ','type':'1','recmoney':'0.00','paymoney':'0.00','pnum':' ','supplier':' ','HideID':' '} 
            		);
            	<%}else{%>
            		alert('生成中的订单，或初审不通过的订单才可以执行该操作。');
            	<%}%>
			}
			function  f_pnum(e){
            	<% if(sta==Config.ORDER_STATE_ALLOW_COMMON_MANAGER||sta==Config.ORDER_STATE_DISALLOW_FINANCE){%>
					$.ligerDialog.prompt('请输入要递增的票号','', function (yes,value) { if(yes){
						var fp = getReplace(value,'-','');
							fp = getReplace(fp,' ','');
						var fp2 = 0;
						if(fp.indexOf('/')!=-1){//  1/3
							alert('不支持含/的票号递增，请输入递增的票号后在单个修改');
							return false;
						}else{
							fp2 = parseInt(fp);
						}
						for(var i in $grid1.getData()){
							var e = $grid1.getRow(i);
							var vs = (fp2+parseInt(i))+"";
							var il = fp.length-vs.length;
							for(var i=0;i<il;i++){
								vs='0'+vs;
							}
							$grid1.updateCell('pnum',vs, e); 
						}						
					}});

            	<%}else{%>
            		alert('改订单状态下不可以执行该操作。');
            	<%}%>
			}
			
			 function  f_updatecdata(e){
            	alert('请双击某一行进行修改，注：若双击后无法修改说明该订单状态下不能修改此处');
			}
			
		 	function f_onBeforeEdit(e){ 
             	if(e.value=='0.00') e.value='';
	        }
		 	
			function  f_deletecdata(e){
				<% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER){%>
            		var row = $grid1.getSelectedRow();
	            	if (!row) { alert('请选择旅客信息中的一行进行删除'); return; }
	            	$.ligerDialog.confirm('<br/>确定删除吗？',
	                 	function (yes) {
		                 	if(yes==true) {
		                 		 $grid1.deleteSelectedRow();
		                 	}
	                 	} 
					);	   
            	<%}else{%>
            		alert('生成中的订单，或初审不通过的订单才可以执行该操作。');
            	<%}%>
			}
			
			function f_onAfterEditP(e){
				var val = getReplace(e.value,' ','');
				 if (e.column.name == "sdate"){ 
					if(val.length==8){
						val = val.substring(0,4)+'-'+val.substring(4,6)+'-'+val.substring(6);
						$grid.updateCell('sdate',val, e.record);
					}
					
				}else if (e.column.name == "stime"){
					if(val.length==4){
						val = val.substring(0,2)+':'+val.substring(2);
						$grid.updateCell('stime',val, e.record);
					} 
				}else if (e.column.name == "edate"){ 
					if(val.length==8){
						val = val.substring(0,4)+'-'+val.substring(4,6)+'-'+val.substring(6);
						$grid.updateCell('edate',val, e.record);
					} 
				}else if (e.column.name == "etime"){
					if(val.length==4){
						val = val.substring(0,2)+':'+val.substring(2);
						$grid.updateCell('etime',val, e.record);
					} 
				}
			 	if(val=='')
					$grid.updateCell(e.column.name,' ', e.record);
			}
			function f_onAfterEditC(e){
				var val = getReplace(e.value,' ','');
				if (e.column.name == "pnum"){
					val = getReplace(e.value,'-','');
					$grid1.updateCell('pnum',val, e.record); 
				} 
			 	if(val==''){
					
					if (e.column.name == "recmoney" ||e.column.name == "paymoney"){
						$grid1.updateCell('e.column.name','0.00', e.record); 
					}else $grid1.updateCell(e.column.name,' ', e.record);
				}
			}
			
			
			 function f_onBeforeSubmitEdit(e)
				{
				 if (e.column.name == "recmoney"||e.column.name == "paymoney")
					{	
						if(isNaN(e.value)||getReplace(e.value,' ','')==''){
							alert("输入无效，请输入数字");
							return false;
						}
						if($("#type0").val()=="<%=Config.ORDER_TYPE_CANCEL%>"){
							if(e.value>0){
								 alert("输入无效，退票订单请输入负数");
								 return false;
							}
						}else{
						 	if(e.value<0){
								 alert("输入无效，订票订单请输入正数");
								 return false;
							}
						}
					}
					else if (e.column.name == "sdate"||e.column.name == "edate")
					{	
						if(isNaN(e.value)||getReplace(e.value,' ','').length!=8){
							alert("输入无效，请输入8位数字日期如：20140401");
							return false;
						}
					}else if (e.column.name == "stime"||e.column.name == "etime")
					{	
						if(isNaN(e.value)||getReplace(e.value,' ','').length!=4){
							alert("输入无效，请输入4位数字时间如：0800");
							return false;
						}
					}
					
			}
		
			
			var cmntdata ={"Rows":[<s:property value='order.cmntdata'/> ],"Total": "0"};
			$grid2 = $("#cmntgrid").ligerGrid({
                columns: [
                { display: '备注日期', name: 'cdate', width: 90  },
                { display: '备注时间', name: 'ctime', width: 90 },
                { display: '备注人', name: 'cname', width: 90 },
                { display: '备注内容', name: 'ccmnt', width: 450 } 
                ], data:cmntdata, width: '100%' ,usePager:false,height:110,rownumbers:true
            }
            );
			
			var logdata ={"Rows":[<s:property value='order.ldata'/> ],"Total": "0"};
			$grid3 = $("#orderlog").ligerGrid({
                columns: [
                { display: '操作日期', name: 'ldate', width: 90  },
                { display: '操作时间', name: 'ltime', width: 90 },
                { display: '操作人', name: 'luser', width: 90 },
                { display: '操作内容', name: 'lcmnt', width: 250 } 
                ], data:logdata, width: 600 ,usePager:false,height:110
            }
            );
			 
        	$("form").ligerForm();
        	$("#orderid").ligerGetTextBoxManager().setDisabled();
			$("#clientid").ligerGetTextBoxManager().setDisabled();
			$("#type").ligerGetTextBoxManager().setDisabled();
			$("#producttype").ligerGetTextBoxManager().setDisabled(); 
			$("#productname").ligerGetTextBoxManager().setDisabled(); 
			$("#pnr").ligerGetTextBoxManager().setDisabled();
	  
			<% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%>
				 				$("#producttype").ligerGetTextBoxManager().setEnabled(); 
				$("#productname").ligerGetTextBoxManager().setEnabled(); 
				$("#pnr").ligerGetTextBoxManager().setEnabled();
			<%}%>
			<% if(sta==Config.ORDER_STATE_CREATE ||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER){%>
				$("#type").ligerGetTextBoxManager().setEnabled();
			<%}%>
			
		 	$("#lorder").hide();
		//	$("#orderid").attr("disabled", true);
        //	$("#clientid").attr("disabled", true);
        	
			 
             var v = $("form").validate({
                debug: false,
                rules: {
                	"order.type":{required:true,minlength:2,maxlength:20 },
 					 "order.producttype":{required:true,minlength:2,maxlength:20 },
					 "order.productname":{required:true,minlength:2,maxlength:20 },
					 "order.clientid":{required:true,minlength:2,maxlength:20 } 
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
                          ? '红色框的输入有误，请您检查填写的内容'
                          : '红色框的输入有误，请您检查填写的内容';
                        $("#errorLabelContainer").html(message).show();
                    }
                },
                success: function (lable) {
					try{
                    var element = $("#" + lable.attr("for"));
                    var nextCell = element.parents("td:first").next("td");
                    if (element.hasClass("l-text-field")) {
                        element.parent().removeClass("l-text-invalid");
                    }
                    nextCell.find("div.l-exclamation").remove();
					}catch(e){}
                },
                submitHandler: function (form) {
                    $("#errorLabelContainer").html("").hide();
					$("form").click();
                  	$("#type").attr("value",$("#type0").val()); 
					$("#producttype").attr("value",$("#type1").val());	
				//	$("#orderid").attr("disabled", false);  
				//	$("#clientid").attr("disabled", false);
					$("#updatetxt").attr("value",getUpdate); 
					 eval("var str1 = '"+JSON.stringify($grid.getData())+"';");
					 eval("var str2 = '"+JSON.stringify($grid1.getData())+"';");
					$("#savepdata").attr("value",str1);
					$("#savecdata").attr("value",str2);
					form.submit();
                }
            });
            
            $(".l-button-test").click(function ()
            {
				$.ligerDialog.confirm('<br/>您的订单尚未保存或提交订单，<br/><br/>确定返回吗？',
                 	function (yes) {
	                 	if(yes==true) {
	                 		 location.href = "<%=listJsp%>" ;
	                 	}
                 	} 
					);	   
            });
         document.getElementById("productname").focus();
		 
		$(document).keydown(function(event){ //40 down, 38 up ,37 left,39 right
			 
			if(event.keyCode==9){
				
				 
				<% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER){ %>
				if(bid=='productname'){
					focusd('pnr');
				}else if(bid=='pnr'){ 
					focusd("prcgrid|2|r1001|c102");
				}else if(bid=='prcgrid|2|r1001|c102'){ 
					focusd("prcgrid|2|r1001|c103");
				}else if(bid=='prcgrid|2|r1001|c103'){ 
					focusd("prcgrid|2|r1001|c104");
				}else if(bid=='prcgrid|2|r1001|c104'){ 
					focusd("prcgrid|2|r1001|c105");
				}else if(bid=='prcgrid|2|r1001|c105'){ 
					focusd("prcgrid|2|r1001|c106");
				}else if(bid=='prcgrid|2|r1001|c106'){ 
					focusd("prcgrid|2|r1001|c107");
				}else if(bid=='prcgrid|2|r1001|c107'){ 
					focusd("prcgrid|2|r1001|c108");
				}else if(bid=='prcgrid|2|r1001|c108'){ 
					focusd("prcgrid|2|r1001|c109");
				}
				
				else if(bid=='prcgrid|2|r1001|c109'){ 
					focusd("prcgrid|2|r1002|c102");
				}else if(bid=='prcgrid|2|r1002|c102'){ 
					focusd("prcgrid|2|r1002|c103");
				}else if(bid=='prcgrid|2|r1002|c103'){ 
					focusd("prcgrid|2|r1002|c104");
				}else if(bid=='prcgrid|2|r1002|c104'){ 
					focusd("prcgrid|2|r1002|c105");
				}else if(bid=='prcgrid|2|r1002|c105'){ 
					focusd("prcgrid|2|r1002|c106");
				}else if(bid=='prcgrid|2|r1002|c106'){ 
					focusd("prcgrid|2|r1002|c107");
				}else if(bid=='prcgrid|2|r1002|c107'){ 
					focusd("prcgrid|2|r1002|c108");
				}else if(bid=='prcgrid|2|r1002|c108'){ 
					focusd("prcgrid|2|r1002|c109");
				}
				
				else if(bid=='prcgrid|2|r1002|c109'){ 
					focusd("prcgrid|2|r1003|c102");
				}else if(bid=='prcgrid|2|r1003|c102'){ 
					focusd("prcgrid|2|r1003|c103");
				}else if(bid=='prcgrid|2|r1003|c103'){ 
					focusd("prcgrid|2|r1003|c104");
				}else if(bid=='prcgrid|2|r1003|c104'){ 
					focusd("prcgrid|2|r1003|c105");
				}else if(bid=='prcgrid|2|r1003|c105'){ 
					focusd("prcgrid|2|r1003|c106");
				}else if(bid=='prcgrid|2|r1003|c106'){ 
					focusd("prcgrid|2|r1003|c107");
				}else if(bid=='prcgrid|2|r1003|c107'){ 
					focusd("prcgrid|2|r1003|c108");
				}else if(bid=='prcgrid|2|r1003|c108'){ 
					focusd("prcgrid|2|r1003|c109");
				}
				
				else if(bid=='prcgrid|2|r1003|c109'){ 
					focusd("prcgrid|2|r1004|c102");
				}else if(bid=='prcgrid|2|r1004|c102'){ 
					focusd("prcgrid|2|r1004|c103");
				}else if(bid=='prcgrid|2|r1004|c103'){ 
					focusd("prcgrid|2|r1004|c104");
				}else if(bid=='prcgrid|2|r1004|c104'){ 
					focusd("prcgrid|2|r1004|c105");
				}else if(bid=='prcgrid|2|r1004|c105'){ 
					focusd("prcgrid|2|r1004|c106");
				}else if(bid=='prcgrid|2|r1004|c106'){ 
					focusd("prcgrid|2|r1004|c107");
				}else if(bid=='prcgrid|2|r1004|c107'){ 
					focusd("prcgrid|2|r1004|c108");
				}else if(bid=='prcgrid|2|r1004|c108'){ 
					focusd("prcgrid|2|r1004|c109");
				}
				
				else if(bid=='prcgrid|2|r1004|c109'){ 
					focusd("prcgrid|2|r1005|c102");
				}else if(bid=='prcgrid|2|r1005|c102'){ 
					focusd("prcgrid|2|r1005|c103");
				}else if(bid=='prcgrid|2|r1005|c103'){ 
					focusd("prcgrid|2|r1005|c104");
				}else if(bid=='prcgrid|2|r1005|c104'){ 
					focusd("prcgrid|2|r1005|c105");
				}else if(bid=='prcgrid|2|r1005|c105'){ 
					focusd("prcgrid|2|r1005|c106");
				}else if(bid=='prcgrid|2|r1005|c106'){ 
					focusd("prcgrid|2|r1005|c107");
				}else if(bid=='prcgrid|2|r1005|c107'){ 
					focusd("prcgrid|2|r1005|c108");
				}else if(bid=='prcgrid|2|r1005|c108'){ 
					focusd("prcgrid|2|r1005|c109");
				}
				
				
				else if(bid=='prcgrid|2|r1005|c109'){ 
					focusd("prcgrid|2|r1006|c102");
				}else if(bid=='prcgrid|2|r1006|c102'){ 
					focusd("prcgrid|2|r1006|c103");
				}else if(bid=='prcgrid|2|r1006|c103'){ 
					focusd("prcgrid|2|r1006|c104");
				}else if(bid=='prcgrid|2|r1006|c104'){ 
					focusd("prcgrid|2|r1006|c105");
				}else if(bid=='prcgrid|2|r1006|c105'){ 
					focusd("prcgrid|2|r1006|c106");
				}else if(bid=='prcgrid|2|r1006|c106'){ 
					focusd("prcgrid|2|r1006|c107");
				}else if(bid=='prcgrid|2|r1006|c107'){ 
					focusd("prcgrid|2|r1006|c108");
				}else if(bid=='prcgrid|2|r1006|c108'){ 
					focusd("prcgrid|2|r1006|c109");
				}
				
				
				else if(bid=='prcgrid|2|r1006|c109'){ 
					focusd("prcgrid|2|r1007|c102");
				}else if(bid=='prcgrid|2|r1007|c102'){ 
					focusd("prcgrid|2|r1007|c103");
				}else if(bid=='prcgrid|2|r1007|c103'){ 
					focusd("prcgrid|2|r1007|c104");
				}else if(bid=='prcgrid|2|r1007|c104'){ 
					focusd("prcgrid|2|r1007|c105");
				}else if(bid=='prcgrid|2|r1007|c105'){ 
					focusd("prcgrid|2|r1007|c106");
				}else if(bid=='prcgrid|2|r1007|c106'){ 
					focusd("prcgrid|2|r1007|c107");
				}else if(bid=='prcgrid|2|r1007|c107'){ 
					focusd("prcgrid|2|r1007|c108");
				}else if(bid=='prcgrid|2|r1007|c108'){ 
					focusd("prcgrid|2|r1007|c109");
				}
				
				
				else if(bid=='prcgrid|2|r1007|c109'){ 
					focusd("prcgrid|2|r1008|c102");
				}else if(bid=='prcgrid|2|r1008|c102'){ 
					focusd("prcgrid|2|r1008|c103");
				}else if(bid=='prcgrid|2|r1008|c103'){ 
					focusd("prcgrid|2|r1008|c104");
				}else if(bid=='prcgrid|2|r1008|c104'){ 
					focusd("prcgrid|2|r1008|c105");
				}else if(bid=='prcgrid|2|r1008|c105'){ 
					focusd("prcgrid|2|r1008|c106");
				}else if(bid=='prcgrid|2|r1008|c106'){ 
					focusd("prcgrid|2|r1008|c107");
				}else if(bid=='prcgrid|2|r1008|c107'){ 
					focusd("prcgrid|2|r1008|c108");
				}else if(bid=='prcgrid|2|r1008|c108'){ 
					focusd("prcgrid|2|r1008|c109");
				}
				
				
				else if(bid=='prcgrid|2|r1008|c109'){ 
					focusd("prcgrid|2|r1009|c102");
				}else if(bid=='prcgrid|2|r1009|c102'){ 
					focusd("prcgrid|2|r1009|c103");
				}else if(bid=='prcgrid|2|r1009|c103'){ 
					focusd("prcgrid|2|r1009|c104");
				}else if(bid=='prcgrid|2|r1009|c104'){ 
					focusd("prcgrid|2|r1009|c105");
				}else if(bid=='prcgrid|2|r1009|c105'){ 
					focusd("prcgrid|2|r1009|c106");
				}else if(bid=='prcgrid|2|r1009|c106'){ 
					focusd("prcgrid|2|r1009|c107");
				}else if(bid=='prcgrid|2|r1009|c107'){ 
					focusd("prcgrid|2|r1009|c108");
				}else if(bid=='prcgrid|2|r1009|c108'){ 
					focusd("prcgrid|2|r1009|c109");
				}
				if(bid=='cgrid|2|r1001|c101'){ 
					focusd("cgrid|2|r1001|c102");
				}else if(bid=='cgrid|2|r1001|c102'){ 
					focusd("cgrid|2|r1001|c103");
				}else if(bid=='cgrid|2|r1001|c103'){ 
					focusd("cgrid|2|r1001|c104");
				} 
				
				else if(bid=='cgrid|2|r1001|c104'){  
					focusd("cgrid|2|r1002|c102");
				}else if(bid=='cgrid|2|r1002|c102'){ 
					focusd("cgrid|2|r1002|c103");
				}else if(bid=='cgrid|2|r1002|c103'){ 
					focusd("cgrid|2|r1002|c104");
				} 
				
				else if(bid=='cgrid|2|r1002|c104'){ 
					focusd("cgrid|2|r1003|c102");
				}else if(bid=='cgrid|2|r1003|c102'){ 
					focusd("cgrid|2|r1003|c103");
				}else if(bid=='cgrid|2|r1003|c103'){ 
					focusd("cgrid|2|r1003|c104");
				}
				
				else if(bid=='cgrid|2|r1003|c104'){ 
					focusd("cgrid|2|r1004|c102");
				}else if(bid=='cgrid|2|r1004|c102'){ 
					focusd("cgrid|2|r1004|c103");
				}else if(bid=='cgrid|2|r1004|c103'){ 
					focusd("cgrid|2|r1004|c104");
				}
				
				else if(bid=='cgrid|2|r1004|c104'){ 
					focusd("cgrid|2|r1005|c102");
				}else if(bid=='cgrid|2|r1005|c102'){ 
					focusd("cgrid|2|r1005|c103");
				}else if(bid=='cgrid|2|r1005|c103'){ 
					focusd("cgrid|2|r1005|c104");
				}
				
				else if(bid=='cgrid|2|r1005|c104'){
					focusd("cgrid|2|r1006|c102");
				}else if(bid=='cgrid|2|r1006|c102'){ 
					focusd("cgrid|2|r1006|c103");
				}else if(bid=='cgrid|2|r1006|c103'){ 
					focusd("cgrid|2|r1006|c104");
				}
				
				
				else if(bid=='cgrid|2|r1006|c104'){
					focusd("cgrid|2|r1007|c102");
				}else if(bid=='cgrid|2|r1007|c102'){ 
					focusd("cgrid|2|r1007|c103");
				}else if(bid=='cgrid|2|r1007|c103'){ 
					focusd("cgrid|2|r1007|c104");
				}
				
				
				else if(bid=='cgrid|2|r1007|c104'){
					focusd("cgrid|2|r1008|c102");
				}else if(bid=='cgrid|2|r1008|c102'){ 
					focusd("cgrid|2|r1008|c103");
				}else if(bid=='cgrid|2|r1008|c103'){ 
					focusd("cgrid|2|r1008|c104");
				}
				
				else if(bid=='cgrid|2|r1008|c104'){
					focusd("cgrid|2|r1009|c102");
				}else if(bid=='cgrid|2|r1009|c102'){ 
					focusd("cgrid|2|r1009|c103");
				}else if(bid=='cgrid|2|r1009|c103'){ 
					focusd("cgrid|2|r1009|c104");
				} 
			   <%}else if(sta==Config.ORDER_STATE_ALLOW_COMMON_MANAGER||sta==Config.ORDER_STATE_DISALLOW_FINANCE){%>
			   if(bid=='productname'){
					focusd('pnr');
				}else if(bid=='pnr'){ 
					focusd("cgrid|2|r1001|c105");
				}else
				if(bid=='cgrid|2|r1001|c105'){ 
					focusd("cgrid|2|r1001|c106");
				}else if(bid=='cgrid|2|r1001|c106'){ 
					focusd("cgrid|2|r1001|c107");
				} 
				
				else if(bid=='cgrid|2|r1001|c107'){  
					focusd("cgrid|2|r1002|c105");
				}else if(bid=='cgrid|2|r1002|c105'){ 
					focusd("cgrid|2|r1002|c106");
				}else if(bid=='cgrid|2|r1002|c106'){ 
					focusd("cgrid|2|r1002|c107");
				} 
				
				else if(bid=='cgrid|2|r1002|c107'){ 
					focusd("cgrid|2|r1003|c105");
				}else if(bid=='cgrid|2|r1003|c105'){ 
					focusd("cgrid|2|r1003|c106");
				}else if(bid=='cgrid|2|r1003|c106'){ 
					focusd("cgrid|2|r1003|c107");
				}
				
				else if(bid=='cgrid|2|r1003|c107'){ 
					focusd("cgrid|2|r1004|c105");
				}else if(bid=='cgrid|2|r1004|c105'){ 
					focusd("cgrid|2|r1004|c106");
				}else if(bid=='cgrid|2|r1004|c106'){ 
					focusd("cgrid|2|r1004|c107");
				}
				
				else if(bid=='cgrid|2|r1004|c107'){ 
					focusd("cgrid|2|r1005|c105");
				}else if(bid=='cgrid|2|r1005|c105'){ 
					focusd("cgrid|2|r1005|c106");
				}else if(bid=='cgrid|2|r1005|c106'){ 
					focusd("cgrid|2|r1005|c107");
				}
				
				else if(bid=='cgrid|2|r1005|c107'){
					focusd("cgrid|2|r1006|c105");
				}else if(bid=='cgrid|2|r1006|c105'){ 
					focusd("cgrid|2|r1006|c106");
				}else if(bid=='cgrid|2|r1006|c106'){ 
					focusd("cgrid|2|r1006|c107");
				}
				
				
				else if(bid=='cgrid|2|r1006|c107'){
					focusd("cgrid|2|r1007|c105");
				}else if(bid=='cgrid|2|r1007|c105'){ 
					focusd("cgrid|2|r1007|c106");
				}else if(bid=='cgrid|2|r1007|c106'){ 
					focusd("cgrid|2|r1007|c107");
				}
				
				
				else if(bid=='cgrid|2|r1007|c107'){
					focusd("cgrid|2|r1008|c105");
				}else if(bid=='cgrid|2|r1008|c105'){ 
					focusd("cgrid|2|r1008|c106");
				}else if(bid=='cgrid|2|r1008|c106'){ 
					focusd("cgrid|2|r1008|c107");
				}
				
				else if(bid=='cgrid|2|r1008|c107'){
					focusd("cgrid|2|r1009|c105");
				}else if(bid=='cgrid|2|r1009|c105'){ 
					focusd("cgrid|2|r1009|c106");
				}else if(bid=='cgrid|2|r1009|c106'){ 
					focusd("cgrid|2|r1009|c107");
				}
				<%}%>
				
				
				return false;
			}
		});
		bid = 'productname';
        $("#pnr").bind('click', function ()
		{
			bid = 'pnr';	   
		});
	
        $("#productname").bind('click', function ()
		{
			bid = 'productname';	   
		});
		
		 
		
     });  
   
 
	 
	function focusd(id){
		try{
		if(id.indexOf("|")!=-1){  
			$("form").click();
			document.getElementById(id).click();
			document.getElementById(id).focus(); 
			var id0 = id.substring(id.lastIndexOf("|")+1); 
			document.getElementById(id0).focus();
		}else{
			document.getElementById(id).focus(); 
		}
		}catch(e){
			<% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER){ %>
	        	 
	       <%}else if(sta==Config.ORDER_STATE_ALLOW_COMMON_MANAGER||sta==Config.ORDER_STATE_DISALLOW_FINANCE){%>
				 
			<%}%>
			if(id.indexOf("prcgrid")!=-1){
				id = "cgrid|2|r1001|c101";	
			}
		}
		setBid(id); 
	}
	 
	function setBid(id){
		bid=id;
		 
	}  
	 
	function loadCust(){
		<% if(sta!=Config.ORDER_STATE_CREATE&&sta!=Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%>
				alert('此状态下不能在导入');
				return;
		<%}%>
		
			var qurl = '../manager/customer_list.jsp?query=true&state=0';
			
			$.ligerDialog.open({ title:'查询',name:'wins',url: qurl,height: 500,width: 700,isResize: true,showMax:true, 
				buttons: [
				{ text: '确定', 
					onclick: function (item, dialog) {
						var values = document.getElementById('wins').contentWindow.getSelceted(); 
					 	if(values!='error'){
							$("#clientid").attr("value",values);
							form1.action = 'order?loads=do&order.state=<%=sta%>'; 
							dialog.close();
							$("form").submit();	
						 }
					} },
				{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
	}
	function loadOrder(){
		<% if(sta!=Config.ORDER_STATE_CREATE&&sta!=Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%>
				alert('此状态下不能在导入');
				return;
		<%}%>
		
			var qurl = 'order_list.jsp?query=true&type=<%=Config.ORDER_TYPE_ORDER%>';
			$.ligerDialog.open({ title:'查询',name:'wins1',url: qurl,height: 500,width: 700,
				buttons: [
				{ text: '确定', 
					onclick: function (item, dialog) {
						
						var values = document.getElementById('wins1').contentWindow.doCommit(); 
					 	if(values!='error'){
					 		location.href = 'order?action=lorder&sid='+values;
							dialog.close(); 
						 }
					} },
				{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
	}
	
	function loadTxt(){
		<% if(sta!=Config.ORDER_STATE_CREATE&&sta!=Config.ORDER_STATE_DISALLOW_COMMON_MANAGER ){%>
				alert('此状态下不能在导入');
				return;
		<%}%>
		$.ligerDialog.open({ target: $("#target1"),title:'导入信息',height: 300,width: 500,
			buttons: [
			{ text: '确定', 
				onclick: function (item, dialog) {
					var txt = $("#txtfile").val() ; 					
					if(txt.length==0){
						 alert("您没有导入任何数据");
						 return false;
					} 	 
					$("#loadtxt").attr("value",txt); 
					form1.action = 'order?loads=do&order.state=<%=sta%>'; 
				 	$("form").submit();
					dialog.hide();
				} },
			{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
	}
	function getUpdate(){
         var data = $grid1.getUpdated();
         return JSON.stringify(data);
   	}
   	
	function checkinput(){
		var pnr = $("#pnr").val() ; 	
		var productname = $("#productname").val() ; 
		var clientid = $("#clientid").val() ; 
		if(pnr==''){
			alert("pnr不能为空");
			return false;
		}else if(productname==''){
			alert("产品名称不能为空");
			return false;
		}else if(clientid==''){
			alert("客户编号不能为空");
			return false;
		}
		for(var i in $grid.getData()){
			var e = $grid.getRow(i);
			if(e.trip.length<3){
				alert("行程输入不正确");
				return false;
			}
			 
		}				
		
		return true;
	}
	
	
	
	function confrim(){
		if(checkinput()){
			 $.ligerDialog.confirm('<br/>确定保存到数据库吗？',
				function (yes) {
					if(yes==true) {
						form1.action="order?action=<s:property value='action'/>&order.state=<s:property value='order.state'/>"; 
						$("form").submit();
					}
				} 
			);	
		}
   	}
   	
	function waitf0(){
         $.ligerDialog.confirm('<br/>确定回复到生成中的状态吗？<br/><br/>',
            function (yes) {
	        	if(yes==true) {
					form1.action="order?action=<s:property value='action'/>&order.state=<%=Config.ORDER_STATE_CREATE%>";
					$("form").submit();
	        	}
            } 
		);	
   	}
	
	function waitf1(){
		if(checkinput()){
         $.ligerDialog.confirm('<br/>确定提交到业务经理审核吗？<br/><br/>',
            function (yes) {
	        	if(yes==true) {
					form1.action="order?action=<s:property value='action'/>&order.state=<%=Config.ORDER_STATE_WAIT_COMMON_MANAGER%>";
					$("form").submit();
	        	}
            } 
		);	
		}
   	}

	function waitf2(){
		if(checkinput()){
         $.ligerDialog.confirm('<br/>确定提交到财务员审核吗？<br/><br/>',
            function (yes) {
	        	if(yes==true) {
					form1.action="order?action=<s:property value='action'/>&order.state=<%=Config.ORDER_STATE_WAIT_FINANCE%>";
					$("form").submit();
	        	}
            } 
		);	
		}
   	}   	

	function f1pass(){
		if(checkinput()){
         $.ligerDialog.confirm('<br/>确定该订单通过初审吗？<br/><br/>',
            function (yes) {
	        	if(yes==true) {
	        		form1.action="order?action=<s:property value='action'/>&order.state=<%=Config.ORDER_STATE_ALLOW_COMMON_MANAGER%>";
					$("form").submit();
	        	}
            } 
		);	 } 
   	}
   	
	function f1nopass(){
		 
         $.ligerDialog.confirm('<br/>确定该订单不通过审核吗？<br/><br/>',
            function (yes) {
	        	if(yes==true) {
	        		form1.action="order?action=<s:property value='action'/>&order.state=<%=Config.ORDER_STATE_DISALLOW_COMMON_MANAGER%>";
					$("form").submit();
	        	}
            } 
		);	
		 
   	}
   	
   	function f2pass(){
		if(checkinput()){
         $.ligerDialog.confirm('<br/>确定该订单通过财务员审核吗？<br/><br/>',
            function (yes) {
	        	if(yes==true) {
	        		form1.action="order?action=<s:property value='action'/>&order.state=<%=Config.ORDER_STATE_END%>";
					$("form").submit();
	        	}
            } 
		);	 
		}
   	}
   	
	function f2nopass(){
		 
         $.ligerDialog.confirm('<br/>确定该订单不通过财务员审核吗？<br/><br/>',
            function (yes) {
	        	if(yes==true) {
	        		form1.action="order?action=<s:property value='action'/>&order.state=<%=Config.ORDER_STATE_DISALLOW_FINANCE%>";
					$("form").submit();
	        	}
            } 
		);
		 
   	}
   	
   	function f3pass(){
		if(checkinput()){
         $.ligerDialog.confirm('<br/>确定该订单通过财务经理审核吗？<br/><br/>',
            function (yes) {
	        	if(yes==true) {
	        		form1.action="order?action=<s:property value='action'/>&order.state=<%=Config.ORDER_STATE_END%>";
					$("form").submit();
	        	}
            } 
		);	
		}  
   	}
   	
	function f3nopass(){
         $.ligerDialog.confirm('<br/>确定该订单不通过财务经理审核吗？<br/><br/>',
            function (yes) {
	        	if(yes==true) {
	        		form1.action="order?action=<s:property value='action'/>&order.state=<%=Config.ORDER_STATE_DISALLOW_FINANCE_MANAGER%>";
					$("form").submit();
	        	}
            } 
		);	  
   	}
   	
	function confrimcancel(){
         $.ligerDialog.confirm('<br/>确定取消该订单吗？<br/><br/>',
            function (yes) {
	        	if(yes==true) {
	        		form1.action="order?action=<s:property value='action'/>&order.state=<%=Config.ORDER_STATE_CANCLE%>";
					$("form").submit();
	        	}
            } 
		);	  
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

    <form name="form1" method="post" class="l-form" id="form1" action="order" >

	<div class="l-group l-group-hasicon">
		<img src="../ui/lib/ligerUI/skins/icons/communication.gif"/>
		<span><h2>订单状态：<%=Helper.getOrterState1(sta)%></h2></span>
	</div>
	<div id="errorLabelContainer" class="l-text-invalid">
</div>
	<table  width="913" cellpadding="0" cellspacing="0" class="l-table-edit"  >
		<tr>
			<td width="76" align="right" class="l-table-edit-td">订单编号:</td>
            <td width="175" align="left" class="l-table-edit-td"><input name="order.orderid" id="orderid" ltype="text" value="<s:property value='order.orderid'/>" /></td>  <td width="47" align="left"></td>
            <td width="109"   class="l-table-edit-td">订单类型:</td>
            <td width="290"  align="left" class="l-table-edit-td"><input name="order.type" type="text" id="type" ltype="text"  value="<s:property value='order.type'/>" /></td> <td width="214" align="left"></td>
        </tr>
        <tr>
        	<td align="right" class="l-table-edit-td">产品类型:</td>
            <td align="left" class="l-table-edit-td"><input name="order.producttype" id="producttype" ltype="text" value="<s:property value='order.producttype'/>" /></td>
            <td align="left"></td>
            <td  class="l-table-edit-td">产品名称:</td>
            <td align="left" class="l-table-edit-td"><input name="order.productname" id="productname" ltype="text" value="<s:property value='order.productname'/>" /></td>
            <td align="left"></td>
        </tr>
        
		<tr>
        	<td align="right" class="l-table-edit-td">客户编号:</td>
            <td align="left" class="l-table-edit-td"><input name="order.clientid" id="clientid" ltype="text" value="<s:property value='order.clientid'/>" /></td>
            <td align="left"></td>
            <td colspan="2" class="l-table-edit-td"><input type="button" value="提取客户资料" id="checkcust" class="l-button l-button-submit" onclick="loadCust()" /></td>
            <td align="left"></td>
        </tr>
        <tr>
            <td align="right" class="l-table-edit-td">客户名称:</td>
            <td align="left" class="l-table-edit-td"><s:property value='order.custname'/>&nbsp;</td>
            <td align="left"></td>
            <td a class="l-table-edit-td">公司名称:</td>
            <td align="left" class="l-table-edit-td"><s:property value='order.custcompany'/>&nbsp;</td>
            <td align="left"></td>
        </tr>
        <tr>
            <td align="right" class="l-table-edit-td">可用余额:</td>
            <td align="left" class="l-table-edit-td"><s:property value='order.custmoney'/>&nbsp;</td>
            <td align="left"></td>
            <td class="l-table-edit-td">订单欠款:</td>
            <td align="left" class="l-table-edit-td"><s:property value='order.custpiadmoney'/>&nbsp;</td>
            <td align="left"></td>
        </tr>
		<tr>
            <td align="right" class="l-table-edit-td">PNR :</td>
            <td align="left" class="l-table-edit-td"><input name="order.pnr" id="pnr" ltype="text" value="<s:property value='order.pnr'/>" /></td>
            <td align="left"></td>
            <td align="right" class="l-table-edit-td"><input type="button" value="导入信息"  class="l-button l-button-submit" onclick="return loadTxt()" /></td>
          <td align="right" class="l-table-edit-td"><input type="button" id="lorder" value="导入订票信息"  class="l-button l-button-submit" onclick="return loadOrder()" /></td>
            <td align="left">&nbsp;</td>
        </tr>
        <tr>
            <td align="right" class="l-table-edit-td">产品信息:</td>
            <td colspan="5" align="left" class="l-table-edit-td"><div id="prcgrid"></div> </td>
        </tr>
        <tr>
            <td align="right" class="l-table-edit-td">旅客信息:</td>
            <td colspan="5" align="left" class="l-table-edit-td"><div id="cgrid"></div></td>
        </tr>
 		<tr>
            <td align="right" class="l-table-edit-td">历史备注:</td>
            <td colspan="5" align="left" class="l-table-edit-td"> <div id="cmntgrid"></div>
            </td>
        </tr>
        <tr>
            <td align="right" class="l-table-edit-td">新备注:</td>
            <td colspan="5" align="left" class="l-table-edit-td"><input name="order.cmnt" id="cmnt" ltype="text" value="" size="110" height="20"/> 
            </td>
        </tr>
         <tr>
            <td align="right" class="l-table-edit-td">订单日志:</td>
            <td colspan="5" align="left" class="l-table-edit-td"> 
           <div id="orderlog"></div> </td>
        </tr>
        <tr>
            <td align="right" class="l-table-edit-td">&nbsp;</td>
            <td colspan="5" align="left" class="l-table-edit-td"><textarea id="loadtxt" name="order.loadtxt" style=" display:none;" ><s:property value='order.loadtxt'/></textarea>
            <textarea id="updatetxt" name="order.updatetxt" style=" display:none;" ><s:property value='order.updatetxt'/></textarea>
            <textarea id="savepdata" name="order.savepdata" style=" display:none;" ></textarea>
            <textarea id="savecdata" name="order.savecdata" style=" display:none;" ></textarea></td>
        </tr>
        <tr>
            <td align="right" class="l-table-edit-td">&nbsp;</td>
            <td colspan="5" align="left" class="l-table-edit-td" <% if(sta==Config.ORDER_STATE_CANCLE){
			%>  style="display:none" <%}%>>
            <% if(utype==Config.USER_TYPE_COMMON_MANERGER && sta==Config.ORDER_STATE_WAIT_FINANCE){
			%> <p>	注：该状态下已经统计利润，直接修改数据会造成数据混乱，请返回待出票状态后在进行修改。 </p>
				<input type="button" value="返回待出票" id="Button1" class="l-button l-button-submit" onclick="return f1pass()"/> 
            <%}else  if(utype==Config.USER_TYPE_COMMON||utype==Config.USER_TYPE_COMMON_MANERGER||utype==Config.USER_TYPE_TOP_MANERGER){%>
	        	<input type="button" value="保存修改" id="Button1" class="l-button l-button-submit" onclick="return confrim()" />
	        	<% if(sta==Config.ORDER_STATE_CREATE||sta==Config.ORDER_STATE_DISALLOW_COMMON_MANAGER){ %>
	        		<input type="button" value="申请审核" id="Button1" class="l-button l-button-submit" onclick="return waitf1()"/>
	        	<%}else if(sta==Config.ORDER_STATE_ALLOW_COMMON_MANAGER||sta==Config.ORDER_STATE_DISALLOW_FINANCE){%>
	        		<input type="button" value="申请出票成功" id="Button1" class="l-button l-button-submit" onclick="return waitf2()"/>
	        	<%}%>
	        <%}%>
	        <% if(utype==Config.USER_TYPE_COMMON_MANERGER||utype==Config.USER_TYPE_TOP_MANERGER){
	        		if(sta==Config.ORDER_STATE_WAIT_COMMON_MANAGER){
	        %>
			 	<input type="button" value="待出票" id="Button1" class="l-button l-button-submit" onclick="return f1pass()"/>
	        	<input type="button" value="审核不通过" id="Button1" class="l-button l-button-submit" onclick="return f1nopass()"/>
	        <%		
	        		}
	        	}
	        %>
	        <% if(utype==Config.USER_TYPE_FINANCE||utype==Config.USER_TYPE_TOP_MANERGER){
	        		if(sta==Config.ORDER_STATE_WAIT_FINANCE||sta==Config.ORDER_STATE_DISALLOW_FINANCE_MANAGER){
	        %>
			 	<input type="button" value="结束" id="Button1" class="l-button l-button-submit" onclick="return f2pass()"/>
	        	<input type="button" value="待复出票" id="Button1" class="l-button l-button-submit" onclick="return f2nopass()"/>
	        <%		
	        		}
	        	}
	        %>
	        <% if(utype==Config.USER_TYPE_FINANCE_MANERGER||utype==Config.USER_TYPE_TOP_MANERGER){
	        		if(sta==Config.ORDER_STATE_WAIT_FINANCE_MANAGER){
	        %>
	        <!--
	        	<input type="button" value="财经通过" id="Button1" class="l-button l-button-submit" onclick="return f3pass()"/>
	        	<input type="button" value="财经不通过" id="Button1" class="l-button l-button-submit" onclick="return f3nopass()"/> 
	        -->
	        <%		
	        		}
	        	}
	        %>
	        <% if((utype==Config.USER_TYPE_COMMON_MANERGER && sta == Config.ORDER_STATE_WAIT_COMMON_MANAGER)||utype==Config.USER_TYPE_TOP_MANERGER){
	        %>
	        	<input type="button" value="取消订单" id="Button1" class="l-button l-button-submit" onclick="return confrimcancel()"/>
	        <%		
	        	}
	        %>
        	<input type="button" value="返回" class="l-button l-button-test"/></td>
        </tr>
        <% if(utype==Config.USER_TYPE_TOP_MANERGER){
 	        %>
        <tr>
            <td align="right" class="l-table-edit-td">状态设置:</td>
            <td colspan="5" align="left" class="l-table-edit-td"  <% if(sta==Config.ORDER_STATE_CANCLE){
			%>  style="display:none" <%}%>><input type="button" value="待审核" id="Button1" class="l-button l-button-submit" onclick="return waitf1()"/>	
            <input type="button" value="审核不通过" id="Button1" class="l-button l-button-submit" onclick="return f1nopass()"/>
             <input type="button" value="待出票" id="Button1" class="l-button l-button-submit" onclick="return f1pass()"/>
            <input type="button" value="待复出票" id="Button1" class="l-button l-button-submit" onclick="return f2nopass()"/>
            <input type="button" value="出票成功" id="Button1" class="l-button l-button-submit" onclick="return waitf2()"/>
            <input type="button" value="结束" id="Button1" class="l-button l-button-submit" onclick="return f2pass()"/> <input type="button" value="返回" class="l-button l-button-test"/>
	       </td>
        </tr>
        <%		
	        	}
	        %>
      </table>
 <br />

<div id="target1"  style="display:none"  >
  <table id="table1" cellpadding="0" cellspacing="0"     >
    <tr>
  	  	<td width="84"   align="right" class="l-table-edit-td">粘贴信息：</td><td width="356"   align="right" class="l-table-edit-td">&nbsp;</td>
   	</tr>
    <tr>
      <td colspan="2"   align="center" class="l-table-edit-td"><textarea   id="txtfile" style="width:400px; height:220px;" ><s:property value='order.loadtxt'/></textarea></td>
    </tr>
  </table>
</div>
</form>
    <div style="display:none">
    <!--  数据统计代码 --></div>

    
</body>
</html>
