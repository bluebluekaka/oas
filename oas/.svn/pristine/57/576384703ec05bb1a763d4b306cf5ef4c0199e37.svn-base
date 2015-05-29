package com.oas.web.json;

import org.apache.log4j.Logger;

import com.oas.common.DataSourceAction;
import com.oas.common.Helper;
import com.oas.objects.OrderQuery;

public class OrderMarginJson extends DataSourceAction {
	private static final long serialVersionUID = -5612721889737285900L;
	protected final Logger log = Logger.getLogger(getClass());

	private OrderQuery query;
	private String sid;

	public OrderQuery getQuery() {
		return query;
	}

	public void setQuery(OrderQuery query) {
		this.query = query;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String execute() throws Exception {
		try {
			term = Helper.getQuerySql(query, "createtimei");
			skip = JSON;
			sql = "select t1.id,t1.orderid,t1.type,t1.producttype,t1.productname,t1.recmoney,t1.paymoney,t1.profit,t1.createtime,t1.userid,t2.name from orderinfo t1,user t2 where 1=1 ";
			sql += " and t1.userid=t2.uid and t1.state in (11)";
			if(query!=null){
				if(query.getType()!=99&&query.getType()!=0){
					sql += " and t1.type="+query.getType();
				}
				if(query.getProducttype()!=99&&query.getProducttype()!=0){
					sql += " and t1.producttype="+query.getProducttype();
				}
				if(!"".equals(query.getProductname())&&query.getProductname()!=null){
					sql += " and t1.productname='"+query.getProductname()+"'";
				}
				if(!"".equals(query.getUsername())&&query.getUsername()!=null){
					sql += " and t2.name='"+query.getUsername()+"'";
				}
			}
			sql += term + "  order by id";
//			System.out.println(sql);
			executeQuery(sql);
			float profits = 0;
			while (rs.next()) {
				String id = rs.getString("id");
				String order = rs.getString("orderid");
				String type = Helper.getOrderType(rs.getInt("type"));
				String producttype = Helper.getProductType(rs.getInt("producttype"));
				String productname = rs.getString("productname");
				float recmoney = rs.getFloat("recmoney");
				float paymoney = rs.getFloat("paymoney");
				float profit = rs.getFloat("profit");
				profits += profit;
				String date = rs.getDate("createtime") + "";
				String time = rs.getTime("createtime") + "";
//				String user = rs.getString("userid");
				String userName = rs.getString("name");

				if (count != 0)
					bf.append(",");
				bf.append("{'HideID':'" + id ).append("','订单编号':'" + order)
						.append("','订单类型':'" + type )
						.append("','产品类型':'" + producttype ).append("','产品名称':'" + productname)
//						.append("','客户名称':'" + clientid).append("','PNR':'" + pnr)
						.append("','总应收款':'" + recmoney ).append("','总应付款':'" + paymoney )
						.append("','单笔利润':'" + profit ).append("','累计利润':'" + profits )
						.append("','创建日期':'" + date).append("','创建时间':'" + time).append("','业务员':'" + userName + "'}");
				count++;
			}
			String counts = "总数：" + count;
			tojson(counts);
		} catch (Exception e) {
			skip = ERROR;
			e.printStackTrace();
			addActionError(e.toString());
		} finally {
			closeConnection();
		}
		return skip;
	}
}