<%@page language="java" contentType="text/html; charset=UTF-8" import="com.oas.common.*"%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<%
		String userName = (String)session.getAttribute(com.oas.common.Config.USER_NAME);
		String usertype = (String)session.getAttribute(Config.USER_TYPE);
    	int utype = 0;
    	if(!Utils.isNull(usertype)){
    		utype = Integer.valueOf(usertype);
    	}
	%>
    <head>
        <title></title>
        <link href="../ui/lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
        <style type="text/css">
        </style>
        <script src="../ui/lib/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>   
    	<script src="../ui/lib/ligerUI/js/core/base.js" type="text/javascript"></script>
        <script src="../ui/lib/ligerUI/js/ligerui.all.min.js" type="text/javascript"></script> 
            <script type="text/javascript">
            	var tab = null;
            	var accordion = null;
                $(function ()
                {
                    $("#layout1").ligerLayout({ leftWidth: 210,rightWidth: 430,onHeightChanged: f_heightChanged });
                    var  height = $(".l-layout-center").height();
                    $("#agentFrame").ligerLayout({ height: height });
	                $("#framecenter").ligerTab({ 
	                	height: height,
	                	onBeforeRemoveTabItem:function(tabid){
	                		document.getElementById(""+tabid).src="";
	                	},
	                	onAfterSelectTabItem:function(tabid){
	                		var url = "order_list.jsp?";
	                		if('home1'==tabid){
	                			url+="rl=1&ck=<%=Config.ORDER_STATE_CREATE%>;<%=Config.ORDER_STATE_DISALLOW_COMMON_MANAGER%>";
	                		}else if('home2'==tabid){
	                			url+="rl=1&ck=<%=Config.ORDER_STATE_WAIT_COMMON_MANAGER%>";
	                		}else if('home3'==tabid){
	                			url+="rl=1&ck=<%=Config.ORDER_STATE_ALLOW_COMMON_MANAGER%>;<%=Config.ORDER_STATE_DISALLOW_FINANCE%>";
	                		}else if('home4'==tabid){
	                			url+="rl=1&ck=<%=Config.ORDER_STATE_WAIT_FINANCE%>";
	                		}else if('home5'==tabid){
	                			url+="rl=1&ck=<%=Config.ORDER_STATE_END%>";
	                		}else if('home6'==tabid){
	                			url+="rl=1&ck=<%=Config.ORDER_STATE_CANCLE%>";
	                		}else{
	                			url+="rl=0&ck=";
	                		}
			                document.getElementById(""+tabid).src=url;
			            }
	                });
	                $("#leftMenu").ligerAccordion({ height: height, speed: null });
	               	
	                tab = $("#framecenter").ligerGetTabManager();
	                <% if(utype==Config.USER_TYPE_ADMIN){%>
					
					<%}else if (utype==Config.USER_TYPE_COMMON){%>
						
					<%}else if (utype==Config.USER_TYPE_COMMON_MANERGER){%>
						
					<%}else if (utype==Config.USER_TYPE_FINANCE){%>
						tab.selectTabItem('home4');
					<%}else if (utype==Config.USER_TYPE_FINANCE_MANERGER){%>
						
					<%}else if (utype==Config.USER_TYPE_TOP_MANERGER){%>	
						
					<%}%>
					function f_heightChanged(options)
			            {
			                if (tab)
			                    tab.addHeight(options.diff);
			                $("#agentFrame").ligerLayout({ height: options.middleHeight});
			                if (accordion && options.middleHeight  > 0)
                   				accordion.setHeight(options.middleHeight);
			            }
                });
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
      <div id="layout1">
            <div position="center"  id="framecenter" >
             	<div tabid="home" title="所有状态" style="height:300px" >
	                <iframe frameborder="0" name="home" id="home" src="order_list.jsp"></iframe>
	            </div>
	            <div tabid="home1" title="生成中" style="height:300px" >
	             <iframe frameborder="0" name="home1" id="home1" src=""></iframe>
	            </div>
	            <div tabid="home2" title="待审核" style="height:300px" >
	            <iframe frameborder="0" name="home2" id="home2" src=""></iframe>
	            </div>
	            <div tabid="home3" title="待出票" style="height:300px" >
	            <iframe frameborder="0" name="home3" id="home3" src=""></iframe>
	            </div>
	            <div tabid="home4" title="出票成功" style="height:300px" >
	            <iframe frameborder="0" name="home4" id="home4" src=""></iframe>
	            </div>
	            <div tabid="home5" title="结束" style="height:300px" >
	            <iframe frameborder="0" name="home5" id="home5" src=""></iframe>
	            </div>
	            <div tabid="home6" title="取消" style="height:300px" >
	            <iframe frameborder="0" name="home6" id="home6" src=""></iframe>
	            </div>
            </div>
        </div> 
    </body>
    </html>