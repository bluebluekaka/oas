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
        var manager, g;
        var sucFlag = true;
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
				String listJsp=jspName.replace("offset_info","list");
				if(!"add".equals(action)){
					title = "冲账";
					action = "offset";
					required = "";
			 %>		
			 <%		
				}else{
			%>	
			<%}
				action = url+"?action="+action;
			%>
			//init();
			$("form").ligerForm();
			$("#customerId").ligerGetTextBoxManager().setDisabled();
			$("#transferAmount").ligerGetTextBoxManager().setDisabled();
			$("#financialOrderCodes").ligerGetTextBoxManager().setDisabled();
			$("#offsetTransferAmounts").ligerGetTextBoxManager().setDisabled();
			$("#offsetFinancialAmountsAll").ligerGetTextBoxManager().setDisabled();
			$("#balance").ligerGetTextBoxManager().setDisabled();
			$("#residualValueNew").ligerGetTextBoxManager().setDisabled();
			$("#paidAmountNew").ligerGetTextBoxManager().setDisabled();
			$("#offsetAmounts").ligerGetTextBoxManager().setDisabled();
            var v = $("form").validate({
                debug: false,
                rules: {
            	    "orderOffset.customerId": {required:true},
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
                      	$(form).find(":submit").attr("disabled", true).attr("value", "Submitting..."); 
                        form.submit();
                }
            });
            
            $(".l-button-test").click(function ()
            {
            	location.href = "<%=listJsp%>" ;      
            });

            var operData = [{ oper: 1, text: '是' }, { oper: 2, text: '否'}];
                    $(f_initGrid);
                    function f_initGrid()
                    { 
                       g =  manager = $("#offsetInfo").ligerGrid({
                            columns: [
                            { display: '财务单编码', name: 'financialOrderCode', width: 120, type: 'int',frozen:true },
                            { display: '订单号', name: 'orderCode', width: 120},
            				{ display: 'PNR', name: 'pnr',hide:true},
            				{ display: '类型', name: 'orderType',hide:true},
                            { display: '应收款', name: 'recmoney', width: 80,type:'float' } ,
                            { display: '已收款', name: 'receivedAmount', width: 80,type:'float' } ,
                            { display: '收款状态', name: 'receiveState', width: 80,
            				render: function (item)
                                    {
                                        if (parseInt(item.receiveState) == 0){
                							return '未收款';
						                }else if(parseInt(item.receiveState)==1){
						            		return '已收款';
						            	}else if(parseInt(item.receiveState)==2){
						            		return '部分收款';
						            	}else if(parseInt(item.receiveState)==3){
						            		return '已结转';
						            	}
                                    }
				             },
            				{ display: '冲账金额', name: 'offsetAmount', width: 80 ,type:'float'}, 
                            { display: '是否冲账', width: 70, name: 'oper',type:'int',
                                editor: { type: 'select', data: operData, valueColumnName: 'oper' },
                                render: function (item)
                                {
                                    if (parseInt(item.oper) == 1) return '是';
                                    return '否';
                                }
                            }
                            ],
                            onSelectRow: function (rowdata, rowindex)
                            {
                                $("#txtrowindex").val(rowindex);
                            },
                            enabledEdit: false, clickToEdit: true, isScroll: true,
            				usePager : false,
                            width: '100%',height:'120'
                        });   
                    }
            
        });

        function calculateAmount(){
        	var offsetTransferAmounts = $("#offsetTransferAmounts").val()!="" ? $("#offsetTransferAmounts").val() : 0;
        	var offsetFinancialAmountsAll = $("#offsetFinancialAmountsAll").val()!="" ? $("#offsetFinancialAmountsAll").val() : 0;
        	var amount = Math.floor(parseFloat(offsetTransferAmounts-(offsetFinancialAmountsAll))*100)/100;
        	if(amount<0){
        		amount = 0;
        	}
        	$("#balance").val(amount);
        }
        
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
					 		var jsonObj = {};
					 		sucFlag = true;
					 		obj = assembleObj(obj);
					 		var financialData = JSON.stringify(obj);
					 		jsonObj.Rows = eval(financialData);
					 		manager.set({ data: jsonObj });
					 		//var l = 50+obj.length*30;
					 		//manager.setHeight(l);
					 		manager.reload();
							dialog.close();
						}
					} },
				{ text: '取消', onclick: function (item, dialog) { dialog.hide(); } } ] });
		}
        
		function assembleObj(obj){
			var offsetTransferAmountsOld = parseFloat($("#offsetTransferAmounts").val());
			var offsetTransferAmountsNew = offsetTransferAmountsOld;
			var orders = "";
	 		var recmoneys = 0;
	 		var offsetAmounts = 0;
			for(var i=0;i<obj.length;i++){
				var recmoney = parseFloat(obj[i].recmoney);
				var receivedAmount = parseFloat(obj[i].receivedAmount);
				if((offsetTransferAmountsOld<0&&recmoney>0)||(offsetTransferAmountsOld>0&&recmoney<0)){
					sucFlag = false;
					$.ligerDialog.warn("选择的财务单和冲账用的转账单不是同一类型！");
		         	break;
				}
				if(offsetTransferAmountsNew==0&&recmoney!=0){
					sucFlag = false;
					$.ligerDialog.warn("选择的财务单的冲账金额超过该张转账单的可用金额！");
					obj[i].oper = 2;
					obj[i].offsetAmount = 0;
					continue;
				}
				var needOffsetAmount = recmoney-receivedAmount;
				if(offsetTransferAmountsOld>0){
					if(offsetTransferAmountsNew>=needOffsetAmount){
						var needOffsetAmount = needOffsetAmount.toFixed(2);
						obj[i].offsetAmount = needOffsetAmount;
						obj[i].oper = 1;
						obj[i].receiveState = 1;
						obj[i].receivedAmount = receivedAmount+parseFloat(needOffsetAmount);
						offsetTransferAmountsNew = offsetTransferAmountsNew - parseFloat(needOffsetAmount);
					}else{
						var amount = offsetTransferAmountsNew.toFixed(2);
						obj[i].offsetAmount = amount;
						obj[i].oper = 1;
						obj[i].receiveState = 2;
						obj[i].receivedAmount = receivedAmount+parseFloat(amount);
						offsetTransferAmountsNew = offsetTransferAmountsNew - parseFloat(amount);
					}
					
				}else if(offsetTransferAmountsOld<0){
					if(offsetTransferAmountsNew<=needOffsetAmount){
						needOffsetAmount = needOffsetAmount.toFixed(2);
						obj[i].offsetAmount = needOffsetAmount;
						obj[i].oper = 1;
						obj[i].receiveState = 1;
						obj[i].receivedAmount = receivedAmount+parseFloat(needOffsetAmount);
						offsetTransferAmountsNew = offsetTransferAmountsNew - parseFloat(needOffsetAmount);
					}else{
						var amount = offsetTransferAmountsNew.toFixed(2);
						obj[i].offsetAmount = amount;
						obj[i].oper = 1;
						obj[i].receiveState = 2;
						obj[i].receivedAmount = receivedAmount+parseFloat(amount);
						offsetTransferAmountsNew = offsetTransferAmountsNew - parseFloat(amount);
					}
				}
	 			recmoneys += recmoney-receivedAmount;
				if(i==0){
	 				orders += obj[i].financialOrderCode;
	 			}else{
	 				orders += ","+obj[i].financialOrderCode;
	 			}
				offsetAmounts += parseFloat(obj[i].offsetAmount);
			}
			$("#financialOrderCodes").attr("value",orders);	
			$("#offsetFinancialAmountsAll").attr("value",recmoneys.toFixed(2));
			$("#balance").attr("value",offsetTransferAmountsNew.toFixed(2));
			$("#offsetAmounts").attr("value",offsetAmounts.toFixed(2));
			var residualValueOld = parseFloat($("#residualValue").html());
			var paidAmountOld = parseFloat($("#paidAmount").html());
			
			$("#residualValueNew").attr("value",(residualValueOld-offsetAmounts).toFixed(2));
			$("#paidAmountNew").attr("value",(paidAmountOld+offsetAmounts).toFixed(2));
			$("#offsetListStr").attr("value",JSON.stringify(obj));
			return obj;
		} 
				

		function checkinput(){
			var financialOrderCodes = $("#financialOrderCodes").val() ; 	
			if(financialOrderCodes==''){
				alert("请选择需冲账的财务单！");
				return false;
			}				
			
			return true;
		}

		function submitForm(){
			if(!sucFlag){
	        	alert('冲账不符合要求，请检查！');
		        return;
	        }else{
		        if(!checkinput()){
			        return;
		        }
	         $.ligerDialog.confirm('<br/>确定要冲账吗？<br/><br/>',
	            function (yes) {
		        	if(yes==true) {
						form1.action="<%=action%>";
						$("form").find(":submit").attr("disabled", true).attr("value", "Submitting..."); 
						$("form").submit();
		        	}
	            } 
			);	
			}
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

    <form name="form1" method="post" class="l-form" id="form1" action="transfer" >
<div class="l-group l-group-hasicon">
<img src="../ui/lib/ligerUI/skins/icons/communication.gif"/>
<span><h2><%=title%></h2></span>
</div>
<div id="errorLabelContainer" class="l-text-invalid">
</div>
		<table width="900" cellpadding="0" cellspacing="0" class="l-table-edit" >
			<tr>
                <input name="orderOffset.transferId" type="hidden" id="transferId" ltype="text" value="<s:property value='transfer.transferId'/>" />
                <td align="right" class="l-table-edit-td">* 客户编号:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.customerId" id="customerId" ltype="text" value="<s:property value='transfer.customerId'/>" /></td>  <td align="left"></td>
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
                <td align="right" class="l-table-edit-td">* 转账金额:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.transferAmount" type="text" id="transferAmount" ltype="text" value="<s:property value='transfer.transferAmount'/>"/></td> <td align="left"></td>
				
	            <td align="right" class="l-table-edit-td">可用金额:</td>
	            <td align="left" class="l-table-edit-td"><input name="orderOffset.offsetTransferAmounts" type="text" id="offsetTransferAmounts" ltype="text" value="<s:property value='transfer.usableAmount'/>"/></td> <td align="left"></td>
            	
            </tr>
            <tr>
            	<td align="right" class="l-table-edit-td">* 财务单号:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.financialOrderCodes" type="text" id="financialOrderCodes" ltype="text" value="" /></td>  <td align="left"></td>
            	
	            <td colspan="2" class="l-table-edit-td"><input type="button" value="提取财务单" id="Button3" class="l-button l-button-submit" onclick="loadFinancial()" /></td>
	            <td align="left"></td>
             </tr>
             <tr>
                <td align="right" class="l-table-edit-td">冲账情况:</td>
	            <td colspan="10" align="left" class="l-table-edit-td"><textarea id="offsetListStr" name="orderOffset.offsetListStr" style=" display:none;" ></textarea> 
	            <div align="left" id="offsetInfo"></div> </td>
             </tr>
             <tr>
                <td align="right" class="l-table-edit-td">* 总计票款金额:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.offsetFinancialAmountsAll" type="text" id="offsetFinancialAmountsAll" ltype="text" value=""/></td> <td align="left"></td>
             	
                <td align="right" class="l-table-edit-td">* 总计冲账金额:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.offsetAmounts" type="text" id="offsetAmounts" ltype="text" value=""/></td> <td align="left"></td>
            	
             </tr>
             <tr>
                <td align="right" class="l-table-edit-td">* 冲账后客户可用余额:</td>
                <td align="left" class="l-table-edit-td"><input name="customer.residualValue" type="text" id="residualValueNew" ltype="text" value=""/></td> <td align="left"></td>
             	
                <td align="right" class="l-table-edit-td">* 冲账后客户欠款:</td>
                <td align="left" class="l-table-edit-td"><input name="customer.paidAmount" type="text" id="paidAmountNew" ltype="text" value="" /></td> <td align="left"></td>
             	
             </tr> 
             <tr>
                <td align="right" class="l-table-edit-td">* 剩余金额:</td>
                <td align="left" class="l-table-edit-td"><input name="orderOffset.balance" type="text" id="balance" ltype="text" value="" /></td> <td align="left"></td>
             	
             </tr>
             
        </table>
 <br />
<input type="button" value="提交" id="Button1" class="l-button l-button-submit" onclick="return submitForm();" /> 
<input type="button" value="取消" class="l-button l-button-test"/>
    </form>
    <div style="display:none">
    <!--  数据统计代码 --></div>
<div id="chtext" style='display:none'></div>
</body>
</html>