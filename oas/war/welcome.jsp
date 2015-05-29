<%@page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>welcome</title>
     <link href="ui/lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
</head>
<body style="padding:20px">
更新内容： <br/> <br/>
<a href='update/20140305.doc' ><b style="color:red">2014年03月05日更新内容</b></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='update/20140310.doc' ><b style="color:red">2014年03月10日更新内容</b></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='update/20140317.doc' ><b style="color:red">2014年03月17日更新内容</b></a><br/> <br/>

<a href='update/20140325.doc' ><b style="color:red">2014年03月25日更新内容</b></a>  <br/> <br/>

订单流程： <br/> <br/>
业务员生成订单（填写：订单类型、产品类型、产品名称、客户编号、导入信息、旅客类型、应收款）<状态：生成中>---------业务员经理审核<状态：待审核> <br/><br/>

业务员经理审核订单<状态：待审核>------审核通过  (经理去找票号发给业务员)  ------业务员填写（票号、供应商、应付款）<状态：待出票>-----财务员（审核）<状态：出票成功> <br/> <br/>

业务员经理审核订单<状态：待审核>------审核不通过------业务员修改（订单类型、产品类型、产品名称、客户编号、导入信息、旅客类型、应收款）<状态：审核不通过>  ------业务员经理审核<状态：待审核>  <br/>  <br/>

业务员经理审核订单<状态：待审核>------取消订单(经理找不到票号发给业务员)<状态：订单取消> <br/>  <br/>

财务员（审核）<状态：出票成功>-----审核通过------<状态：结束> ------生成财务单  <br/> <br/>

财务员（审核）<状态：出票成功>-----审核不通过------业务员填写（票号、供应商、应付款）<状态： 待复出票>-----财务员（审核通过）<状态：结束>  <br/> <br/>

总经理-----可将订单修改为任何 <br/> <br/> <br/> 


订单格式1，多个旅客一个航班：<br/><br/>
1.CHEN/WEN QI 2.WU/BAO JIAO 3.XIE/XI YING 4.ZHANG/JIA LI 5.ZHANG/KANG LI<br/>    
 6.ZHANG/MIN SHAN 7.ZHANG/RU SHAN 8.ZHANG/SHAO XI 9.ZHAO/GUI NAN JTDRW9<br/>
10.  CZ375  B   SA01FEB  SWABKK HK9   0815 1035          E --1<br/>
<br/><br/>
订单格式2，一个旅客多个航班：  <br/><br/>
 1.LIN/HUI JPN7BL<br/>                                                               
 2.  CZ327  B   SA18JAN  CANLAX HK1   2130 1810          E --B<br/>                  
 3.  DL5856 B   SA18JAN  LAXSFO HK1   2000 2122      SEAME <br/>                     
 4.  UA1739 Q   MO20JAN  SFOEWR HK1   0839 1709      SEAME <br/>                     
 5.  UA3893 Q   SA25JAN  EWRDCA HK1   0853 1019      SEAME <br/>                     
 6.  UA5711 Q   FR31JAN  IADJFK HK1   0812 0925      SEAME  <br/>                    
 7.  UA397  Q   SA01FEB  JFKSFO HK1   0800 1135      SEAME  <br/>                    
 8.  DL5829 B   WE05FEB  SFOLAX HK1   0600 0727      SEAME <br/>                     
 9.  CZ328  B   WE05FEB  LAXCAN HK1   2230 0540+2        E  <br/>             
<br/><br/>
订单格式3，多个旅客多个航班：<br/><br/>
 1.CHEN/WEN QI 2.WU/BAO JIAO 3.XIE/XI YING 4.ZHANG/JIA LI 5.ZHANG/KANG LI   <br/>    
 6.ZHANG/MIN SHAN 7.ZHANG/RU SHAN 8.ZHANG/SHAO XI 9.ZHAO/GUI NAN JRGRX8   <br/>      
10.  CZ6116 Y   SA25JAN  PEKSHE HK9   0745 0915          E T2T3   <br/>              
11.  CZ351  Y   SA25JAN  SHESIN HK9   1305 2230          E T31   <br/>               
12.  SQ334  W   SA25JAN  SINCDG HK9   2355 0655+1    SEAME    <br/>                  
13.  MH021  N   FR31JAN  CDGKUL HK9   1200 0700+1        E    <br/>                  
14.  MH798  N   SA15FEB  KULHKT HK9   0430 0445          E   <br/>                   
15.  MI751  M   MO03MAR  HKTSIN HK9   1015 1300      SEAME    <br/>                  
16.  CZ352  Q   SA15MAR  SINCAN HK9   0800 1200          E 1 --   <br/>              
17.  CZ3109 R   SA15MAR  CANPEK HK9   1400 1720          E --T2  <br/>    
<br/><br/>
订单格式4，一个旅客一个航班：<br/><br/>
1.LAM/WING HVY4G2                         <br/>                                     
2.  HX146  W   TU28JAN  FOCHKG RR1   1935 2105          E     <br/>    
<br/><br/>

订单格式5，留空航班<br/><br/>
1.XU/LIYA JENH4Y                           <br/>                                               
2.CZ319  Z   TH03APR  CANPER HK1   2145 0600+1        E       <br/>                          
3.ARNK   PERMEL                                   <br/>                         
4.CZ322  V   TH24APR  MELCAN HK1   2230 0555+1        E 2 --   <br/>          

订单格式6，留空航班<br/><br/>
1.LERTSUKITTIPONGSA/SUCHAI HY1R72         <br/>                                         
 2.  CZ3927 Q   WE07MAY  SWACAN RR1   1410 1510          E       <br/>                   
 3.  CZ361  Q   WE07MAY  CANBKK RR1   1950 2200          E --1     <br/>                 
 4.  CZOPEN E            BKKSWA   <br/>   
</body>
</html>
