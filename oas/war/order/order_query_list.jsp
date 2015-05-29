<%@page language="java" contentType="text/html;charset=UTF-8" %><%@ include file="/common/taglibs.jsp"%>
<%
	String action = "query";
	String title = "查询";
	String url = action+"?moduleName=order&t="+Utils.getSystemMillis();
	 
	String stime = request.getParameter("stime");
	String etime = request.getParameter("etime"); 
	if(Utils.isNull(stime)||Utils.isNull(etime)){
		stime = Utils.getAddDate(Utils.getNowDate(),-1)+" 00:00";
		etime = Utils.getNowDate()+" 23:59";
	}
 	String term = "query.stime="+stime+"&query.etime="+etime;
 	
 	String usertype = (String)session.getAttribute(Config.USER_TYPE);
		int utype = 1;
		if(usertype!=null)
			utype = Integer.valueOf(usertype);
					
	String query = request.getParameter("query");
	String checkFlag = request.getParameter("check");
	String type = request.getParameter("type");  
	if(!Utils.isNull(type)){
		term +="&order.type="+type;
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>    
	<link href="../ui/lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
	<link href="../ui/lib/ligerUI/skins/Gray/css/dialog.css" rel="stylesheet" type="text/css" />
	<script src="../ui/lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>   
    <script src="../ui/lib/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="../ui/lib/ligerUI/js/ligerui.all.min.js" type="text/javascript"></script> 
    <link href="../ui/lib/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    
	<script src="../ui/helper.js" type="text/javascript"></script> 
	<script type="text/javascript">
    var grid=null; 
    var datas;
    var max = 0;
    $(function () {  
			$("#stime").ligerDateEditor({ showTime: true,initValue:'<%=stime%>'});
        	$("#etime").ligerDateEditor({ showTime: true,initValue:'<%=etime%>'}); 
	  		$("form").ligerForm();
            var url = '<%=url%>&<%=term%>';
	  		myGrid= $("#grids").ligerGrid({
        		 checkbox: true,
                 columns:[	{ display: '订单编号', name: 'orderid', width: 80},
                             { display: '订单类型', name: 'type', width: 120 },
                             { display: '订单状态', name: 'state',width: 100 },
                             { display: '产品类型', name: 'producttype',width: 100 },
                             { display: '产品名称', name: 'productname',width: 100 },
                             { display: '客户编码', name: 'clientid',width: 100 },
                             { display: 'PNR', name: 'pnr',width: 100 },
                             { display: '应收款', name: 'recmoney', width: 100,type:'float' },
                             { display: '应付款', name: 'paymoney', width: 100,type:'float' },
                             { display: '利润', name: 'profit', width: 100,type:'float' },
                             { display: '创建人', name: 'user' },
                             { display: '最后修改人', name: 'luser' },
                             { display: '最后提交时间', name: 'lastTime' }
                             ], 
                             isScroll: true, showToggleColBtn: false, width: '100%',
                             height:'98%',
                             url: url,
                 			 showTitle: false, columnWidth: 100  , frozen:false,
                 			toolbar: { items: [
				                 			   { text: '开始时间：<%=stime%>'},
				          					   { line:true },
				          					   { text: '结束时间：<%=etime%>'},
				          					   { line:true },
			                 				   { text: '自定义查询',click:f_inputQuery, icon: 'search2'},
			                 				   { line:true }
                                               ]
                                               },isChecked: f_isChecked, onCheckRow: f_onCheckRow, onCheckAllRow: f_onCheckAllRow
         
             });
    });  
    
    function f_test(){
    	var url2 = '<%=url%>&<%=term%>';
		alert(url2);
       $.getJSON(url2,function(json){
    	   alert(json);
	       	myGrid.set({ data: json }); 
       });
    }
	function f_totalRender(){
		return datas.totalRender;
	}
	
	function submitThis(){
		form1.action = "<%=jspName%>"; 
		form1.submit();
	}
	
 	function downloadThis(){
		form1.action = "../../common/download.jsp?name=<%=jspName%>&start_date=<%=stime%>&end_date=<%=etime%>"; 
		form1.fb.value = getDatasValue(datas);	
		form1.submit();
	}
	
	 function f_onCheckAllRow(checked)
        {	 
            for (var rowid in this.records)
            {
                if(checked)
                    addCheckedObj(this.records[rowid]);
                else
                    removeCheckedObj(this.records[rowid]);
            }
        }
 
        var checkedObj = [];
        function findCheckedObj(obj)
        {
            for(var i =0;i<checkedObj.length;i++)
            {
                if(checkedObj[i] == obj) return i;
            }
            return -1;
        }
        function addCheckedObj(obj)
        {
            if(findCheckedObj(obj) == -1)
                checkedObj.push(obj);
        }
        function removeCheckedObj(obj)
        {
            var i = findCheckedObj(obj);
            if(i==-1) return;
            checkedObj.splice(i,1);
        }
        function f_isChecked(rowdata)
        {
            if (findCheckedObj(rowdata) == -1)
                return false;
            return true;
        }
        function f_onCheckRow(checked, data)
        {
            if (checked) addCheckedObj(data);
            else removeCheckedObj(data);
        }	
	function f_inputQuery(){
		$.ligerDialog.open({ target: $("#target1"),title:'<%=title%>',height: 300,width: 500,isResize: true,showMax:true, 
			buttons: [
			{ text: '确定', 
				onclick: function (item, dialog) {
					 location.href = '<%=jspName%>?stime='+ $("#stime").val()
					 	+'&etime='+$("#etime").val()+'&query=<%=query%>&type=<%=type%>&check=<%=checkFlag%>';
				} },
			{ text: '取消', onclick: function (item, dialog) { dialog.hide(); }
			 } ] });
    }
    
    function doCommit(){
		if(checkedObj.length==0){
			 $.ligerDialog.warn('<br/>请选择一个订单');
			 return 'error';	
		}
		var flag = '<%=checkFlag%>';
		if(flag!='true'&&checkedObj.length>1){
			$.ligerDialog.warn('<br/>您选择了'+checkedObj.length+'个订单<br/><br/>请选择单个订单');
			return 'error';
		}
        return checkedObj;
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
<body style="padding:0 2px 2px 2px;overflow:hidden;" >
<form name="form1" method="post" id="form1">
<textarea name="fb"  style="display:none" ></textarea>
<div id='grids' ></div></div>
<div id="target1"  style="display:none" >
  <table height="72" cellpadding="0" cellspacing="0" class="l-table-edit" >
    <tr>
  	  	<td width="59"   align="right" class="l-table-edit-td">开始日期:</td>
    	<td width="128"   align="left" class="l-table-edit-td"><input type="text" id="stime" name="stime" /></td>
    	<td colspan="2" align="right" class="l-table-edit-td">开始时间:</td>
  	  	<td width="201"  colspan="2" align="left" class="l-table-edit-td"><input type="text" id="etime" name="etime" /></td>
	</tr>
    <tr>
      <td align="right" class="l-table-edit-td">订单号:</td>
      <td align="left" class="l-table-edit-td"><input type="text" id="id" name="id" value="" /></td>
      <td colspan="2" align="right" class="l-table-edit-td">&nbsp;</td>
      <td colspan="2" align="left" class="l-table-edit-td">&nbsp;</td>
    </tr>
</table> 
 </div>
</form> 
</body>
</html>
