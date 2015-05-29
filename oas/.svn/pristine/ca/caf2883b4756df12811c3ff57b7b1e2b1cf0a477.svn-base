package com.oas.web.json;

import java.net.URLDecoder;

import org.apache.log4j.Logger;

import com.oas.common.Config;
import com.oas.common.DataSourceAction;
import com.oas.common.Helper;
import com.oas.common.Utils;
import com.oas.objects.Customer;
import com.oas.objects.FastOrder;
import com.oas.objects.Query;
import com.oas.util.StringUtil;

public class FastOrderJson extends DataSourceAction {

	private static final long serialVersionUID = -5612721889737285900L;
	protected final Logger log = Logger.getLogger(getClass());

	private Query query;
	private FastOrder fastOrder;
	private String workno;
	private String clientid;
	private Long fastOrderId;
	private int autoAudit;
	
	private Customer customer;
	
	public Query getQuery() {
		return query;
	}
	
	public void setQuery(Query query) {
		this.query = query;
	}

	public String getWorkno() {
		return workno;
	}

	public void setWorkno(String workno) {
		this.workno = workno;
	}

	public String getClientid() {
		return clientid;
	}

	public void setClientid(String clientid) {
		this.clientid = clientid;
	}

	public FastOrder getFastOrder() {
		return fastOrder;
	}

	public void setFastOrder(FastOrder fastOrder) {
		this.fastOrder = fastOrder;
	}

	public Long getFastOrderId() {
		return fastOrderId;
	}

