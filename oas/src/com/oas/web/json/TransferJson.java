package com.oas.web.json;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import net.sf.json.JSONArray;

import org.apache.log4j.Logger;

import com.oas.common.Config;
import com.oas.common.DBCache;
import com.oas.common.DataSourceAction;
import com.oas.common.Helper;
import com.oas.common.Utils;
import com.oas.objects.Customer;
import com.oas.objects.Order;
import com.oas.objects.OrderOffset;
import com.oas.objects.Query;
import com.oas.objects.Transfer;
import com.oas.util.StringUtil;

public class TransferJson extends DataSourceAction {
	private static final long serialVersionUID = -5612721889737285900L;
	protected final Logger log = Logger.getLogger(getClass());

	private Query query;
	
	private Transfer transfer;
	
	private Customer customer;
	
	private Order order;
	
	private OrderOffset orderOffset;
	
	public Query getQuery() {
		return query;
	}
	
	public void setQuery(Query query) {
		this.query = query;
	}

	public Transfer getTransfer() {
		return transfer;
	}
	
	public void setTransfer(Transfer transfer) {
		this.transfer = transfer;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	public Order getOrder() {
		return order;
	}

	public void setOrder(Order order) {
		this.order = order;
	}

	public OrderOffset getOrderOffset() {
		return orderOffset;
	}

	public void setOrderOffset(OrderOffset orderOffset) {
		this.orderOffset = orderOffset;
	}

	public String execute() throws Exception {
		try {
			if (action != null) {
//				String usertype = (String) getSession().getAttribute(Config.USER_TYPE);
				String userid = (String) getSession().getAttribute(Config.USER_ID);
				String workno = (String) getSession().getAttribute(Config.USER_WORKNO);
				skip = SUCCESS;
				if ("add".equals(action)) {
					transfer.setTransferId(DBCache.getSequence());
					sql = "insert into customer_transfer" +
							"(transfer_id,customer_id,transfer_account" +
							",transfer_amount,remark,transfer_type,transfer_state,creater" +
							",create_time,create_timei) values("
							+ transfer.getTransferId()
							+ ",'"
							+ transfer.getCustomerId()
							+ "','"
							+ transfer.getTransferAccount()
							+ "',"
							+ transfer.getTransferAmount()
							+ ",'"
							+ transfer.getRemark()
							+ "',"
							+ transfer.getTransferType()
							+ ",0,'"
							+ workno
							+ "',"
							+"'"+Utils.getNowTimestamp()+ "',"+Utils.getSystemMillis()+")";
//					System.out.println(sql);
					executeUpdate(sql);
//					String[] orderCodes = transfer.getOrderCodes().split(",");
//					addRela(transfer.getTransferId(), orderCodes);
				} else if ("delete".equals(action)) {
					String[] transferIds = transfer.getTransferIds().split(",");
					for(String transferId : transferIds){
						sql = "delete from customer_transfer where transfer_id = " + transferId + "";
						executeUpdate(sql);
//						deleteRela(Long.parseLong(transferId));
					}
					
				}  else if ("cancel".equals(action)) {
					String[] transferIds = transfer.getTransferIds().split(",");
					for(String transferId : transferIds){
						
						log.debug("进行转账单:"+transferId+"的作废操作");
						sql = "select ct.customer_id,ct.transfer_amount,ct.usable_amount,ct.transfer_type from customer_transfer ct where ct.transfer_id = "+transferId+"";
						log.debug(sql);
						executeQuery(sql);
						if (rs.next()) {
							String cid = rs.getString("customer_id");
							Float transferAmount = rs.getFloat("transfer_amount");
							Float usableAmount = rs.getFloat("usable_amount");
							Float offsetAmount = 0f;
							int transferType = rs.getInt("transfer_type");
							Float residualValueChange = 0f;
							Float paidAmountChange = 0f;
							List<String[]> financialOrderCodes = new ArrayList<String[]>();
							log.debug("首先查询转账单的关联冲账情况");
							sql = "select o.offset_id,o.customer_id,o.offset_financial_amounts_all,tfor.financial_order_code,tfor.offset_financial_amounts " +
									" from offset o ,transfer_financial_order_rela tfor " +
									" where o.offset_id = tfor.offset_id and o.offset_state = 0 " +
									" and o.transfer_id = "+transferId+"";
							log.debug(sql);
							executeQuery(sql);
							while (rs.next()) {
								String offsetId = rs.getString("offset_id");
								String customerId = rs.getString("customer_id");
								String financialOrderCode = rs.getString("financial_order_code");
								Float offsetFinancialAmounts = rs.getFloat("offset_financial_amounts");
								Float offsetFinancialAmountsAll = rs.getFloat("offset_financial_amounts_all");
								offsetAmount += offsetFinancialAmounts;
								String[] map = new String[2];
								map[0] = financialOrderCode;
								map[1] = String.valueOf(offsetFinancialAmounts);
								financialOrderCodes.add(map);
								System.out.println("offsetAmount>>"+offsetAmount);
								
								//作废冲账单
								sql = "update offset set offset_state = 1 where offset_id = "+offsetId+"";
								executeUpdate(sql);
							}
							for(String[] f : financialOrderCodes){
								
								String financialOrderCode = f[0];
								Float offsetFinancialAmounts = Float.parseFloat(f[1]);
								sql = "select oi.recmoney,fo.received_amount,fo.received_state " +
								" from financial_order fo,orderinfo oi " +
								" where fo.order_code = oi.orderid and financial_order_code = "+financialOrderCode+" ";
								log.debug(sql);
								executeQuery(sql);
								while (rs.next()) {
									int receivedState = rs.getInt("received_state");
									Float recmoney = rs.getFloat("recmoney");
									Float receivedAmount = rs.getFloat("received_amount");
									if(receivedAmount!=0){
										Float rAmount = receivedAmount - offsetFinancialAmounts;
										if(rAmount==0){
											if(recmoney!=0){
												receivedState = 0;
											}
											
										}else{
											receivedState = 2;
										}
										sql = "update financial_order set received_amount = "+rAmount+",received_state = "+receivedState+" where financial_order_code = "+financialOrderCode+" ";
										executeUpdate(sql);
									}
									
								}
							}
							
							System.out.println("offsetAmount all>>"+offsetAmount);
							
							residualValueChange += offsetAmount;
							paidAmountChange += offsetAmount;
							if(transferType==3){
								residualValueChange = residualValueChange - transferAmount;
								paidAmountChange = paidAmountChange - transferAmount;
							}
							
							//作废转账表
							sql = "update customer_transfer set state = 1 where transfer_id = " + transferId + "";
							log.debug(sql);
							executeUpdate(sql);
							sql = "insert into customer_amount_logs (customer_id,rela_id" +
							",type,residualValueOld,residualValueNew,paid_amount_old" +
							",paid_amount_new,lasttime,lasttimei,cmnt) " +
							"select c.customerID,'"+transferId+"'" +
							",6,c.residualValue,c.residualValue + ("+residualValueChange+")" +
							",c.paid_amount,c.paid_amount - ("+paidAmountChange+"),'"+Utils.getNowTimestamp()+ "',"+Utils.getSystemMillis()+",'作废转账金额："+offsetAmount+"' " +
							"FROM customer c WHERE c.customerID = '"+cid+"' ";
							log.debug(sql);
							executeUpdate(sql);
							sql = "UPDATE customer c set c.residualValue = c.residualValue  + ("+residualValueChange+"),c.paid_amount = c.paid_amount - ("+paidAmountChange+") where c.customerID  = '" + cid + "'";
							log.debug(sql);
							executeUpdate(sql);
						}
						
					}
					
				} else if ("change".equals(action)) {
					sql = "update customer_transfer set customer_id='"+transfer.getCustomerId()+"',transfer_account='" + transfer.getTransferAccount() + "'"
							+ ",transfer_amount="
							+ transfer.getTransferAmount() + ",transfer_type="
							+ transfer.getTransferType() + ",remark='"
							+ transfer.getRemark() +"',last_user='"
							+ workno +"',last_operate_time='"
							+ Utils.getNowTimestamp()+ "',last_operate_timei='"
							+ Utils.getSystemMillis()+"'"
							+ " where transfer_id = "+transfer.getTransferId();
//					log.debug(sql);
					executeUpdate(sql);
//					sql = "delete from transfer_financial_order_rela where transfer_id = " + transfer.getTransferId() + "";
//					executeUpdate(sql);
//					String[] orderCodes = transfer.getOrderCodes().split(",");
//					addRela(transfer.getTransferId(), orderCodes);
				} else if ("display".equals(action)) {
					sql = "SELECT ct.transfer_id,ct.customer_id,ct.transfer_account" +
							",ct.transfer_amount,ct.remark,ct.transfer_state,ct.transfer_type" +
//							",Group_concat(tfor.financial_order_code SEPARATOR ',') orderCodes" +
							",c.company,c.name,c.phone,c.QQ,c.residualValue,c.paid_amount,c.salesman" +
							" FROM customer_transfer ct" +
							" LEFT JOIN transfer_financial_order_rela tfor on ct.transfer_id = tfor.transfer_id" +
							" left join (select c1.*,u3.name salesman from customer c1,user u3 where c1.operator = u3.workcardno) c on c.customerID = ct.customer_id" +
							" where 1=1" +
							" and ct.transfer_id = "+ transfer.getTransferId() + "";
					executeQuery(sql);
					if (rs.next()) {
						transfer.setTransferId(rs.getLong("transfer_id"));
						transfer.setCustomerId(rs.getString("customer_id"));
						transfer.setTransferAccount(rs.getString("transfer_account"));
						transfer.setTransferAmount(rs.getFloat("transfer_amount"));
						transfer.setRemark(rs.getString("remark"));
						transfer.setTransferState(rs.getInt("transfer_state"));
						transfer.setTransferType(rs.getInt("transfer_type"));
//						transfer.setOrderCodes(rs.getString("orderCodes"));
						Customer c = new Customer();
						c.setCompany(rs.getString("company"));
						c.setName(rs.getString("name"));
						c.setQq(rs.getString("QQ"));
						c.setPhone(rs.getString("phone"));
						c.setResidualValue(rs.getFloat("residualValue"));
						c.setPaidAmount(rs.getFloat("paid_amount"));
						c.setOperator(rs.getString("salesman"));
						this.customer = c;
						skip = EDIT;
					} else {
						skip = ERROR;
						addActionError("Reason:  " + transfer.getTransferId() + " not exists");
					}
//					sql = "SELECT sum(o.recmoney) as recmoney" +
//					" FROM financial_order fo" +
//					" inner join orderinfo o on fo.order_code = o.orderid" +
//					" where 1=1" +
//					" and fo.financial_order_code in ("+ transfer.getOrderCodes() +")";
//					executeQuery(sql);
//					if (rs.next()) {
//						transfer.setRecmoneys(rs.getFloat("recmoney"));
//						skip = EDIT;
//					} else {
//						skip = ERROR;
//					}
				}else if ("offsetDisplay".equals(action)) {
					sql = "SELECT ct.transfer_id,ct.customer_id,ct.transfer_account" +
					",ct.transfer_amount,ct.usable_amount,ct.remark,ct.transfer_state,ct.transfer_type" +
//					",Group_concat(tfor.financial_order_code SEPARATOR ',') orderCodes" +
					",c.company,c.name,c.phone,c.QQ,c.residualValue,c.paid_amount,c.salesman" +
					" FROM customer_transfer ct" +
					" LEFT JOIN transfer_financial_order_rela tfor on ct.transfer_id = tfor.transfer_id" +
					" left join (select c1.*,u3.name salesman from customer c1,user u3 where c1.operator = u3.workcardno) c on c.customerID = ct.customer_id" +
					" where 1=1" +
					" and ct.transfer_id = "+ transfer.getTransferId() + "";
																																																																			executeQuery(sql);
					if (rs.next()) {
						transfer.setTransferId(rs.getLong("transfer_id"));
						transfer.setCustomerId(rs.getString("customer_id"));
						transfer.setTransferAccount(rs.getString("transfer_account"));
						transfer.setTransferAmount(rs.getFloat("transfer_amount"));
						transfer.setUsableAmount(rs.getFloat("usable_amount"));
						transfer.setRemark(rs.getString("remark"));
						transfer.setTransferState(rs.getInt("transfer_state"));
						transfer.setTransferType(rs.getInt("transfer_type"));
		//				transfer.setOrderCodes(rs.getString("orderCodes"));
						Customer c = new Customer();
						c.setCompany(rs.getString("company"));
						c.setName(rs.getString("name"));
						c.setQq(rs.getString("QQ"));
						c.setPhone(rs.getString("phone"));
						c.setResidualValue(rs.getFloat("residualValue"));
						c.setPaidAmount(rs.getFloat("paid_amount"));
						c.setOperator(rs.getString("salesman"));
						this.customer = c;
						skip = EDIT1;
					} else {
						skip = ERROR;
						addActionError("Reason:  " + transfer.getTransferId() + " not exists");
					}						
				}else if ("carryOver".equals(action)) {
					//INSERT
					String sql3 = "insert into customer_transfer" +
							"(transfer_id,customer_id,transfer_account" +
							",transfer_amount,remark,transfer_type,transfer_state,creater" +
							",create_time,create_timei) select "+DBCache.getSequence()+",ct.customer_id,'余款结转',-ct.usable_amount,'余款结转',1,2,ct.creater,'"+Utils.getNowTimestamp()+ "',"+Utils.getSystemMillis()+"  from customer_transfer ct where ct.transfer_id = "+transfer.getTransferId()+"";				

					executeUpdate(sql3);
					//UPDATE
					String sql1 = "update customer_transfer set usable_amount = 0,usable_state = 1 where transfer_id = "+transfer.getTransferId()+" ";
					executeUpdate(sql1);
					
//					String sql2 = "insert into customer_amount_logs (customer_id,rela_id" +
//					",type,residualValueOld,residualValueNew,paid_amount_old" +
//					",paid_amount_new,lasttime,lasttimei,cmnt) " +
//					"select c.customerID,'"+orderOffset.getTransferId()+"'" +
//					",7,c.residualValue,"+customer.getResidualValue()+"" +
//					",c.paid_amount,"+customer.getPaidAmount()+",'"+Utils.getNowTimestamp()+ "',"+Utils.getSystemMillis()+",'冲账' " +
//					"FROM customer c WHERE c.customerID = '"+transfer.getCustomerId()+"' ";
//					executeUpdate(sql2);
					
					
							
//					log.debug(sql);
//					skip = SUCCESS;
				}else if ("offset".equals(action)) {
					log.debug("offset transfer_id:"+orderOffset.getTransferId()+" and financial_order_codes:"+orderOffset.getFinancialOrderCodes());
					log.info("offset transfer_id:"+orderOffset.getTransferId()+" and financial_order_codes:"+orderOffset.getFinancialOrderCodes());
					boolean isExists = false;
					String sql1 = "select * from offset where transfer_id= "+orderOffset.getTransferId()+" and financial_order_codes = '"+orderOffset.getFinancialOrderCodes()+"' ";
					executeQuery(sql1);
					if (rs.next()) {
						isExists = true;
					}
					if(isExists){
						skip = ERROR;
						addActionError("Reason:  " + orderOffset.getTransferId() + " and "+orderOffset.getFinancialOrderCodes()+" 's offset is exists");
					}else{
						orderOffset.setOffsetId(DBCache.getSequence());
						orderOffset.setCreater(workno);
//						Float offsetAmounts= saveRelaFinancial(orderOffset.getOffsetId(),orderOffset.getCustomerId(),orderOffset.getTransferId(), orderOffset.getFinancialOrderCodes(), orderOffset.getOffsetTransferAmounts());
						String sql2 = "insert into offset" +
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
								+ orderOffset.getOffsetAmounts()
								+ ","
								+ orderOffset.getBalance()
								+ ",0,'"
								+ orderOffset.getCreater()
								+ "',"
								+"'"+Utils.getNowTimestamp()+ "',"+Utils.getSystemMillis()+")";
						executeUpdate(sql2);
						String usableState = "0";
						if(orderOffset.getBalance()==0){
							usableState = "1";
						}
						String sql3 = "update customer_transfer ct set ct.usable_amount="+orderOffset.getBalance()+",ct.usable_state ="+usableState+" where ct.transfer_id = "+orderOffset.getTransferId()+" ";
						executeUpdate(sql3);
						sql = "insert into customer_amount_logs (customer_id,rela_id" +
						",type,residualValueOld,residualValueNew,paid_amount_old" +
						",paid_amount_new,lasttime,lasttimei,cmnt) " +
						"select c.customerID,'"+orderOffset.getTransferId()+"'" +
						",7,c.residualValue,"+customer.getResidualValue()+"" +
						",c.paid_amount,"+customer.getPaidAmount()+",'"+Utils.getNowTimestamp()+ "',"+Utils.getSystemMillis()+",'冲账' " +
						"FROM customer c WHERE c.customerID = '"+orderOffset.getCustomerId()+"' ";
						executeUpdate(sql);
						String sql4 = "update customer c set c.residualValue="+customer.getResidualValue()+",c.paid_amount ="+customer.getPaidAmount()+" where c.customerID = "+orderOffset.getCustomerId()+" ";
						executeUpdate(sql4);
						String relaStr = orderOffset.getOffsetListStr();
						JSONArray jsonArray = JSONArray.fromObject(relaStr);  
						  
				        List<Map<String,Object>> mapListJson = (List)jsonArray;
				        for (int i = 0; i < mapListJson.size(); i++) {  
				            Map<String,Object> obj=mapListJson.get(i);  
				              
//				            for(Entry<String,Object> entry : obj.entrySet()){  
//				                String strkey1 = entry.getKey();  
//				                Object strval1 = entry.getValue();  
//				                log.debug("KEY:"+strkey1+"  -->  Value:"+strval1+"\n");  
//				            } 
				            String sql5 = "update financial_order fo set fo.received_amount="+obj.get("receivedAmount").toString()+",fo.received_state ="+obj.get("receiveState").toString()+" where fo.financial_order_code = "+obj.get("financialOrderCode").toString()+" ";
//							log.debug(sql5);
				            executeUpdate(sql5);
							String sql6 = "insert into transfer_financial_order_rela (offset_id,transfer_id,financial_order_code,offset_financial_amounts)" +
									" values ("+orderOffset.getOffsetId()+","+orderOffset.getTransferId()+","+obj.get("financialOrderCode").toString()+","+obj.get("offsetAmount").toString()+") ";
//							log.debug(sql6);
							executeUpdate(sql6);
				        }  
						skip = SUCCESS;
					}
					
				}else if ("view".equals(action)) {
					sql = "SELECT ct.transfer_id,ct.customer_id,ct.transfer_account" +
					",ct.transfer_amount,ct.remark,ct.transfer_state,ct.transfer_type" +
//					",Group_concat(tfor.financial_order_code SEPARATOR ',') orderCodes" +
					",c.company,c.name,c.phone,c.QQ,c.residualValue,c.paid_amount,c.salesman" +
					" from customer_transfer ct" +
					" left join transfer_financial_order_rela tfor on ct.transfer_id = tfor.transfer_id" +
					" left join (select c1.*,u3.name salesman from customer c1,user u3 where c1.operator = u3.workcardno) c on c.customerID = ct.customer_id" +
					" where 1=1" +
					" and ct.transfer_id = "+ transfer.getTransferId() + "";
					executeQuery(sql);
					if (rs.next()) {
						transfer.setTransferId(rs.getLong("transfer_id"));
						transfer.setCustomerId(rs.getString("customer_id"));
						transfer.setTransferAccount(rs.getString("transfer_account"));
						transfer.setTransferAmount(rs.getFloat("transfer_amount"));
						transfer.setRemark(rs.getString("remark"));
						transfer.setTransferState(rs.getInt("transfer_state"));
						String transferTypeName = "";
						if(rs.getInt("transfer_type")==1){
							transferTypeName = "票款";
						}else if(rs.getInt("transfer_type")==2){
							transferTypeName = "其他费用";
						}
						transfer.setTransferType(rs.getInt("transfer_type"));
						transfer.setTransferTypeName(transferTypeName);
//						transfer.setOrderCodes(rs.getString("orderCodes"));
						Customer c = new Customer();
						c.setCompany(rs.getString("company"));
						c.setName(rs.getString("name"));
						c.setQq(rs.getString("QQ"));
						c.setPhone(rs.getString("phone"));
						c.setResidualValue(rs.getFloat("residualValue"));
						c.setPaidAmount(rs.getFloat("paid_amount"));
						c.setOperator(rs.getString("salesman"));
						this.customer = c;
						skip = VIEW;
					} else {
						skip = ERROR;
						addActionError("Reason:  " + transfer.getTransferId() + " not exists");
					}
				}else if ("audit".equals(action)) {
					sql = "update customer_transfer set transfer_state=" + transfer.getTransferSubmitState() + ",last_user='"
					+ workno +"',last_operate_time='"
					+ Utils.getNowTimestamp()+ "',last_operate_timei='"
					+ Utils.getSystemMillis()+ "' "
					+ " where transfer_id in ("+transfer.getTransferIds()+")";
					executeUpdate(sql);
					if(transfer.getTransferSubmitState()==2){
						sql = "update customer_transfer c set c.usable_amount=c.transfer_amount where c.transfer_id in ("+transfer.getTransferIds()+")";
						executeUpdate(sql);
						String[] transferIds = transfer.getTransferIds().split(",");
//						log.debug(sql);
						for(String transferId : transferIds){
							Transfer t = getCustomerTransfer(transferId);
							float transferAmount = t.getTransferAmount();
							String customerId = t.getCustomerId();
							sql = "insert into customer_amount_logs (customer_id,rela_id" +
							",type,residualValueOld,residualValueNew,paid_amount_old" +
							",paid_amount_new,lasttime,lasttimei,cmnt) " +
							"select c.customerID,'"+transferId+"'" +
							",8,c.residualValue,c.residualValue+("+transferAmount+")" +
							",c.paid_amount,c.paid_amount,'"+Utils.getNowTimestamp()+ "',"+Utils.getSystemMillis()+",'审核转账金额："+transferAmount+"' " +
							"FROM customer c WHERE c.customerID = '"+customerId+"' ";
							executeUpdate(sql);
							sql = "update customer c set c.residualValue=c.residualValue+("+transferAmount+") where c.customerID = "+customerId+" ";
//							log.debug(sql);
							executeUpdate(sql);
							
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
	
	public Transfer getCustomerTransfer(String transferId) throws Exception{
		String sqlStr = "select ct.transfer_id,ct.customer_id,ct.transfer_account,ct.transfer_amount" +
		",ct.remark,ct.transfer_state,ct.creater,ct.create_time,ct.last_user" +
		",ct.last_operate_time" +
		" from customer_transfer ct where ct.transfer_id = "+transferId+"";
		
		executeQuery(sqlStr);
		Transfer t = new Transfer();
		while (rs.next()) {
			String customerId = rs.getString("customer_id");
			Float transferAmount = rs.getFloat("transfer_amount");
			t.setCustomerId(customerId);
			t.setTransferAmount(transferAmount);
		}
		return t;
		
	}
	
	public void queryList() throws Exception{
		term = Helper.getQuerySqlNull(query, "ct.create_timei");

		skip = JSON;
		String sqlStr = "select ct.transfer_id,ct.customer_id,ct.transfer_account,ct.transfer_amount" +
				",ct.remark,ct.transfer_type,ct.state,ct.transfer_state,ct.usable_amount,ct.usable_state,ct.creater,ct.create_time,ct.last_user" +
				",ct.last_operate_time,u1.name userName,u2.name luserName,c.name,c.company,c.salesman" +
//				",case Group_concat(tfor.financial_order_code SEPARATOR ',') when '' then null else Group_concat(tfor.financial_order_code SEPARATOR ',') end  as orderCodes" +
				" from customer_transfer ct" +
//				" left join transfer_financial_order_rela tfor on ct.transfer_id = tfor.transfer_id" +
				" left join user u1 on ct.creater = u1.workcardno" +
				" left join user u2 on ct.last_user = u2.workcardno" +
				" left join (select c1.*,u3.name salesman from customer c1,user u3 where c1.operator = u3.workcardno) c on c.customerID = ct.customer_id" +
				" where 1=1 " + term;
		if(transfer!=null){
			if(transfer.getTransferState()!=null&&transfer.getTransferState()!=99){
				sqlStr += " and ct.transfer_state ="+transfer.getTransferState()+"";
			}
			if(transfer.getUsableState()!=null&&transfer.getUsableState()!=99){
				sqlStr += " and ct.usable_state ="+transfer.getUsableState()+"";
			}
			if(!"".equals(transfer.getCustomerId())&&transfer.getCustomerId()!=null){
				sqlStr += " and ct.customer_id ='"+transfer.getCustomerId()+"'";
			}
			if(transfer.getState()!=null&&transfer.getState()!=99){
				sqlStr += " and ct.state ="+transfer.getState()+"";
			}
			if(transfer.getTransferAmount()!=null&&transfer.getTransferAmount()!=9999999999f){
				sqlStr += " and ct.transfer_amount ="+transfer.getTransferAmount()+"";
			}
		}
		
		if(order!=null&&(order.getPnr()!=null||order.getOrderid()!=null)){
			sqlStr += " and exists (select 1 from orderinfo o,transfer_financial_order_rela tfor,financial_order fo where 1=1 and o.orderid = fo.order_code and tfor.financial_order_code = fo.financial_order_code ";
			if(!"".equals(order.getPnr())&&order.getPnr()!=null){
				String pnr = URLDecoder.decode(order.getPnr().trim(),"UTF-8");
				sqlStr += " and o.pnr like '%"+pnr+"%'";
			}
			if(!"".equals(order.getOrderid())&&order.getOrderid()!=null){
				sqlStr += " and o.orderid ='"+order.getOrderid()+"'";
			}
			if(order.getType()!=99){
				sqlStr += " and o.type ="+order.getType()+"";
			}
			sqlStr +=")";
		}
		if(customer!=null&&(customer.getCustomerID()!=null||customer.getName()!=null||customer.getPhone()!=null||customer.getQq()!=null||customer.getCompany()!=null)){
			sqlStr += " and exists (select 1 from customer c where 1=1 and c.customerID = ct.customer_id ";
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
		sqlStr += " order by ct.transfer_id desc";
		System.out.println(sqlStr);
		log.debug(sqlStr);
		executeQuery(sqlStr);
		while (rs.next()) {
			Long transferId = rs.getLong("transfer_id");
			String customerId = rs.getString("customer_id");
			Float transferAmount = rs.getFloat("transfer_amount");
			Float usableAmount = rs.getFloat("usable_amount");
			amount += transferAmount;
			String transferAccount = rs.getString("transfer_account");
			String remark = rs.getString("remark");
			int transferType = rs.getInt("transfer_type");
			int transferState = rs.getInt("transfer_state");
			int usableState = rs.getInt("usable_state");
			int state = rs.getInt("state");
			String orderCodes = "";
			String salesman = rs.getString("salesman");
			String customerName = rs.getString("name");
			String company = rs.getString("company");
			String creater = StringUtil.toString(rs.getString("creater"));
			String operator = StringUtil.toString(rs.getString("last_user"));
			String userName = StringUtil.toString(rs.getString("userName"));
			String luserName = StringUtil.toString(rs.getString("luserName"));
			String createTime = StringUtil.toString(rs.getDate("create_time"))+" "+StringUtil.toString(rs.getTime("create_time"));
			String updateTime = StringUtil.toString(rs.getDate("last_operate_time"))+" "+StringUtil.toString(rs.getTime("last_operate_time"));
			if (count != 0)
				bf.append(",");
			bf.append("{'transferId':'" + transferId + "'")
			  .append(",'customerId':'" + customerId + "'")
			  .append(",'transferAmount':'" + transferAmount + "'")
			  .append(",'usableAmount':'" + usableAmount + "'")
			  .append(",'transferType':'" + transferType + "'")
			  .append(",'transferAccount':'" + transferAccount + "'")
			  .append(",'customerName':'" + customerName + "'")
			  .append(",'company':'" + company + "'")
			  .append(",'remark':'" + remark + "'")
			  .append(",'orderCodes':'" + orderCodes + "'")
			  .append(",'transferState':'" + transferState + "'")
			  .append(",'usableState':'" + usableState + "'")
			  .append(",'state':'" + state + "'")
			  .append(",'salesman':'" + salesman + "'")
			  .append(",'luserName':'" + luserName + "'")
			  .append(",'userName':'" + userName + "'")
			  .append(",'creater':'" + creater + "'")
			  .append(",'createTime':'" + createTime + "'")
			  .append(",'operator':'" + operator + "'")
			  .append(",'updateTime':'" + updateTime + "'}");
			count++;
		}
		String counts = "总数：" + count+" ,总转账金额："+String.format("%.2f", amount);
		tojsonNew(counts);
	}
	
	private void deleteRela(Long transferIds){
		sql = "delete from transfer_financial_order_rela where transfer_id = " + transferIds + " ";
		executeUpdate(sql);
	}
	
	private void addRela(Long transferId,String[] orderCodes){
		for(int i=0;i<orderCodes.length;i++){
			sql = sql = "insert into transfer_financial_order_rela" +
			"(transfer_id,financial_order_code) values("
			+ transferId
			+ ","
			+ orderCodes[i]
			+ ")";
			executeUpdate(sql);
			updateFinancialOrder(orderCodes[i], "0");
		}
	}
	
	private void updateFinancialOrder(String financialOrderCode,String auditState){
		sql = sql = "update financial_order set audit_state = "+auditState+" where financial_order_code = "+financialOrderCode+"";
		executeUpdate(sql);
	}
	
	public Float saveRelaFinancial(Long offsetId,String cid,Long transferId,String financialOrderCodes,Float transferAmounts) throws Exception{
		Float transferAmountsOld = transferAmounts;
		String sql3 = "select fo.financial_order_code,fo.received_amount,fo.received_state,oi.recmoney " +
				" from financial_order fo inner join orderinfo oi on fo.order_code = oi.orderid " +
				" where fo.financial_order_code in ("+financialOrderCodes+") ";
		
		executeQuery(sql3);
		while (rs.next()) {
			Long financialOrderCode = rs.getLong("financial_order_code");
			int receiveOldState = rs.getInt("received_state");
			Float receivedAmounts = rs.getFloat("received_amount");
			Float recmoney = rs.getFloat("recmoney");
			if(receiveOldState==1){
				continue;
			}
			Float money = recmoney - receivedAmounts;
			Float offsetAmounts = 0f;
			int receiveState = receiveOldState;
			if(receiveOldState==0){
				if(transferAmounts>=recmoney){
					offsetAmounts = recmoney;
					receiveState = 1;
				}else{
					if(transferAmounts!=0){
						offsetAmounts = transferAmounts;
						receiveState = 2;
					}
				}
				
			}else if(receiveOldState==2){
				if(transferAmounts>=money){
					offsetAmounts = money;
					receiveState = 1;
				}else{
					if(transferAmounts!=0){
						offsetAmounts = transferAmounts;
						receiveState = 2;
					}
				}
			}
			String sql4 = "update financial_order fo set fo.received_amount=fo.received_amount+("+offsetAmounts+"),fo.received_state ="+receiveState+" where fo.financial_order_code = "+financialOrderCode+" ";
			executeUpdate(sql4);
			String sql5 = "insert into transfer_financial_order_rela (offset_id,transfer_id,financial_order_code,offset_financial_amounts)" +
					" values ("+offsetId+","+transferId+","+financialOrderCode+","+offsetAmounts+") ";
			executeUpdate(sql5);
			transferAmounts = transferAmounts - offsetAmounts;
			
		}
		Float transferAmountsNew = transferAmounts;
		int usableState = 0;
		if(transferAmountsNew==0){//用完
			usableState = 1;
		}
		String sql6 = "update customer_transfer ct set ct.usable_amount="+transferAmountsNew+",ct.usable_state ="+usableState+" where ct.transfer_id = "+transferId+" ";
		executeUpdate(sql6);
		Float transferAmountsForUse = transferAmountsOld - transferAmountsNew;
		String sql7 = "update customer c set c.residualValue=c.residualValue-("+transferAmountsForUse+"),c.paid_amount =c.paid_amount+("+transferAmountsForUse+") where c.customerID = "+cid+" ";
		executeUpdate(sql7);
		return transferAmountsForUse;
	}
}
