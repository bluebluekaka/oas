<%@page language="java" contentType="text/html; charset=UTF-8"%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<%
		String userName = (String)session.getAttribute(com.oas.common.Config.USER_NAME);
	%>
    <head>
        <title></title>
        <link href="ui/lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
        <style type="text/css">
        </style>
        <script src="ui/lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>   
    	<script src="ui/lib/ligerUI/js/core/base.js" type="text/javascript"></script>
        <script src="ui/lib/ligerUI/js/ligerui.all.min.js" type="text/javascript"></script> 
      	<script src="menu.jsp" type="text/javascript"></script>
            <script type="text/javascript">
            	var tab = null;
            	var accordion = null;
                $(function ()
                {
                	timer = window.setInterval("checkConnCM()",30*60*1000);
                    $("#layout1").ligerLayout({ leftWidth: 210,rightWidth: 430,heightDiff:-30,onHeightChanged: f_heightChanged });
                    var  height = $(".l-layout-center").height();
                    $("#agentFrame").ligerLayout({ height: height - 18 });
	                $("#framecenter").ligerTab({ 
	                	height: height,
	                	onBeforeRemoveTabItem:function(tabid){
	                		document.getElementById(""+tabid).src="";
	                	}
	                });
	                $("#leftMenu").ligerAccordion({ height: height - 18, speed: null });
	                $("#tree1").ligerTree({
	                    data : indexdata,
	                    checkbox: false,
	                    slide: false,
	                    nodeWidth: 120,
	                    attribute: ['nodename', 'url'],
	                    onClick:  function (node){
			                if (!node.data||!node.data.url) return;
			                var tabid = $(node.target).attr("tabid");
			               	if(node.data.id)
			               		tabid = node.data.id;
			                if (!tabid)
			                {
			                    tabid = new Date().getTime();
			                    $(node.target).attr("tabid", tabid);
			                }             
			                f_addTab(tabid, node.data.text, node.data.url);
	           			}
	                });
	                tab = $("#framecenter").ligerGetTabManager();
	                accordion = $("#leftMenu").ligerGetAccordionManager();
	                function f_addTab(tabid,text, url)
			            { 
			                tab.addTabItem({ tabid : tabid,text: text, url: url });
			            } 
					function f_heightChanged(options)
			            {
			                if (tab)
			                    tab.addHeight(options.diff);
			                $("#agentFrame").ligerLayout({ height: options.middleHeight - 18 });
			                if (accordion && options.middleHeight - 24 > 0)
                   				accordion.setHeight(options.middleHeight - 24);
			            }
                });
               
	                    
                function addtab(tid,agent){
                	var u = '';
                	var title='';
                	tid = new Date().getTime();
                	tab.addTabItem({ tabid : tid,text: title, url: u }); 
                }
                window.onbeforeunload = function () { 
		            return '警告	:您选择了刷新或者离开本页面，若选择“离开页面”未保存数据将会丢失。';
		        }
		                
                function logout()
			            { 
			                 $.ligerDialog.confirm('确定要退出吗',
			                 	function (yes) {
			                 	if(yes==true) location.href='common/logout.jsp';
			                 	} 
			                 );
			            }
			     function checkConnCM(){
			    	
                    $.ajax({
					   type:"post", //请求方式
					   url:"updateAction", //发送请求地址
					   data:{ //发送给数据库的数据
					   	test:"testvalue"
					   },
					   timeout : 1000,
					   //请求成功后的回调函数有两个参数
					   success:function(data,textStatus){
					   		//alert(data+"|"+textStatus);
					   },
					   complete : function(XMLHttpRequest,status){ //请求完成后最终执行参数
					　　　　
					　　}});
			    
			    }        
			            
			    window.setTimeout(function e(){
					//location.href="logon";
				},2*60*60*1000);// 2hour  
         </script> 
        <style type="text/css"> 
            body{ padding:0px; margin:0; padding-bottom:15px;}
            #layout1{  width:100%;margin:0; padding:0;  }  
            .l-page-bottom { height:25px; background:#f8f8f8; margin-bottom:0px; text-align:center; height:30px; line-height:30px; }
            .l-page-top { margin:0; padding:0; height:31px; line-height:25px; background:url('images/top_bg.jpg') repeat-x bottom;  position:relative; border-top:1px solid #1D438B;  }
		    .l-topmenu-logo{   padding-left:35px; line-height:31px; }
		    .l-topmenu-welcome{  position:absolute; height:24px; line-height:24px;  right:30px; top:2px;color:#000;}
		    .l-topmenu-welcome a{ color:#000; text-decoration:none}
		     #leftMenu{ overflow:auto;}
        </style>
    </head>
    <body style="padding:2px">  
      <div class="l-page-top" > 
      <div class="l-topmenu-logo"><b style="font-size:14px;">Office Automation System</b></div>  
    <div class="l-topmenu-welcome">
        <%=userName%>,您好! 
        <span class="space">|</span>
        <a href="#" class="l-link2"  onclick="logout()">退出</a>
    </div> </div>
      <div id="layout1">
            <div position="left" title="功能菜单" id = "leftMenu">
            	<ul id="tree1" style="margin-top:3px;"></ul>
            </div>
            
            <div position="center"  id="framecenter" >
             	 <div tabid="home" title="主页面" style="height:300px" >
	                <iframe frameborder="0" name="home" id="home" src="welcome.jsp"></iframe>
	            </div> 
            </div>
        </div> 
        <div class="l-page-bottom">
        	Version [d<%=com.oas.common.Config.version%>] , Copyright(C) 2013 OAS, Inc. All Rights Reserved.
		</div>
    </body>
    </html>