	public void setFastOrderId(Long fastOrderId) {
		this.fastOrderId = fastOrderId;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	public int getAutoAudit() {
		return autoAudit;
	}

	public void setAutoAudit(int autoAudit) {
		this.autoAudit = autoAudit;
	}

	public String execute() throws Exception {
		try {
			if (action != null) {
				skip = SUCCESS;
				String userid = (String) getSession().getAttribute(Config.USER_ID);
				String workno = (String) getSession().getAttribute(Config.USER_WORKNO);
				String usertype = (String) getSession().getAttribute(Config.USER_TYPE);
				int utype = 1;
				if(usertype!=null)
					utype = Integer.valueOf(usertype);
				if ("add".equals(action)) {
					String orderid = "";
					if(utype==Config.USER_TYPE_FINANCE_MANERGER||utype==Config.USER_TYPE_TOP_MANERGER){
						
						if(fastOrder.getType()==0){
							orderid = "JP"+getOrderID(workno);
						}else if(fastOrder.getType()==1){
							orderid = "TP"+getOrderID(workno);
						}
						fastOrder.setState(2);
					}
					if(utype==Config.USER_TYPE_FINANCE){
						fastOrder.setState(0);
					}
					fastOrder.setOrderid(orderid);
					sql = "insert into fast_order" +
							"(relaOrderId,customer_id,type,pnr" +
							",creater,createtime,createtimei" +
							",state,recmoney,paymoney,profit,mark) values('"
							+ fastOrder.getOrderid()
							+ "','"
							+ fastOrder.getClientid()
							+ "',"+fastOrder.getType()+",'"
							+ fastOrder.getPnr()
							+ "','"
							+ workno
							+ "',"
							+"'"+Utils.getNowTimestamp()+ "',"+Utils.getSystemMillis()+","+fastOrder.getState()+","+fastOrder.getRecmoney()+","+fastOrder.getPaymoney()+","+fastOrder.getProfit()+",'"+fastOrder.getMark()+"')";
					System.out.println(sql);
					executeUpdate(sql);
					if(utype==Config.USER_TYPE_FINANCE_MANERGER||utype==Config.USER_TYPE_TOP_MANERGER){
						//插入订单表
						sql = "insert into orderinfo(orderid,state,type,producttype,productname,cid,pnr,recmoney,paymoney,profit,lasttime,lasttimei,userid,lastuser,createtime,createtimei,offercompany) values('"
							+ fastOrder.getOrderid()
							+ "',"
							+ Config.ORDER_STATE_END
							+ ","
							+ fastOrder.getType()
							+ ",0,'FO','"
							+ fastOrder.getClientid()
							+ "','"
							+ fastOrder.getPnr()
							+ "',"
							+ fastOrder.getRecmoney()
							+ ","
							+ fastOrder.getPaymoney()
							+ ","
							+ fastOrder.getProfit()
							+ ",'"
							+ Utils.getNowTimestamp()
							+ "',"
							+ Utils.getSystemMillis()
							+ ",'"
							+ workno
							+ "','"
							+ workno
							+ "','"
							+ Utils.getNowTimestamp()
							+ "',"
							+Utils.getSystemMillis()
							+ ",null)";
					//						System.out.println(sql);
					executeUpdate(sql);
					markUserLogs("添加订单:" + fastOrder.getOrderid());
					markOrderLogs(fastOrder);
					//更新客户欠款
					Double pa = fastOrder.getRecmoney();
					if(fastOrder.getType()==1){
						pa = -pa;
					}
					//插入客户款项记录表
					sql = "insert into customer_amount_logs (customer_id,rela_id" +
					",type,residualValueOld,residualValueNew,paid_amount_old" +
					",paid_amount_new,lasttime,lasttimei,cmnt) " +
					"select c.customerID,'"+fastOrder.getOrderid()+"'" +
					",9,c.residualValue,c.residualValue" +
					",c.paid_amount,c.paid_amount- ("+pa+"),'"+Utils.getNowTimestamp()+ "',"+Utils.getSystemMillis()+",'出票欠款："+pa+"' " +
					"FROM customer c WHERE c.customerID = '"+fastOrder.getClientid()+"' ";
					executeUpdate(sql);
					
					sql = "update customer set paid_amount = paid_amount - ("+pa+")  where customerID = '"+fastOrder.getClientid()+"'";
					executeUpdate(sql);
					
					//插入财务单表
					markFinancial(fastOrder, 0, fastOrder.getProfit());
					}
				}else if ("delete".equals(action)) {
					sql = "delete from fast_order where fast_order_id = " + fastOrderId + "";
					executeUpdate(sql);
				} else if ("change".equals(action)) {
//					sql = "update customer_transfer set customer_id='"+transfer.getCustomerId()+"',transfer_account='" + transfer.getTransferAccount() + "'"
//					+ ",transfer_amount="
//					+ transfer.getTransferAmount() + ",transfer_type="
//					+ transfer.getTransferType() + ",remark='"
//					+ transfer.getRemark() +"',last_user='"
//					+ workno +"',last_operate_time='"
//					+ Utils.getNowTimestamp()+ "',last_operate_timei='"
//					+ Utils.getSystemMillis()+"'"
//					+ " where transfer_id = "+transfer.getTransferId();
//					executeUpdate(sql);
				} else if ("display".equals(action)) {
					sql = "SELECT fo.fast_order_id,fo.relaOrderId,fo.customer_id" +
							",fo.type,fo.pnr,fo.state,fo.recmoney,fo.paymoney,fo.profit" +
							",c.company,c.name,c.phone,c.QQ,c.residualValue,c.paid_amount" +
							" FROM fast_order fo" +
							" LEFT JOIN customer c on fo.customer_id = c.customerID" +
							" where 1=1" +
							" and fo.fast_order_id = "+ fastOrderId + "";
					executeQuery(sql);
					if (rs.next()) {
						fastOrderId = rs.getLong("fast_order_id");
						fastOrder.setOrderid(rs.getString("relaOrderId"));
						fastOrder.setClientid(rs.getString("customer_id"));
						fastOrder.setType(rs.getInt("type"));
						fastOrder.setState(rs.getInt("state"));
						fastOrder.setPnr(rs.getString("pnr"));
						fastOrder.setRecmoney(rs.getDouble("recmoney"));
						fastOrder.setPaymoney(rs.getDouble("paymoney"));
						fastOrder.setProfit(rs.getDouble("profit"));

						Customer c = new Customer();
						c.setCompany(rs.getString("company"));
						c.setName(rs.getString("name"));
						c.setQq(rs.getString("QQ"));
						c.setPhone(rs.getString("phone"));
						c.setResidualValue(rs.getFloat("residualValue"));
						c.setPaidAmount(rs.getFloat("paid_amount"));
						this.customer = c;
						skip = EDIT;
					} else {
						skip = ERROR;
						addActionError("Reason:  " + fastOrderId + " not exists");
					}
				} else if ("view".equals(action)) {
					sql = "SELECT fo.fast_order_id,fo.relaOrderId,fo.customer_id" +
					",fo.type,fo.pnr,fo.state,fo.recmoney,fo.paymoney,fo.profit" +
					",c.company,c.name,c.phone,c.QQ,c.residualValue,c.paid_amount" +
					" FROM fast_order fo" +
					" LEFT JOIN customer c on fo.customer_id = c.customerID" +
					" where 1=1" +
					" and fo.fast_order_id = "+ fastOrderId + "";
					System.out.println(sql);
					executeQuery(sql);
					if (rs.next()) {
						FastOrder fastOrder = new FastOrder();
						fastOrderId = rs.getLong("fast_order_id");
						fastOrder.setOrderid(rs.getString("relaOrderId")==null ? "" : rs.getString("relaOrderId"));
						fastOrder.setClientid(rs.getString("customer_id"));
						fastOrder.setType(rs.getInt("type"));
						fastOrder.setState(rs.getInt("state"));
						fastOrder.setPnr(rs.getString("pnr"));
						fastOrder.setRecmoney(rs.getDouble("recmoney"));
						fastOrder.setPaymoney(rs.getDouble("paymoney"));
						fastOrder.setProfit(rs.getDouble("profit"));
						this.fastOrder = fastOrder;
		
						Customer c = new Customer();
						c.setCompany(rs.getString("company"));
						c.setName(rs.getString("name"));
						c.setQq(rs.getString("QQ"));
						c.setPhone(rs.getString("phone"));
						c.setResidualValue(rs.getFloat("residualValue"));
						c.setPaidAmount(rs.getFloat("paid_amount"));
						this.customer = c;
						skip = VIEW;
					} else {
						skip = ERROR;
						addActionError("Reason:  " + fastOrderId + " not exists");
					}
				}else if ("sm".equals(action)) {
					sql = "update fast_order set state=1,lastuser='"
					+ workno +"',lasttime='"
					+ Utils.getNowTimestamp()+ "',lasttimei='"
					+ Utils.getSystemMillis()+ "' "
					+ " where fast_order_id in ("+fastOrder.getFastOrderIds()+")";
					System.out.println(sql);
					executeUpdate(sql);
					queryList();
				}else if("cancel".equals(action)){
					//先更新状态为作废
					System.out.println("作废开始");
					sql = "update fast_order set order_state = 1 where fast_order_id = "+fastOrder.getOrderid()+"";
					System.out.println(sql);
					executeUpdate(sql);
					int orderstate = fastOrder.getState();
					if(orderstate==2){
						//查找到关联的订单及财务单
						String sql1 = "select o.*,fo1.* from orderinfo o,fast_order fo" +
								",financial_order fo1 where fo1.order_code = o.orderid " +
								"and o.orderid = fo.relaOrderId and fo1.order_state = 0 " +
								"and o.state != -1 and fo.fast_order_id = "+fastOrder.getOrderid()+" ";
						System.out.println(sql1);
						executeQuery(sql1);
						while (rs.next()) {
							boolean isOffset = false;
							float balance = 0;
							float debt = 0;
							String orderId = rs.getString("orderid");
							String cid = rs.getString("cid");
							float recmoney1 = rs.getFloat("recmoney");
							String financialOrderCode = rs.getString("financial_order_code");
							//查找是否有冲账记录
							String sql2 = "select * from offset where find_in_set('"+financialOrderCode+"', financial_order_codes) and offset_state = 0 ";
							System.out.println(sql2);
							executeQuery(sql2);
							
							while (rs.next()) {
								isOffset = true;
								String offsetId = rs.getString("offset_id");
								Long transferId = rs.getLong("transfer_id");
								float offsetAmounts = rs.getFloat("offset_financial_amounts_all");
								balance += offsetAmounts;
								debt += -offsetAmounts;
								String sql3 = "select * from transfer_financial_order_rela where offset_id = "+offsetId+" ";
								System.out.println(sql3);
								executeQuery(sql3);
								while (rs.next()) {
									String financialOrderCodeTemp = rs.getString("financial_order_code");
									float offsetFinancialAmounts = rs.getFloat("offset_financial_amounts");
									
														
									if(!financialOrderCodeTemp.equals(financialOrderCode)){
										//如果有其他的财务单，则回退
										String sql4 = "select oi.recmoney,fo.received_amount,fo.received_state " +
										" from financial_order fo,orderinfo oi " +
										" where fo.order_code = oi.orderid and financial_order_code = "+financialOrderCodeTemp+" ";
										System.out.println(sql4);
										executeQuery(sql4);
										if (rs.next()) {
											int receivedState = rs.getInt("received_state");
											float recmoney = rs.getFloat("recmoney");
											float receivedAmount = rs.getFloat("received_amount");
											if(receivedAmount!=0){
												float rAmount = receivedAmount - offsetFinancialAmounts;
												if(rAmount==0){
													if(recmoney!=0){
														receivedState = 0;
													}
													
												}else{
													receivedState = 2;
												}
												String sql5 = "update financial_order set received_amount = "+rAmount+",received_state = "+receivedState+" where financial_order_code = "+financialOrderCodeTemp+" ";
												System.out.println(sql5);
												executeUpdate(sql5);
											}
										}
									}
								}
								
								//回退转账单
								String sql6 = "select * from customer_transfer where transfer_id = "+transferId+" ";
								System.out.println(sql6);
								executeQuery(sql6);
								if (rs.next()) {
									int state = rs.getInt("transfer_state");
									float transferAmount = rs.getFloat("transfer_amount");
									float f = transferAmount-offsetAmounts;
									if(f==0){
										if(transferAmount!=0){
											state = 0;
										}
									}else{
										state = 2;
									}
									String sql7 = "update customer_transfer set transfer_state = "+state+",usable_amount = "+offsetAmounts+" where transfer_id = "+transferId+" ";
									System.out.println(sql7);
									executeUpdate(sql7);
								}
								//作废冲账单
								String sql8 = "update offset set offset_state = 1 where offset_id = "+offsetId+" ";
								System.out.println(sql8);
								executeUpdate(sql8);
							}
							if(!isOffset){
								debt = recmoney1;
							}
							//作废财务单
							String sql9 = "update financial_order set order_state = 1 where financial_order_code = "+financialOrderCode+"";
							System.out.println(sql9);
							executeUpdate(sql9);
							//作废订单
							String sql10 = "update orderinfo set state = -1 where orderid = '"+orderId+"'";
							System.out.println(sql10);
							executeUpdate(sql10);
							sql = "insert into customer_amount_logs (customer_id,rela_id" +
							",type,residualValueOld,residualValueNew,paid_amount_old" +
							",paid_amount_new,lasttime,lasttimei,cmnt) " +
							"select c.customerID,'"+financialOrderCode+"'" +
							",10,c.residualValue,c.residualValue + ("+balance+")" +
							",c.paid_amount,c.paid_amount + ("+debt+"),'"+Utils.getNowTimestamp()+ "',"+Utils.getSystemMillis()+",'快速订单回退' " +
							"FROM customer c WHERE c.customerID = '"+cid+"' ";

							System.out.println(sql);
							executeUpdate(sql);
							sql = "UPDATE customer c set c.residualValue = c.residualValue + ("+balance+"),c.paid_amount = c.paid_amount + ("+debt+") where c.customerID  = '" + cid + "'";
							System.out.println(sql);
							executeUpdate(sql);
						}
					
					}
				}else if ("audit".equals(action)) {
					String[] fastOrderIds = fastOrder.getFastOrderIds().split(",");
					int state = fastOrder.getState();
					for(String fastOrderId : fastOrderIds){
						FastOrder fastOrderNew = new FastOrder();
						sql = "select * from fast_order where fast_order_id = "+fastOrderId+"";
						executeQuery(sql);
						int type = 0;
						while (rs.next()) {
							type = rs.getInt("relaOrderId");
							String pnr = rs.getString("pnr");
							Float recmoney = rs.getFloat("recmoney");
							Float paymoney = rs.getFloat("paymoney");
							Float profit = rs.getFloat("profit");
							String customerId = rs.getString("customer_id");
							int type1 = rs.getInt("type");
							fastOrderNew.setType(type1);
							fastOrderNew.setClientid(customerId);
							fastOrderNew.setPnr(pnr);
							fastOrderNew.setRecmoney(recmoney);
							fastOrderNew.setPaymoney(paymoney);
							fastOrderNew.setProfit(profit);
						}
						String orderid = "";
						if(state==2){
							if(type==0){
								orderid = "JP"+getOrderID(workno);
							}else if(type==1){
								orderid = "TP"+getOrderID(workno);
							}
						}
						fastOrderNew.setOrderid(orderid);
						sql = "update fast_order set relaOrderId = '"+orderid+"',state="+state+",lastuser='"
						+ workno +"',lasttime='"
						+ Utils.getNowTimestamp()+ "',lasttimei='"
						+ Utils.getSystemMillis()+ "' "
						+ " where fast_order_id = "+fastOrderId+" ";
						System.out.println(sql);
						executeUpdate(sql);
						if(state==2){
							//插入订单表
							sql = "insert into orderinfo(orderid,state,type,producttype,productname,cid,pnr,recmoney,paymoney,lasttime,lasttimei,userid,lastuser,createtime,createtimei,offercompany) values('"
								+ fastOrderNew.getOrderid()
								+ "',"
								+ Config.ORDER_STATE_END
								+ ","
								+ fastOrderNew.getType()
								+ ",0,'FO','"
								+ fastOrderNew.getClientid()
								+ "','"
								+ fastOrderNew.getPnr()
								+ "',"
								+ fastOrderNew.getRecmoney()
								+ ","
								+ fastOrderNew.getPaymoney()
								+ ",'"
								+ Utils.getNowTimestamp()
								+ "',"
								+ Utils.getSystemMillis()
								+ ",'"
								+ workno
								+ "','"
								+ workno
								+ "','"
								+ Utils.getNowTimestamp()
								+ "',"
								+Utils.getSystemMillis()
								+ ",null)";
						//						System.out.println(sql);
							executeUpdate(sql);
							markUserLogs("添加订单:" + fastOrderNew.getOrderid());
							markOrderLogs(fastOrderNew);
							//更新客户欠款
							Double pa = fastOrderNew.getRecmoney();
							if(fastOrderNew.getType()==1){
								pa = -pa;
							}
							//插入客户款项记录表
							sql = "insert into customer_amount_logs (customer_id,rela_id" +
							",type,residualValueOld,residualValueNew,paid_amount_old" +
							",paid_amount_new,lasttime,lasttimei,cmnt) " +
							"select c.customerID,'"+fastOrderNew.getOrderid()+"'" +
							",9,c.residualValue,c.residualValue" +
							",c.paid_amount,c.paid_amount- ("+pa+"),'"+Utils.getNowTimestamp()+ "',"+Utils.getSystemMillis()+",'出票欠款："+pa+"' " +
							"FROM customer c WHERE c.customerID = '"+fastOrderNew.getClientid()+"' ";
							System.out.println(sql);
							executeUpdate(sql);
							
							sql = "update customer set paid_amount = paid_amount - ("+pa+")  where customerID = '"+fastOrderNew.getClientid()+"'";
							System.out.println(sql);
							executeUpdate(sql);
							
							//插入财务单表
							markFinancial(fastOrderNew, 0, fastOrderNew.getProfit());
						}
						
					}
					queryList();
				}
				
			} else {
				queryList();
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
	
	public void queryList() throws Exception{
		term = Helper.getQuerySqlNull(query, "fo.createtimei");

		skip = JSON;
		String sqlStr = "SELECT fo.fast_order_id,fo.relaOrderId,fo.customer_id,fo.type,fo.pnr" +
				",fo.createtime,fo.createtimei,fo.creater,fo.lasttime,fo.lasttimei,fo.lastuser" +
				",fo.state,fo.order_state,fo.mark,fo.recmoney,fo.paymoney,fo.profit,u1.name userName,u2.name luserName" +
				",c.company,c.name,c.phone,c.QQ,c.residualValue,c.paid_amount,ffo.received_state" +
				" FROM fast_order fo" +
				" LEFT JOIN customer c on fo.customer_id = c.customerID" +
				" LEFT JOIN financial_order ffo ON ffo.order_code = fo.relaOrderId" +
				" left join user u1 on fo.creater = u1.workcardno" +
				" left join user u2 on fo.lastuser = u2.workcardno" +
				" where 1=1 " + term;
		if(customer!=null&&(customer.getCustomerID()!=null||customer.getName()!=null||customer.getPhone()!=null||customer.getQq()!=null||customer.getCompany()!=null)){
			sqlStr += " and exists (select 1 from customer c where 1=1 and c.customerID = fo.customer_id ";
			if(customer.getCustomerID()!=null&&!"".equals(customer.getCustomerID())){
				sqlStr += " and c.customerID ='"+customer.getCustomerID()+"'";
			}
			if(customer.getName()!=null&&!"".equals(customer.getName())){
				String name = URLDecoder.decode(customer.getName(),"UTF-8");
				sqlStr += " and c.name like '%"+name+"%'";
			}
			if(customer.getCompany()!=null&&!"".equals(customer.getCompany())){
				String company = URLDecoder.decode(customer.getCompany(),"UTF-8");
				sqlStr += " and c.company like '%"+company+"%'";
			}
			if(customer.getPhone()!=null&&!"".equals(customer.getPhone())){
				sqlStr += " and c.phone like '"+customer.getPhone()+"%'";
			}
			if(customer.getQq()!=null&&!"".equals(customer.getQq())){
				sqlStr += " and c.QQ like '"+customer.getQq()+"%'";
			}
			if(customer.getOperator()!=null&&!"".equals(customer.getOperator())){
				sqlStr += " and c.operator like '"+customer.getOperator()+"%'";
			}
			sqlStr +=")";
		}
		sqlStr += " order by fo.fast_order_id desc";
		System.out.println(sqlStr);
		executeQuery(sqlStr);
		while (rs.next()) {
			Long fastOrderId = rs.getLong("fast_order_id");
			String relaOrderId = rs.getString("relaOrderId");
			String pnr = rs.getString("pnr");
			Float recmoney = rs.getFloat("recmoney");
			Float paymoney = rs.getFloat("paymoney");
			Float profit = rs.getFloat("profit");
			String customerId = rs.getString("customer_id");
			int type = rs.getInt("type");
			int state = rs.getInt("state");
			String name = rs.getString("name");
			String mark = StringUtil.toString(rs.getString("mark"));
			int receivedState = rs.getInt("received_state");
			int orderState = rs.getInt("order_state");
			String company = rs.getString("company");
			String user = StringUtil.toString(rs.getString("creater"));
			String luser = StringUtil.toString(rs.getString("lastuser"));
			String userName = StringUtil.toString(rs.getString("userName"));
			String luserName = StringUtil.toString(rs.getString("luserName"));
			String createTime = StringUtil.toString(rs.getDate("createtime"))+" "+StringUtil.toString(rs.getTime("createtime"));
			String updateTime = StringUtil.toString(rs.getDate("lasttime"))+" "+StringUtil.toString(rs.getTime("lasttime"));
			if (count != 0)
				bf.append(",");
			bf.append("{'fastOrderId':'" + fastOrderId + "'")
			  .append(",'relaOrderId':'" + relaOrderId + "'")
			  .append(",'pnr':'" + pnr + "'")
			  .append(",'type':'" + type + "'")
			  .append(",'state':'" + state + "'")
			  .append(",'recmoney':'" + recmoney + "'")
			  .append(",'paymoney':'" + paymoney + "'")
			  .append(",'profit':'" + profit + "'")
			  .append(",'mark':'" + mark + "'")
			  .append(",'receivedState':'" + receivedState + "'")
			  .append(",'orderState':'" + orderState + "'")
			  .append(",'user':'" + user + "'")
			  .append(",'userName':'" + userName + "'")
			  .append(",'createTime':'" + createTime + "'")
			  .append(",'customerId':'" + customerId + "'")
			  .append(",'name':'" + name + "'")
			  .append(",'company':'" + company + "'")
			  .append(",'luser':'" + luser + "'")
			  .append(",'luserName':'" + luserName + "'")
			  .append(",'updateTime':'" + updateTime + "'}");
			count++;
		}
		String counts = "总数：" + count;
		tojsonNew(counts);
	}
	
	protected String getOrderID(String carno) throws Exception {
		String date = Utils.getNowDate();
		int num = 1;
		sql = "select orderid from orderinfo where userid='" + carno + "' and date(createtime)=date('" + date
				+ "') order by id desc limit 0,1";
		executeQuery(sql);
		if (rs.next()) {
			String ono = rs.getString(1);
			if("null".equals(ono)){
				return carno + date.replaceAll("-", "").substring(2)+"001";
			}
			int t = Integer.valueOf(ono.substring(ono.length() - 3));
			num = t + 1;
		}
		String states = carno + date.replaceAll("-", "").substring(2);
		if (num < 10) {
			states += "00" + num;
		} else if (num < 100) {
			states += "0" + num;
		} else {
			states += num;
		}
		return states;
	}
	
	protected void markOrderLogs(FastOrder fastOrder2) {
		String userid = (String) getSessionAttribute(Config.USER_ID);
		sql = "insert into orderlogs(orderid,state,type,producttype,productname,cid,pnr,recmoney,paymoney,lasttime,lasttimei,lastuser) values('"
				+ fastOrder2.getOrderid()
				+ "',"
				+ fastOrder2.getState()
				+ ","
				+ fastOrder2.getType()
				+ ","
				+ fastOrder2.getProducttype()
				+ ",'"
				+ fastOrder2.getProductname()
				+ "','"
				+ fastOrder2.getClientid()
				+ "','"
				+ fastOrder2.getPnr()
				+ "',"
				+ fastOrder2.getRecmoney()
				+ ","
				+ fastOrder2.getPaymoney()
				+ ",'"
				+ Utils.getNowTimestamp()
				+ "',"
				+ Utils.getSystemMillis() + ",'" + userid + "')";
		executeUpdate(sql);
	}
	
	protected void markFinancial(FastOrder order, int fstate, double profit) throws Exception {
		//		String userid = (String) getSessionAttribute(Config.USER_WORKNO);
		sql = "select order_code from financial_order where order_code = '" + order.getOrderid() + "'";
		executeQuery(sql);
		if (rs.next()) {
			sql = "update financial_order set order_state= " + fstate + " where order_code ='" + order.getOrderid()
					+ "'";
			executeUpdate(sql);
		} else {
			if (fstate == 0) {
				sql = "insert into financial_order(order_code,order_state,creater,create_time,create_timei,adjust_amounts,adjust_profit,received_amount,received_state,audit_state ) values('"
						+ order.getOrderid()
						+ "',"
						+ fstate
						+ ",'"
						+ order.getOrderid().substring(2, 5)
						+ "','"
						+ Utils.getNowTimestamp() + "'," + Utils.getSystemMillis() + ",0," + profit + ",0,0,-1)";
				executeUpdate(sql);
			}
		}
		Thread.sleep(100);
	}
	
}
