<%@page language="java" contentType="text/html;charset=UTF-8" %><%@ include file="/common/taglibs.jsp"%>
<%
	String action = "query";
	String title = "以往转账账号列表";
	String url = action+"?moduleName=transferAccount";
	
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
	  		$("form").ligerForm();
            var url1 = '<%=url%>';
	  		myGrid= $("#grids").ligerGrid({
        		 checkbox: false,
                 columns:[	{ display: '转账账号', name: 'transferAccount', width: 200}
                             ], 
                             isScroll: true, showToggleColBtn: false, width: '100%',
                             height:'99%',
                             url: url1,
                 			 showTitle: false, columnWidth: 200  , frozen:false,
                                               onSelectRow: function (data, rowindex, rowobj)
                                               {
                                            		//queryOtherExpensesList(data.financialOrderCode);
                                               },isChecked: f_isChecked, onCheckRow: f_onCheckRow, onCheckAllRow: f_onCheckAllRow 
         
             });
    });  
	function f_totalRender(){
		return datas.totalRender;
	}
	
	function submitThis(){
		form1.action = "<%=jspName%>"; 
		form1.submit();
	}
	
 	function downloadThis(){
		form1.action = "../../common/download.jsp?name=<%=jspName%>"; 
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
		
    }
    
    function doCommit(){
		var row = myGrid.getSelectedRow();
    	if(!row){
         	$.ligerDialog.warn('<br/>请选择一个账号');
		 	return 'error';
        }
        return row;
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

<div >
<div id='grids' ></div></div>
</form> 
</body>
</html>
