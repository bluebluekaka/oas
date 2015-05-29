<%@page contentType="text/html;charset=UTF-8" import="java.sql.*,java.util.*"%>
<% 
	Connection conn = null;
		try {
			conn = com.oas.common.Helper.getConnection();
			Statement stmt = conn.createStatement();
			ResultSet rs ;
			String sql = "select id,pnum from ordertraveller  where length(pnum)<13 and length(pnum)>1";
			rs = stmt.executeQuery(sql);
			Hashtable<String,String> o_hs = new Hashtable<String,String>();
			while(rs.next()){
				String id = rs.getString(1);
				String pnum = rs.getString(2);
				o_hs.put(id,pnum);
			}
			Enumeration<String> en = o_hs.keys();
			while (en.hasMoreElements()){
				String key = en.nextElement();
				if(o_hs.get(key)!=null){
					String pnum0 = o_hs.get(key);
					for(int i=pnum0.length();i<13;i++){
						pnum0="0"+pnum0;
					}
					sql = "update ordertraveller set pnum='"+pnum0+"' where id="+key;
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