package com.oas.web.json;

import java.net.URLDecoder;

import org.apache.log4j.Logger;

import com.oas.common.Config;
import com.oas.common.DBCache;
import com.oas.common.DataSourceAction;
import com.oas.common.Helper;
import com.oas.common.Utils;
import com.oas.objects.Order;
import com.oas.objects.OrderOffset;
import com.oas.objects.Query;
import com.oas.util.StringUtil;

public class OrderOffsetJson extends DataSourceAction {
	private static final long serialVersionUID = -5612721889737285900L;
	protected final Logger log = Logger.getLogger(getClass());

	private Query query;
	private Order order;
	private OrderOffset orderOffset;
	private int type;
	private String workno;

	public Query getQuery() {
		return query;
	}

	public void setQuery(Query query) {
		this.query = query;
	}

	public OrderOffset getOrderOffset() {
		return orderOffset;
	}

	public void setOrderOffset(OrderOffset orderOffset) {
		this.orderOffset = orderOffset;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public Order getOrder() {
		return order;
	}

	public void setOrder(Order order) {
		this.order = order;
	}

	public String getWorkno() {
		return workno;
	}

	public void setWorkno(String workno) {
		this.workno = workno;
	}

	public String execute() throws Exception {
		try {
			String counts = "";
			if (action != null) {
//				String usertype = (String) getSession().getAttribute(Config.USER_TYPE);
				String workno = (String) getSession().getAttribute(Config.USER_WORKNO);
//				String userid = (String) getSession().getAttribute(Config.USER_ID);
				skip = SUCCESS;
				if ("add".equals(action)) {
					orderOffset.setOffsetId(DBCache.getSequence());
					orderOffset.setCreater(workno);
					Float offsetAmounts= saveRelaFinancial(orderOffset.getOffsetId(),orderOffset.getCustomerId(),orderOffset.getTransferId(), orderOffset.getFinancialOrderCodes(), orderOffset.getOffsetTransferAmounts());
					sql = "insert into offset" +
							"(offset_id,customer_id,transfer_id,financial_order_codes,offset_transfer_amounts" +
							",offset_financial_amounts_all,offset_amounts,balance,offset_state,creater" +
							",create_time,create_timei) values("+orderOffset.getOffsetId()+",'"
							+ orderOffset.getCustomerId()
							+ "',"
							+ orderOffset.getTransferId()
							+ ",'"
							+ orderOffset.getFinancialOrderCodes()
							+ "',"
							+ orderOffset.getOffsetTransferAmounts()
							+ ","
							+ orderOffset.getOffsetFinancialAmountsAll()
							+ ","
							+ offsetAmounts
							+ ","
							+ orderOffset.getBalance()
							+ ",0,'"
							+ orderOffset.getCreater()
							+ "',"
							+"'"+Utils.getNowTimestamp()+ "',"+Utils.getSystemMillis()+")";
					executeUpdate(sql);
					
				} else if ("delete".equals(action)) {
					sql = "delete from offset where offset_id in(" + orderOffset.getOffsetIds() + ")";
					executeUpdate(sql);
				} else if ("change".equals(action)) {
//					sql = "update order_offset_info set order_code='" + orderOffset.getOrderCode() + "'"
//							+ ",return_amount="
//							+ orderOffset.getReturnAmount() + ",offset_orders='"
//							+ orderOffset.getOffsetOrders() + "',all_offset_amount="
//							+ orderOffset.getAllOffsetAmount() + ",balance="
//							+ orderOffset.getBalance() + ",last_user='"
//							+ workno +"',last_operate_time='"
//							+ Utils.getNowTimestamp()+ "',last_operate_timei='"
//							+Utils.getSystemMillis()+"'"
//							+ " where order_offset_code = "+orderOffset.getOrderOffsetCode();
//					executeUpdate(sql);
				} else if ("display".equals(action)) {
//					sql = "select order_code,return_amount,offset_orders,all_offset_amount,balance from order_offset_info where order_offset_code = "
//							+ orderOffset.getOrderOffsetCode() + "";
//					executeQuery(sql);
//					if (rs.next()) {
//						OrderOffset oo = new OrderOffset();
//						oo.setOrderOffsetCode(orderOffset.getOrderOffsetCode());
//						oo.setOrderCode(rs.getString("order_code"));
//						oo.setReturnAmount(rs.getFloat("return_amount"));
//						oo.setOffsetOrders(rs.getString("offset_orders"));
//						oo.setAllOffsetAmount(rs.getFloat("all_offset_amount"));
//						oo.setBalance(rs.getFloat("balance"));
//						this.orderOffset = oo;
//						skip = EDIT;
//					} else {
//						skip = ERROR;
//						addActionError("Reason:  " + orderOffset.getOrderOffsetCode() + " not exists");
//					}
				} else if ("view".equals(action)) {
//					sql = "select order_code,return_amount,offset_orders,all_offset_amount,balance from order_offset_info where order_offset_code = "
//						+ orderOffset.getOrderOffsetCode() + "";
//				executeQuery(sql);
//				if (rs.next()) {
//					OrderOffset oo = new OrderOffset();
//					oo.setOrderOffsetCode(orderOffset.getOrderOffsetCode());
//					oo.setOrderCode(rs.getString("order_code"));
//					oo.setReturnAmount(rs.getFloat("return_amount"));
//					oo.setOffsetOrders(rs.getString("offset_orders"));
//					oo.setAllOffsetAmount(rs.getFloat("all_offset_amount"));
//					oo.setBalance(rs.getFloat("balance"));
//					this.orderOffset = oo;
//					skip = VIEW;
//				} else {
//					skip = ERROR;
//					addActionError("Reason:  " + orderOffset.getOrderOffsetCode() + " not exists");
//				}
			}
			} else {
				term = Helper.getQuerySqlNull(query, "o.create_timei");

				skip = JSON;
				String sqlStr = "SELECT o.offset_id,o.customer_id,o.transfer_id" +
						",o.financial_order_codes,o.offset_transfer_amounts" +
						",o.offset_financial_amounts_all,o.offset_amounts" +
						",o.balance,o.offset_state,o.creater,o.create_time" +
						" FROM offset o where 1=1 " + term;
//				if((!"".equals(order.getPnr())&&order.getPnr()!=null)||order.getType()!=99||(!"".equals(order.getClientid())&&order.getClientid()!=null)){
//					sqlStr += " and exists (select 1 from orderinfo oi,financial_order fo where 1=1 and oi.orderid = fo.order_code and fo ";
//					if(!"".equals(order.getPnr())&&order.getPnr()!=null){
//						String pnr = URLDecoder.decode(order.getPnr().trim(),"UTF-8");
//						sqlStr += " and o.pnr like '%"+pnr+"%'";
//					}
//					if(order.getType()!=99){
//						sqlStr += " and o.type ="+order.getType()+"";
//					}
//					if(!"".equals(order.getClientid())&&order.getClientid()!=null){
//						sqlStr += " and o.cid like '%"+order.getClientid().trim()+"%'";
//					}
//					sqlStr +=")";
//				}
				if((!"".equals(order.getCustname())&&order.getCustname()!=null)||
						(!"".equals(order.getCustcompany())&&order.getCustcompany()!=null)){
					sqlStr += " and exists (select 1 from customer ct where 1=1 and ct.customerID = o.customer_id  ";
					if(!"".equals(order.getCustname())&&order.getCustname()!=null){
						String cname = URLDecoder.decode(order.getCustname().trim(),"UTF-8");
						sqlStr += " and ct.name like '%"+cname+"%' ";
					}
					if(!"".equals(order.getCustcompany())&&order.getCustcompany()!=null){
						String company = URLDecoder.decode(order.getCustcompany().trim(),"UTF-8");
						sqlStr += " and ct.company like '%"+company+"%' ";
					}
					sqlStr +=")";
				}
//				if(!"".equals(workno)&&workno!=null){
//					sqlStr += " and exists (select 1 from customer ct where 1=1 and ct.customerID = oi.cid and ct.name like '%"+cname+"%') ";
//					sqlStr += " and oi.userid like '%"+workno.trim()+"%'";
//				}
				sqlStr += " order by o.offset_id desc";
//				System.out.println(sqlStr);
				executeQuery(sqlStr);
				float offsetAmountsAll = 0;
				while (rs.next()) {
					Long offsetId = rs.getLong("offset_id");
					String customerId = rs.getString("customer_id");
					Long transferId = rs.getLong("transfer_id");
					String financialOrderCodes = rs.getString("financial_order_codes");
					Float offsetTransferAmounts = rs.getFloat("offset_transfer_amounts");
					Float offsetFinancialAmountsAll = rs.getFloat("offset_financial_amounts_all");
					Float offsetAmounts = rs.getFloat("offset_amounts");
					offsetAmountsAll += Float.valueOf(offsetAmounts);
					Float balance = rs.getFloat("balance");
					int offsetState = rs.getInt("offset_state");
					String creater = StringUtil.toString(rs.getString("creater"));
					String createTime = StringUtil.toString(rs.getDate("create_time"))+" "+StringUtil.toString(rs.getTime("create_time"));
					if (count != 0)
						bf.append(",");
					bf.append("{'offsetId':'" + offsetId)
							.append("','customerId':'" + customerId)
							.append("','transferId':'" + transferId)
							.append("','financialOrderCodes':'" + financialOrderCodes)
							.append("','offsetTransferAmounts':'" + offsetTransferAmounts)
							.append("','offsetFinancialAmountsAll':'" + offsetFinancialAmountsAll)
							.append("','offsetAmounts':'" + offsetAmounts)
							.append("','balance':'" + balance)
							.append("','offsetState':'" + offsetState)
							.append("','creater':'" + creater)
							.append("','createTime':'" + createTime)
							.append("'}");
					count++;
					
				}
				counts = "总数：" + count+", 总冲账款：" + String.format("%.2f", offsetAmountsAll);
				tojsonNew(counts);
			}
		} catch (Exception e) {
			skip = ERROR;
			addActionError(e.toString());
			e.printStackTrace();
		} finally {
			closeConnection();
		}
		return skip;
	}
	
	public Float saveRelaFinancial(Long offsetId,String cid,Long transferId,String financialOrderCodes,Float transferAmounts) throws Exception{
		Float transferAmountsOld = transferAmounts;
		sql = "select fo.financial_order_code,fo.received_amount,oi.recmoney " +
				" from financial_order fo inner join orderinfo oi on fo.order_code = oi.orderid " +
				" where fo.financial_order_code in ("+financialOrderCodes+") ";
		
		executeQuery(sql);
		while (rs.next()) {
			Long financialOrderCode = rs.getLong("financial_order_code");
			Float receivedAmounts = rs.getFloat("received_amount");
			Float recmoney = rs.getFloat("recmoney");
			Float money = recmoney - receivedAmounts;
			Float offsetAmounts = 0f;
			int receiveState = 0;
			if(transferAmounts>=money){
				offsetAmounts = money;
				receiveState = 1;
			}else{
				offsetAmounts = transferAmounts;
				receiveState = 2;
			}
			sql = "update financial_order fo set fo.received_amount=fo.received_amount+("+offsetAmounts+"),fo.received_state ="+receiveState+" where fo.financial_order_code = "+financialOrderCode+" ";
			executeUpdate(sql);
			sql = "insert into transfer_financial_order_rela (offset_id,transfer_id,financial_order_code,offset_financial_amounts)" +
					" values ("+offsetId+","+transferId+","+financialOrderCode+","+offsetAmounts+") ";
			executeUpdate(sql);
			transferAmounts = transferAmounts - offsetAmounts;
		}
		Float transferAmountsNew = transferAmounts;
		int usableState = 0;
		if(transferAmountsNew==0){//用完
			usableState = 1;
		}
		sql = "update customer_transfer ct set ct.usable_amount="+transferAmountsNew+",ct.usable_state ="+usableState+" where ct.transfer_id = "+transferId+" ";
		executeUpdate(sql);
		Float transferAmountsForUse = transferAmountsOld - transferAmountsNew;
		sql = "update customer c set c.residualValue=c.residualValue-("+transferAmountsForUse+"),c.paid_amount =c.paid_amount+("+transferAmountsForUse+") where c.customerID = "+cid+" ";
		executeUpdate(sql);
		return transferAmountsForUse;
	}
	
}
