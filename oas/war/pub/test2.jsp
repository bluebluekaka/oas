<%@page contentType="text/html;charset=UTF-8" import="java.sql.*,java.util.*"%>
<% 
	Connection conn = null;
		try {
			conn = com.oas.common.Helper.getConnection();
			Statement stmt = conn.createStatement();
			ResultSet rs ;
			String sql = "select orderid,pnr from orderinfo ";
			rs = stmt.executeQuery(sql);
			Hashtable<String,String> o_hs = new Hashtable<String,String>();
			while(rs.next()){
				String orderid = rs.getString(1);
				String pnum = rs.getString(2);
					if(pnum.indexOf(" ")!=-1){
						o_hs.put(orderid,pnum);
					}
			}
			Enumeration<String> en = o_hs.keys();
			while (en.hasMoreElements()){
				String key = en.nextElement();
				if(o_hs.get(key)!=null){
					sql = "update orderinfo set pnr="+o_hs.get(key).trim()+" where orderid='"+key+"'";
					stmt.executeUpdate(sql);
					Thread.sleep(100);
				}
			}
		} catch (Exception ee) { 
			System.out.println(ee.toString());
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (Exception ex) {
				}
			}
		}
%>