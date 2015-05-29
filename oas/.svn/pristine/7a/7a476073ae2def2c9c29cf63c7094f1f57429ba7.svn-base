<%@page contentType="text/html;charset=UTF-8" import="java.sql.*,java.util.*"%>
<% 
	Connection conn = null;
		try {
			conn = com.oas.common.Helper.getConnection();
			Statement stmt = conn.createStatement();
			ResultSet rs ;
			String sql = "select cid,sum(recmoney) from orderinfo where state=4 or state=11 group by cid";
			rs = stmt.executeQuery(sql);
			Hashtable<String,Integer> o_hs = new Hashtable<String,Integer>();
			while(rs.next()){
				o_hs.put(rs.getString(1),rs.getInt(2));
			}
			sql = "select customerId,residualvalue from customer  ";
			Hashtable<String,Integer> c_hs = new Hashtable<String,Integer>();
			rs = stmt.executeQuery(sql);
			while(rs.next()){
				c_hs.put(rs.getString(1),rs.getInt(2));				
			}
			sql = "select customer_id,sum(transfer_amount) from customer_transfer where transfer_state =2 group by customer_id";
			Hashtable<String,Integer> t_hs = new Hashtable<String,Integer>();
			rs = stmt.executeQuery(sql);
			while(rs.next()){
				t_hs.put(rs.getString(1),rs.getInt(2));				
			}
			Enumeration<String> en = o_hs.keys();
			while (en.hasMoreElements()){
				String key = en.nextElement();
				if(t_hs.get(key)==null){
					sql = "update customer set residualvalue="+(-1)*o_hs.get(key)+" where customerId='"+key+"'";
					stmt.executeUpdate(sql);
					Thread.sleep(100);
				}else{
					sql = "update customer set residualvalue="+(-1*o_hs.get(key)+t_hs.get(key))+" where customerId='"+key+"'";
					stmt.executeUpdate(sql);
					Thread.sleep(100);
				}
				out.println("cid="+key+",o="+o_hs.get(key)+",c:"+c_hs.get(key)+",t:"+t_hs.get(key)+"\r\n");
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