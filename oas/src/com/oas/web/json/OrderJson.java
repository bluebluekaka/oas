package com.oas.web.json;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import com.oas.common.Config;
import com.oas.common.DataSourceAction;
import com.oas.common.Helper;
import com.oas.common.Utils;
import com.oas.objects.Order;
import com.oas.objects.Product;
import com.oas.objects.Query;
import com.oas.objects.Traveller;

public class OrderJson extends DataSourceAction {
	private static final long serialVersionUID = -5612722289737285900L;

	private Query query;
	private Order order;
	private String sid;
	private String clientid;
	private String pnr;
	private String type;
	private String state;
	private String loads;
	private String edit;
	private String cname;
	private String piao;
	private String maker;
	private String offer;
	private String offerdata;

	public String getOfferdata() {
		return offerdata;
	}

	public void setOfferdata(String offerdata) {
		this.offerdata = offerdata;
	}

	public String getOffer() {
		return offer;
	}

	public void setOffer(String offer) {
		this.offer = offer;
	}

	public String getMaker() {
		return maker;
	}

	public void setMaker(String maker) {
		this.maker = maker;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getCname() {
		return cname;
	}

	public void setCname(String cname) {
		this.cname = cname;
	}

	public String getPiao() {
		return piao;
	}

	public void setPiao(String piao) {
		this.piao = piao;
	}

	public String getEdit() {
		return edit;
	}

	public void setEdit(String edit) {
		this.edit = edit;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getClientid() {
		return clientid;
	}

	public void setClientid(String clientid) {
		this.clientid = clientid;
	}

	public String getPnr() {
		return pnr;
	}

	public void setPnr(String pnr) {
		this.pnr = pnr;
	}

	public String getLoads() {
		return loads;
	}

	public void setLoads(String loads) {
		this.loads = loads;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public Order getOrder() {
		return order;
	}

	public void setOrder(Order order) {
		this.order = order;
	}

	public Query getQuery() {
		return query;
	}

	public void setQuery(Query query) {
		this.query = query;
	}

	public synchronized String execute() throws Exception {

		String usertype = (String) getSession().getAttribute(Config.USER_TYPE);
		String carno = (String) getSession().getAttribute(Config.USER_WORKNO);
		if (Utils.isNull(carno)) {
			addActionMessage("登陆超时，请从新登陆");
			return ERROR;
		}
		if (!Utils.isNull(loads)) {
			if (!Utils.isNull(order.getClientid())) {
				sql = "select name,telephone,QQ,residualValue,company,paid_amount from customer where customerid = '"
						+ order.getClientid() + "'";
				executeQuery(sql);
				if (rs.next()) {
					order.setCustname(rs.getString(1));
					order.setCustphone(rs.getString(2));
					order.setCustqq(rs.getString(3));
					order.setCustmoney(rs.getString(4));
					order.setCustcompany(rs.getString(5));
					order.setCustpiadmoney(rs.getString(6));
				}
			}
			loadTxt();
			if (!Utils.isNull(order.getPnr())) {
				sql = "select orderid from orderinfo where pnr = '" + order.getPnr() + "' and type=" + order.getType()
						+ " and state <> " + Config.ORDER_STATE_CANCLE + " order by id desc";
				executeQuery(sql);
				if (rs.next()) {
					if (!rs.getString(1).equals(order.getOrderid())) {
						addActionMessage("导入失败，要导入的PNR码获取为：" + order.getPnr() + " 若该值不是真正的pnr码，请按照主页面的6种订单格式检查要导入的订单格式，注："
								+ Helper.getOrderType(order.getType()) + "PNR:" + order.getPnr() + " 已经存在,请查看订单编号:"
								+ rs.getString(1));
						return ERROR;
					}
				}
			}
			sql = "select username,lasttime,cmnt from ordercmnt where orderid='" + order.getOrderid() + "'";
			int p = 0;
			StringBuffer bc = new StringBuffer();
			executeQuery(sql);
			while (rs.next()) {
				if (p > 0)
					bc.append(",");
				bc.append("{'cdate':'" + rs.getDate(2)).append(
						"','ctime':'" + rs.getTime(2) + "','cname':'" + rs.getString(1) + "','ccmnt':'"
								+ rs.getString(3) + "'}");
				p++;
			}
			order.setCmntdata(bc.toString());
			if (p == 0)
				order.setCmntdata("{'cdate':'无历史备注'}");
			order.setLdata(getLogsdata(order.getOrderid()));
			if (order.getState() != Config.ORDER_STATE_CREATE)
				action = "change";
			else
				action = "save";
			skip = EDIT;
		} else {
			setOfferData();
			if ("add".equals(action)) {
				if (order == null) {
					order = new Order();
					order.setOrderid("JP" + getOrderID(carno));
					order.setCdata("{'name':'New','type':'1','recmoney':'0.00','paymoney':'0.00','pnum':' ','supplier':' ','HideID':' '}");
					order.setPdata("{'carrier':'New','flight':' ','position':' ','trip':' ','sdate':' ','stime':' ','edate':' ','etime':' ','HideID':' '}");
					order.setCmntdata("{'cdate':'无历史备注'}");
					order.setLdata("{'ldate':'无历史超作'}");
				}
				action = "save";
				skip = EDIT;
			} else if ("display".equals(action) || "lorder".equals(action)) {
				sql = "select orderid,state,type,producttype,productname,cid,pnr,createtime,offercompany from orderinfo where orderid = '"
						+ sid + "'";
				executeQuery(sql);
				int cdate = 0;
				order = new Order();
				if (rs.next()) {
					order.setOrderid(rs.getString(1));
					order.setState(rs.getInt(2));
					order.setType(rs.getInt(3));
					order.setProducttype(rs.getInt(4));
					order.setProductname(rs.getString(5));
					order.setClientid(rs.getString(6));
					order.setPnr(rs.getString(7));
					cdate = Integer.valueOf((rs.getDate(8) + "").replaceAll("-", ""));//创建时间 20130802
					order.setOffer(rs.getString(9));
				}
				int nowdate = Utils.getNowDateInt();//当前时间 20130802
				boolean update = false;
				if (nowdate - cdate == 0) {
					update = true;
				}

				if (Utils.isNull(edit) && !"lorder".equals(action)) {
					if (Integer.valueOf(usertype) == Config.USER_TYPE_COMMON
							&& (order.getState() != Config.ORDER_STATE_CREATE
									&& order.getState() != Config.ORDER_STATE_ALLOW_COMMON_MANAGER
									&& order.getState() != Config.ORDER_STATE_DISALLOW_COMMON_MANAGER && order
									.getState() != Config.ORDER_STATE_DISALLOW_FINANCE)) {
						addActionMessage("对不起，此订单的状态为：" + Helper.getOrterState1(order.getState()) + " 状态，您的权限不能修改或审核。");
						return ERROR;
					} else if (Integer.valueOf(usertype) == Config.USER_TYPE_COMMON_MANERGER
							&& order.getState() != Config.ORDER_STATE_CREATE
							&& order.getState() != Config.ORDER_STATE_ALLOW_COMMON_MANAGER
							&& order.getState() != Config.ORDER_STATE_DISALLOW_COMMON_MANAGER
							&& order.getState() != Config.ORDER_STATE_WAIT_COMMON_MANAGER
							&& order.getState() != Config.ORDER_STATE_DISALLOW_FINANCE) {
						if (order.getState() == Config.ORDER_STATE_WAIT_FINANCE) {
							if (update == false) {
								addActionMessage("对不起，此订单的创建时间已经超过期限，您的权限不能修改或审核。");
								return ERROR;
							}
						} else {
							addActionMessage("对不起，此订单的状态为：" + Helper.getOrterState1(order.getState())
									+ " 状态，您的权限不能修改或审核。");
							return ERROR;
						}
					} else if (Integer.valueOf(usertype) == Config.USER_TYPE_FINANCE
							&& order.getState() != Config.ORDER_STATE_DISALLOW_FINANCE_MANAGER
							&& order.getState() != Config.ORDER_STATE_WAIT_FINANCE) {
						addActionMessage("对不起，此订单的状态为：" + Helper.getOrterState1(order.getState()) + " 状态，您的权限不能修改或审核。");
						return ERROR;
					} else if (Integer.valueOf(usertype) == Config.USER_TYPE_FINANCE_MANERGER
							&& order.getState() != Config.ORDER_STATE_WAIT_FINANCE_MANAGER) {
						addActionMessage("对不起，此订单的状态为：" + Helper.getOrterState1(order.getState()) + " 状态，您的权限不能修改或审核。");
						return ERROR;
					} else if (Integer.valueOf(usertype) == Config.USER_TYPE_FINANCE_MANERGER && update == true) {
						addActionMessage("对不起，此订单未到财务审核时间。");
						return ERROR;
					}
					skip = EDIT;
				} else {
					skip = "DISPLAY";
				}

				sql = "select customerID,name,telephone,qq,residualValue,company,paid_amount from Customer where customerID='"
						+ order.getClientid() + "'";
				executeQuery(sql);
				if (rs.next()) {
					order.setCustname(rs.getString(2));
					order.setCustphone(rs.getString(3));
					order.setCustqq(rs.getString(4));
					order.setCustmoney(rs.getString(5));
					order.setCustcompany(rs.getString(6));
					order.setCustpiadmoney(rs.getString(7));
				} else
					order.setClientid("无此客户信息");

				sql = "select carrier,flight,position,trip,sdate,stime,edate,etime,id from orderproduct where orderid='"
						+ order.getOrderid() + "'";
				int p = 0;
				StringBuffer bc = new StringBuffer();
				executeQuery(sql);
				while (rs.next()) {
					if (p > 0)
						bc.append(",");
					bc.append("{'carrier':'" + rs.getString(1)).append("','flight':'" + rs.getString(2))
							.append("','position':'" + rs.getString(3)).append("','trip':'" + rs.getString(4))
							.append("','sdate':'" + rs.getString(5)).append("','stime':'" + rs.getString(6))
							.append("','edate':'" + rs.getString(7)).append("','etime':'" + rs.getString(8))
							.append("','HideID':'" + rs.getString(9) + "'}");
					p++;
				}
				order.setPdata(bc.toString());
				if (p == 0)
					order.setPdata("{'carrier':'New','flight':' ','position':' ','trip':' ','sdate':' ','stime':' ','edate':' ','etime':' ','HideID':' '}");

				sql = "select name,type,recmoney,paymoney,pnum,supplier,id from ordertraveller where orderid='"
						+ order.getOrderid() + "'";
				p = 0;
				bc = new StringBuffer();
				executeQuery(sql);
				while (rs.next()) {
					if (p > 0)
						bc.append(",");
					float recmoney0 = rs.getFloat(3);
					float paymoney0 = rs.getFloat(4);
					if ("lorder".equals(action)) {
						recmoney0 = -recmoney0;
						paymoney0 = -paymoney0;
					}
					bc.append("{'name':'" + rs.getString(1))
							.append("','type':'" + rs.getInt(2) + "','recmoney':'" + Utils.getPoint(recmoney0, 2)
									+ "','paymoney':'" + Utils.getPoint(paymoney0, 2) + "','pnum':'" + rs.getString(5)
									+ "','supplier':'" + rs.getString(6))
							.append("','HideID':'" + rs.getString(7) + "'}");
					p++;
				}
				order.setCdata(bc.toString());
				if (p == 0)
					order.setCdata("{'name':'请导入或输入数据','type':'1','recmoney':'0.00','paymoney':'0.00','pnum':' ','supplier':' ','HideID':' '}");

				sql = "select username,lasttime,cmnt from ordercmnt where orderid='" + order.getOrderid() + "'";
				p = 0;
				bc = new StringBuffer();
				executeQuery(sql);
				while (rs.next()) {
					if (p > 0)
						bc.append(",");
					bc.append("{'cdate':'" + rs.getDate(2)).append(
							"','ctime':'" + rs.getTime(2) + "','cname':'" + rs.getString(1) + "','ccmnt':'"
									+ rs.getString(3) + "'}");
					p++;
				}
				order.setCmntdata(bc.toString());
				if (p == 0)
					order.setCmntdata("{'cdate':'无历史备注'}");
				order.setLdata(getLogsdata(order.getOrderid()));
				if ("lorder".equals(action)) {
					order.setOrderid("TP" + getOrderID(carno));
					order.setState(Config.ORDER_STATE_CREATE);
					order.setType(Config.ORDER_TYPE_CANCEL);
					order.setCmntdata("{'cdate':'无历史备注'}");
					order.setLdata("{'ldate':'无历史超作'}");
					action = "save";
					skip = EDIT;
				} else
					action = "change";
			} else if ("change".equals(action)) {
				if (order != null) {
					sql = "select orderid,recmoney,paymoney from orderinfo where type='" + order.getType() + "' and pnr='"
							+ order.getPnr() + "' and state <> " + Config.ORDER_STATE_CANCLE + " order by id desc";
					executeQuery(sql);
					double oldrecmoney = 0.00;
					double oldpaymoney = 0.00;
					if (rs.next()) {
						if (!rs.getString(1).equals(order.getOrderid())) {
							addActionMessage("操作失败，" + Helper.getOrderType(order.getType()) + "PNR:" + order.getPnr()
									+ " 已经存在,请查看订单编号:" + rs.getString(1));
							return ERROR;
						}else if (rs.getString(1).equals(order.getOrderid())) {
							oldrecmoney = rs.getDouble(2);
							oldpaymoney = rs.getDouble(3);
						}
					}
					
					List<Product> lsp = getSaveProduct(order.getSavepdata());
					List<Traveller> lst = getSaveTraveller(order.getSavecdata());
					double recmoney = 0.00;
					double paymoney = 0.00;
					for (int i = 0; i < lst.size(); i++) {
						Traveller tr = lst.get(i);
						if (!Utils.isNull(tr.getRecmoney()))
							recmoney += Double.valueOf(tr.getRecmoney().replaceAll(",", ""));
						if (!Utils.isNull(tr.getPaymoney()))
							paymoney += Double.valueOf(tr.getPaymoney().replaceAll(",", ""));
					}
					if(order.getState()==Config.ORDER_STATE_DISALLOW_FINANCE){
						if((recmoney==0&&oldrecmoney!=0)||(paymoney==0&&oldpaymoney!=0)){
								addActionMessage("登录超时或异常，请注销后重新登录在进行尝试。");
								return ERROR;
						}
					}
					sql = "delete from orderproduct where orderid='" + order.getOrderid() + "'";
					executeUpdate(sql);
					
					for (int i = 0; i < lsp.size(); i++) {
						Product pr = lsp.get(i);
						StringBuffer bfs = new StringBuffer();
						bfs.append(
								"insert into orderproduct(orderid,carrier,flight,position,trip,sdate,stime,edate,etime) values('")
								.append(order.getOrderid() + "','").append(pr.getCarrier() + "','")
								.append(pr.getFlight() + "','").append(pr.getPosition() + "','")
								.append(pr.getTrip() + "','").append(pr.getSdate() + "','")
								.append(pr.getStime() + "','").append(pr.getEdate() + "','")
								.append(pr.getEtime() + "')");
						sql = bfs.toString();
						executeUpdate(sql);
					}

					sql = "delete from ordertraveller where orderid='" + order.getOrderid() + "'";
					executeUpdate(sql);
					for (int i = 0; i < lst.size(); i++) {
						Traveller tr = lst.get(i);
						StringBuffer bfs = new StringBuffer();
						String dr = tr.getRecmoney().replaceAll(",", "");
						String dp = tr.getPaymoney().replaceAll(",", "");
						if (order.getState() == Config.ORDER_STATE_CANCLE) {
							dr = "0";
							dp = "0";
						}
						bfs.append(
								"insert into ordertraveller(orderid,name,type,recmoney,paymoney,pnum,supplier) values('")
								.append(order.getOrderid() + "','").append(tr.getName() + "',")
								.append(tr.getType() + ",").append(dr + ",").append(dp + ",'")
								.append(tr.getPnum() + "','").append(tr.getSupplier() + "')");
						sql = bfs.toString();
						executeUpdate(sql);
					}
					if (!Utils.isNull(order.getCmnt())) {
						String username = (String) getSession().getAttribute(Config.USER_NAME);
						sql = "insert into ordercmnt(orderid,username,lasttime,cmnt) values('" + order.getOrderid()
								+ "','" + username + "','" + Utils.getNowTimestamp() + "','" + order.getCmnt() + "')";
						executeUpdate(sql);
					}
					double profit = 0;
					if (order.getState() == Config.ORDER_STATE_WAIT_FINANCE
							|| order.getState() == Config.ORDER_STATE_END) {
						profit = recmoney - (paymoney);
						sql = "select state from orderinfo where orderid='" + order.getOrderid() + "'";
						executeQuery(sql);
						if (rs.next()) {
							if ((rs.getInt(1) != Config.ORDER_STATE_WAIT_FINANCE
									&& rs.getInt(1) != Config.ORDER_STATE_END && order.getState() == Config.ORDER_STATE_WAIT_FINANCE)
									|| (order.getState() == Config.ORDER_STATE_END
											&& rs.getInt(1) != Config.ORDER_STATE_END && rs.getInt(1) != Config.ORDER_STATE_WAIT_FINANCE)) {
								//when order paymoney=+ else paymoney=-,
								sql = "select  paid_amount from customer where customerID='" + order.getClientid()
										+ "'";
								executeQuery(sql);
								if (rs.next()) {
									log.info(order.getClientid() + " before update customer paid_amount="
											+ rs.getDouble(1));
								}
								sql = "update customer set paid_amount = paid_amount - (" + (recmoney)
										+ ") where customerID='" + order.getClientid() + "'";
								executeUpdate(sql);
								log.info(order.getClientid() + " update customer sql=" + sql);
								executeQuery("select residualValue,paid_amount from customer where  customerID='"
										+ order.getClientid() + "'");
								if (rs.next()) {
									int type = 1;
									if (order.getType() == Config.ORDER_TYPE_CANCEL)
										type = 3;
									makeCustMoneyLog(order.getClientid(), order.getOrderid(), rs.getFloat(1),
											rs.getFloat(2), "订单计算利润", type);
									log.info(order.getClientid() + " after update customer paid_amount="
											+ rs.getDouble(2));
								}
							}
						}
						if (order.getState() == Config.ORDER_STATE_END) {
							markFinancial(order, 0, profit);
						}
					} else if (order.getState() == Config.ORDER_STATE_CANCLE
							|| order.getState() == Config.ORDER_STATE_DISALLOW_FINANCE
							|| order.getState() < Config.ORDER_STATE_WAIT_FINANCE) {
						sql = "select state from orderinfo where orderid='" + order.getOrderid() + "'";
						executeQuery(sql);
						if (rs.next()) {
							int s = rs.getInt(1);
							if ((rs.getInt(1) == Config.ORDER_STATE_WAIT_FINANCE && order.getState() < Config.ORDER_STATE_WAIT_FINANCE)
									|| (rs.getInt(1) == Config.ORDER_STATE_END && order.getState() < Config.ORDER_STATE_WAIT_FINANCE)) {
								sql = "select  paid_amount from customer where customerID='" + order.getClientid()
										+ "'";
								executeQuery(sql);
								double oldmoney = 0;
								double newmoney = 0;
								if (rs.next()) {
									oldmoney = rs.getFloat(1);
									log.info(order.getClientid() + " before update customer paid_amount=" + oldmoney);
								}
								executeUpdate("update customer set paid_amount = paid_amount + (" + recmoney
										+ ") where customerID='" + order.getClientid() + "'");
								Thread.sleep(500);
								log.info(order.getClientid() + " update customer sql=" + sql);
								executeQuery("select residualValue,paid_amount from customer where customerID='"
										+ order.getClientid() + "'");
								int typed = 2;
								if (order.getType() == Config.ORDER_TYPE_CANCEL)
									typed = 4;
								if (rs.next()) {
									newmoney = rs.getFloat(2);
									makeCustMoneyLog(order.getClientid(), order.getOrderid(), rs.getFloat(1),
											rs.getFloat(2), "订单回退利润", typed);
									log.info(order.getClientid() + " after update customer paid_amount=" + newmoney);
								}
								if (oldmoney != 0 && newmoney != 0 && recmoney != 0 && newmoney == oldmoney) {
									sql = "update customer set paid_amount = paid_amount + (" + recmoney
											+ ") where customerID='" + order.getClientid() + "'";
									executeUpdate(sql);
									Thread.sleep(500);
									executeQuery("select residualValue,paid_amount from customer where customerID='"
											+ order.getClientid() + "'");
									if (rs.next()) {
										makeCustMoneyLog(order.getClientid(), order.getOrderid(), rs.getFloat(1),
												rs.getFloat(2), "回退失败，再次订单回退利润", typed);
										log.info(order.getClientid() + " 2 after update customer paid_amount="
												+ newmoney);
									}
								}

							}
							if (s == Config.ORDER_STATE_END && order.getState() != s) {
								markFinancial(order, 1, 0);
							}
						}

					}

					if (order.getState() == Config.ORDER_STATE_CANCLE) {
						paymoney = 0;
						recmoney = 0;
						profit = 0;
					}
					sql = "update orderinfo set state=" + order.getState() + ",type=" + order.getType()
							+ ",producttype=" + order.getProducttype() + ",productname='" + order.getProductname()
							+ "',cid='" + order.getClientid() + "',pnr='" + order.getPnr() + "',offercompany='"
							+ order.getOffer() + "',recmoney=" + recmoney + ",paymoney=" + paymoney + ",lasttime='"
							+ Utils.getNowTimestamp() + "',lasttimei=" + Utils.getSystemMillis() + ",lastuser='"
							+ carno + "',profit=" + profit + " where orderid='" + order.getOrderid() + "'";
					executeUpdate(sql);
					markUserLogs("修改订单:" + order.getOrderid());
					order.setRecmoney(recmoney);
					order.setPaymoney(paymoney);
					markOrderLogs(order);
					skip = SUCCESS;
				}

			} else if ("opass".equals(action)) {
				if (!Utils.isNull(sid)) {
					log.info(" orderjson opass orderid=" + sid);
					String[] orderid = (sid.substring(0, sid.length() - 1)).split(";");
					StringBuffer b = new StringBuffer();
					for (int i = 0; i < orderid.length; i++) {
						String[] o = orderid[i].split(",");
						sql = "update orderinfo set state=" + Config.ORDER_STATE_END + " where orderid='" + o[0] + "'";
						executeUpdate(sql);
						order = new Order();
						order.setOrderid(o[0]);
						order.setState(Config.ORDER_STATE_END);
						markFinancial(order, 0, Double.valueOf(o[1]));
						markUserLogs("修改订单:" + order.getOrderid());

						sql = "select id,orderid,state,type,producttype,productname,cid,pnr,recmoney,paymoney,lasttime,cmnt,userid,lastuser from orderinfo where orderid='"
								+ o[0] + "'";
						executeQuery(sql);
						if (rs.next()) {
							order.setType(rs.getInt(4));
							order.setProductname(rs.getString(6));
							order.setClientid(rs.getString(7));
							String pnr = rs.getString(8);
							Double recmoney = rs.getDouble(9);
							Double paymoney = rs.getDouble(10);
							order.setProducttype(rs.getInt(5));
							order.setPnr(pnr);
							order.setRecmoney(recmoney);
							order.setPaymoney(paymoney);
						}
						//String user = rs.getString(13);
						markOrderLogs(order);
						b.append(o[0]).append("|");
					}
					log.info(" end opass orderid=" + b.toString());
				}

				skip = SUCCESS;
			} else if ("save".equals(action)) {
				if (order != null) {
					if (!Utils.isNull(order.getPnr())) {
						sql = "select orderid from orderinfo where pnr = '" + order.getPnr() + "' and type="
								+ order.getType() + " and state <> " + Config.ORDER_STATE_CANCLE + " order by id desc";
						executeQuery(sql);
						if (rs.next()) {
							if (!rs.getString(1).equals(order.getOrderid())) {
								addActionMessage("操作失败，" + Helper.getOrderType(order.getType()) + "PNR:"
										+ order.getPnr() + " 已经存在,请查看订单编号:" + rs.getString(1));
								return ERROR;
							}
						}
					}
					if (!Utils.isNull(order.getOrderid())) {
						String orderid = order.getOrderid();
						if (orderid.startsWith("TP") || orderid.startsWith("JP"))
							orderid = orderid.substring(2);
						sql = "select orderid from orderinfo where orderid like '%" + orderid + "'";
						executeQuery(sql);
						if (rs.next()) {
							String newoid = getOrderID(carno);
							if (order.getType() == Config.ORDER_TYPE_CANCEL)
								newoid = "TP" + newoid;
							else
								newoid = "JP" + newoid;
							order.setOrderid(newoid);
						}
					}

					List<Product> lsp = getSaveProduct(order.getSavepdata());
					for (int i = 0; i < lsp.size(); i++) {
						Product pr = lsp.get(i);
						StringBuffer bfs = new StringBuffer();
						bfs.append(
								"insert into orderproduct(orderid,carrier,flight,position,trip,sdate,stime,edate,etime) values('")
								.append(order.getOrderid() + "','").append(pr.getCarrier() + "','")
								.append(pr.getFlight() + "','").append(pr.getPosition() + "','")
								.append(pr.getTrip() + "','").append(pr.getSdate() + "','")
								.append(pr.getStime() + "','").append(pr.getEdate() + "','")
								.append(pr.getEtime() + "')");
						sql = bfs.toString();
						executeUpdate(sql);
					}

					double recmoney = 0.00;
					double paymoney = 0.00;
					List<Traveller> lst = getSaveTraveller(order.getSavecdata());
					for (int i = 0; i < lst.size(); i++) {
						Traveller tr = lst.get(i);
						StringBuffer bfs = new StringBuffer();
						bfs.append(
								"insert into ordertraveller(orderid,name,type,recmoney,paymoney,pnum,supplier) values('")
								.append(order.getOrderid() + "','").append(tr.getName() + "',")
								.append(tr.getType() + ",").append(tr.getRecmoney().replaceAll(",", "") + ",")
								.append(tr.getPaymoney().replaceAll(",", "") + ",'").append(tr.getPnum() + "','")
								.append(tr.getSupplier() + "')");
						sql = bfs.toString();
						executeUpdate(sql);
						if (!Utils.isNull(tr.getRecmoney()))
							recmoney += Double.valueOf(tr.getRecmoney().replaceAll(",", ""));
						if (!Utils.isNull(tr.getPaymoney()))
							paymoney += Double.valueOf(tr.getPaymoney().replaceAll(",", ""));
					}
					if (!Utils.isNull(order.getCmnt())) {
						String username = (String) getSession().getAttribute(Config.USER_NAME);

						sql = "insert into ordercmnt(orderid,username,lasttime,cmnt) values('" + order.getOrderid()
								+ "','" + username + "','" + Utils.getNowTimestamp() + "','"
								+ order.getCmnt().replaceAll(" ", "") + "')";
						executeUpdate(sql);
					}
					sql = "insert into orderinfo(orderid,state,type,producttype,productname,cid,pnr,recmoney,paymoney,lasttime,lasttimei,userid,lastuser,createtime,createtimei,offercompany) values('"
							+ order.getOrderid()
							+ "',"
							+ order.getState()
							+ ","
							+ order.getType()
							+ ","
							+ order.getProducttype()
							+ ",'"
							+ (order.getProductname()).toUpperCase()
							+ "','"
							+ order.getClientid()
							+ "','"
							+ order.getPnr()
							+ "',"
							+ recmoney
							+ ","
							+ paymoney
							+ ",'"
							+ Utils.getNowTimestamp()
							+ "',"
							+ Utils.getSystemMillis()
							+ ",'"
							+ carno
							+ "','"
							+ carno
							+ "','"
							+ Utils.getNowTimestamp()
							+ "',"
							+ Utils.getSystemMillis()
							+ ",'"
							+ order.getOffer() + "')";
					//						System.out.println(sql);
					executeUpdate(sql);
					markUserLogs("添加订单:" + order.getOrderid());
					order.setRecmoney(recmoney);
					order.setPaymoney(paymoney);
					markOrderLogs(order);
				}
				skip = SUCCESS;
			} else {
				term = Helper.getQuerySql(query, "createtimei");
				if (Config.USER_TYPE_COMMON == Integer.valueOf(usertype)) {
					term += " and o.userid='" + carno + "'";
				}
				if (!Utils.isNull(sid)) {
					term += " and o.orderid like '%" + sid.trim() + "%'";
				}
				if (!Utils.isNull(clientid)) {
					term += " and o.cid like '%" + clientid.trim() + "%'";
				}
				if (!Utils.isNull(maker)) {
					term += " and o.userid ='" + maker.trim() + "'";
				}
				String[] pnrl = null;
				if (!Utils.isNull(pnr)) {
					String cmd = URLDecoder.decode(pnr, "UTF-8");
					cmd = cmd.toUpperCase();
					String cmd1 = "";
					if (cmd.indexOf(",") != -1) {
						String[] cmd2 = cmd.split(",");
						for (String str : cmd2) {
							if (cmd1.length() > 0)
								cmd1 += ",";
							cmd1 += str.trim();
						}
						cmd = cmd1.replaceAll(",", "','");
					} else if (cmd.indexOf("，") != -1) {
						String[] cmd2 = cmd.split("，");
						for (String str : cmd2) {
							if (cmd1.length() > 0)
								cmd1 += "，";
							cmd1 += str.trim();
						}
						cmd = cmd.replaceAll("，", "','");
					} else
						cmd = cmd.trim();
					pnrl = cmd.split("','");
					term += " and upper(o.pnr) in ('" + cmd + "')";
				}
				if (!Utils.isNull(type)) {
					if (!String.valueOf(Config.ORDER_TYPE_ALL).equals(type))
						term += " and o.type = " + type;
				}

				if (!Utils.isNull(state)) {
					if (!String.valueOf(Config.ORDER_TYPE_ALL).equals(state))
						term += " and o.state in (" + state.replaceAll(";", ",") + ")";
				}
				if (!Utils.isNull(cname)) {
					String name = URLDecoder.decode(cname, "UTF-8");
					term += " and c.company like '%" + name.trim() + "%'";
				}
				if (!Utils.isNull(offer)) {
					String name = URLDecoder.decode(offer, "UTF-8");
					String cmd1 = " supplier ='" + name.trim() + "'";
					term += " and o.orderid in (select orderid from ordertraveller where 1=1 and " + cmd1 + ")";
				}
				if (!Utils.isNull(piao)) {
					String cmd1 = "";
					if (piao.indexOf(",") != -1) {
						String[] cmd2 = piao.split(",");
						for (String str : cmd2) {
							if (cmd1.length() > 0)
								cmd1 += ",";
							cmd1 += str.trim();
						}
						cmd1 = " pnum in ('" + cmd1.replaceAll(",", "','") + "'";
					} else if (piao.indexOf("，") != -1) {
						String[] cmd2 = piao.split("，");
						for (String str : cmd2) {
							if (cmd1.length() > 0)
								cmd1 += "，";
							cmd1 += str.trim();
						}
						cmd1 = " pnum in ('" + piao.replaceAll("，", "','") + "'";
					} else {
						cmd1 = " pnum like '%" + piao.trim() + "%'";
					}
					term += " and o.orderid in (select orderid from ordertraveller where 1=1 and "
							+ cmd1.replaceAll("-", "") + ")";
				}

				skip = JSON;

				String cmd2 = Helper.getQuerySql(query, "o.createtimei");
				sql = "select o.orderid,t.supplier,c.name from orderinfo o,ordertraveller t,offercompany c where o.orderid=t.orderid and t.supplier=c.id "
						+ cmd2 + " group by orderid,supplier order by t.id";
				executeQuery(sql);
				Hashtable<String, String> sup_hs = new Hashtable<String, String>();
				while (rs.next()) {
					String key = rs.getString(1);
					String value = rs.getString(3);
					if (!sup_hs.containsKey(key)) {
						sup_hs.put(key, value);
					} else {
						if (value != null)
							if (sup_hs.get(key).length() < 2) {
								sup_hs.put(key, value);
							}
					}
				}
				sql = "select o.id,o.orderid,o.state,o.type,o.producttype,o.productname,o.cid,o.pnr,o.recmoney,o.paymoney,o.createtime,o.cmnt,o.userid,o.lastuser,o.profit,c.name,fo.adjust_profit,c.company,o.offercompany,fo.received_state from (orderinfo o LEFT JOIN financial_order fo on o.orderid=fo.order_code),customer c where c.customerid=o.cid "
						+ term + "  order by id";
				//log.info("query:"+sql);
				executeQuery(sql);
				float recmoney0 = 0;
				float paymoney0 = 0;
				float profit0 = 0;
				float profit20 = 0;
				Hashtable<String, String> ls = new Hashtable<String, String>();
				int e = 0;
				int nowdate = Utils.getNowDateInt();//当前时间 20130802
				while (rs.next()) {
					//String id = rs.getString(1);
					String order = rs.getString(2);
					String state = Helper.getOrterState1(rs.getInt(3));
					String type = Helper.getOrderType(rs.getInt(4));
					String producttype = Helper.getProductType(rs.getInt(5));
					String productname = rs.getString(6);
					//						String clientid = rs.getString(7);
					String pnr = rs.getString(8);
					String recmoney = rs.getString(9);
					String paymoney = rs.getString(10);
					String profit = rs.getString(15);
					String date = rs.getDate(11) + "";
					int cdate = Integer.valueOf(date.replaceAll("-", ""));

					boolean update = false;
					if (nowdate - cdate == 0) {
						update = true;
					}
					String time = rs.getTime(11) + "";
					String user = rs.getString(13);
					String luser = rs.getString(14);
					String cname = rs.getString(16);
					String profit2 = rs.getString(17);
					String company = rs.getString(18);
					String rstate = rs.getString(20);
					String offercompany = "";
					if (sup_hs.get(order) != null) {
						offercompany = sup_hs.get(order);
					}
					if (Utils.isNull(profit2)) {
						profit2 = "0.00";
					}
					recmoney0 += Float.valueOf(recmoney);
					paymoney0 += Float.valueOf(paymoney);
					profit0 += Float.valueOf(profit);
					profit20 += Float.valueOf(profit2);
					StringBuffer cf = new StringBuffer();
					cf.append("{'HideID':'" + order).append("','HideKey':'" + update).append("','订单编号':'" + order)
							.append("','订单类型':'" + type).append("','订单状态':'" + state)
							.append("','产品类型':'" + producttype).append("','产品名称':'" + productname)
							.append("','客户名称':'" + cname).append("','公司名称':'" + company)
							.append("','供应商':'" + offercompany).append("','PNR':'" + pnr)
							.append("','收款状态':'" + Helper.getRstate(rstate)).append("','总应收款':'" + recmoney)
							.append("','总应付款':'" + paymoney);
					cf.append("','利润':'" + profit).append("','校正利润':'" + profit2);
					cf.append("','创建人工号':'" + user).append("','创建日期':'" + date).append("','创建时间':'" + time)
							.append("','最后修改人工号':'" + luser + "'}");
					if (e > 0)
						bf.append(",");
					bf.append(cf);
					ls.put(pnr.toUpperCase() + "," + rs.getInt(4), cf.toString());
					e++;
				}
				count = e;
				if (pnrl != null) {
					int c = 0;
					bf = new StringBuffer();
					for (int i = 0; i < pnrl.length; i++) {
						if (String.valueOf(Config.ORDER_TYPE_ALL).equals(type)) {
							String key0 = pnrl[i] + "," + Config.ORDER_TYPE_ORDER;
							String key1 = pnrl[i] + "," + Config.ORDER_TYPE_CANCEL;
							if (ls.get(key0) != null) {
								if (c > 0)
									bf.append(",");
								bf.append(ls.get(key0));
								c++;
								ls.remove(key0);
							}
							if (ls.get(key1) != null) {
								if (c > 0)
									bf.append(",");
								bf.append(ls.get(key1));
								c++;
								ls.remove(key1);
							}
						} else {
							String key1 = pnrl[i] + "," + type;
							if (ls.get(key1) != null) {
								if (c > 0)
									bf.append(",");
								bf.append(ls.get(key1));
								c++;
								ls.remove(key1);
							}
						}
					}
					count = c;
				}

				String counts = "总数：" + count + " , 总应收款：" + recmoney0 + " , 总应付款：" + paymoney0 + " , 总利润：" + profit0
						+ " , 总校正利润：" + profit20;

				tojson(counts);

				HttpServletResponse response = getResponse();
				response.setCharacterEncoding("GBK");
				response.setContentType("text/javascript");

				response.getWriter().print(
						"{\"Rows\":[" + datas + " ],\"Total\":\"" + total + "\",\"totalRender\":\"" + totalRender
								+ "\"}");
				closeConnection();
				return null;
			}
		}

		closeConnection();

		return skip;
	}

	private void loadTxt() {
		if (!Utils.isNull(order.getLoadtxt())) {
			try {
				int t = 0;
				String s0 = order.getLoadtxt().trim();
				StringBuffer sb = new StringBuffer();
				for (int i = 0; i < s0.length(); i++) {
					int ais2 = (int) s0.charAt(i);
					if (ais2 == 13 || ais2 == 10) {
						sb.append((char) 32);
						continue;
					}
					sb.append((char) ais2);
				}
				s0 = sb.toString();
				sb = new StringBuffer();
				for (int i = 0; i < s0.length(); i++) {
					int ais2 = (int) s0.charAt(i);
					if (ais2 == 32 && t == 32) {//&nbsp;&nbsp;
						continue;
					} else if (ais2 == 32 && t == 46) {//.&nbsp;
						continue;
					}
					t = ais2;
					sb.append((char) ais2);
				}
				s0 = sb.toString();
				String[] s = s0.split(" ");
				int p = 0;
				for (int i = 0; i < s.length; i++) {
					if (Utils.isNumeric(s[i]) && s[i].length() > 1) {
						p = i - 6;
						break;
					}
				}

				order.setPnr(s[p]);
				String cstr = s0.split(s[p])[0];//client
				sb = new StringBuffer();
				int w = 0;
				for (int i = 0; i < cstr.length(); i++) {
					int ais2 = (int) cstr.charAt(i);
					if (ais2 == 46) {//&nbsp;&nbsp;
						w++;
						if (w > 10)
							sb.deleteCharAt(sb.length() - 2);
						else
							sb.deleteCharAt(sb.length() - 1);
						if (w != 1)
							sb.append((char) ais2);
						continue;
					}
					sb.append((char) ais2);
				}
				String s1 = sb.toString();
				String cplit[] = s1.split("\\.");
				StringBuffer bc = new StringBuffer();
				for (int i = 0; i < cplit.length; i++) {
					if (i > 0)
						bc.append(",");
					bc.append("{'name':'" + cplit[i]).append(
							"','type':'1','recmoney':'0.00','paymoney':'0.00','pnum':' ','supplier':' ','HideID':' '}");
				}
				order.setCdata(bc.toString());

				String pstr = s0.split(s[p])[1];
				String[] dplit = pstr.split("\\.");

				bc = new StringBuffer();
				for (int i = 1; i < dplit.length; i++) {
					if (i > 1)
						bc.append(",");
					String[] dd = dplit[i].split(" ");
					if (dd.length < 4) {
						if (dd[0].indexOf("OPEN") != -1) {
							String ca = dd[0].split("OPEN")[0];
							bc.append("{'carrier':'" + ca + "','flight':' ','position':' ','trip':'"
									+ dd[2].substring(0, 3) + "-" + dd[2].substring(3)
									+ "','sdate':'OPEN','stime':' ','edate':' ','etime':' ','HideID':' '}");
						} else

							bc.append("{'carrier':' ','flight':' ','position':' ','trip':'" + dd[1].substring(0, 3)
									+ "-" + dd[1].substring(3)
									+ "','sdate':' ','stime':' ','edate':' ','etime':' ','HideID':' '}");
					} else {

						String sd = Helper.getStrDate(dd[2]);
						String st = dd[5];
						String et = dd[6];
						int g = 0;
						if (et.indexOf("-") != -1 || et.indexOf("+") != -1) {
							g = Integer.valueOf(et.substring(5).trim());
							if (et.indexOf("-") != -1)
								g = -g;
							et = et.substring(0, 4);
						}
						String ed = Utils.getAddDate(sd, g);
						st = st.substring(0, 2) + ":" + st.substring(2, 4);
						et = et.substring(0, 2) + ":" + et.substring(2, 4);

						bc.append("{'carrier':'" + dd[0].substring(0, 2)).append("','flight':'" + dd[0])
								.append("','position':'" + dd[1])
								.append("','trip':'" + dd[3].substring(0, 3) + "-" + dd[3].substring(3))
								.append("','sdate':'" + sd).append("','stime':'" + st).append("','edate':'" + ed)
								.append("','etime':'" + et + "','HideID':' '}");
					}
				}
				order.setPdata(bc.toString());
			} catch (Exception e) {
				order.setCdata("{'name':'格式有误','type':'1','recmoney':'0.00','paymoney':'0.00','pnum':' ','supplier':' ','HideID':' '}");
				order.setPdata("{'carrier':'格式有误','flight':' ','position':' ','trip':' ','sdate':' ','stime':' ','edate':' ','etime':' ','HideID':' '}");
				System.out.println(e.toString());
			}
		} else {
			order.setCdata("{'name':'New','type':'1','recmoney':'0.00','paymoney':'0.00','pnum':' ','supplier':' ','HideID':' '}");
			order.setPdata("{'carrier':'New','flight':' ','position':' ','trip':' ','sdate':' ','stime':' ','edate':' ','etime':' ','HideID':' '}");
		}

	}

	private List<Product> getSaveProduct(String data) {
		List<Product> ls = new ArrayList<Product>();

		try {
			String str = data.replaceAll("\"", "");
			String[] l = str.split("},");
			for (int i = 0; i < l.length; i++) {
				String[] lt = l[i].split(",");
				Product p = new Product();
				p.setCarrier(lt[0].split(":")[1]);
				p.setFlight(lt[1].split(":")[1]);
				p.setPosition(lt[2].split(":")[1]);
				p.setTrip(lt[3].split(":")[1]);
				p.setSdate(lt[4].split(":")[1]);
				if (" ".equals(p.getCarrier())) {
					p.setStime(" ");
					p.setEtime(" ");
					p.setEdate(lt[6].split(":")[1]);
				} else if ("OPEN".equals(p.getSdate())) {
					p.setEdate(" ");
					p.setStime(" ");
					p.setEtime(" ");
				} else {
					try {
						p.setStime(lt[5].split(":")[1] + ":" + lt[5].split(":")[2]);
						p.setEtime(lt[7].split(":")[1] + ":" + lt[7].split(":")[2].substring(0, 2));
						p.setEdate(lt[6].split(":")[1]);
					} catch (Exception e) {
						p.setStime(lt[5].split(":")[1]);
						p.setEtime(lt[7].split(":")[1]);
						p.setEdate(lt[6].split(":")[1]);
					}
				}
				String st0 = lt[8].split(":")[1];
				if (st0.indexOf("}") != -1)
					p.setId(st0.substring(0, st0.indexOf("}")));
				else
					p.setId(st0);
				ls.add(p);
			}
		} catch (Exception e) {
			System.out.println(e.toString() + " data=" + data);
		}
		return ls;
	}

	private List<Traveller> getSaveTraveller(String data) {

		List<Traveller> ls = new ArrayList<Traveller>();
		try {
			String str = data;
			String[] l = str.split("},");
			for (int i = 0; i < l.length; i++) {
				String[] lt = l[i].split("\",\"");
				Traveller p = new Traveller();
				p.setName(lt[0].split(":")[1].replaceAll("\"", ""));
				p.setType(Integer.valueOf(lt[1].split(":")[1].replaceAll("\"", "")));
				p.setRecmoney(lt[2].split(":")[1].replaceAll("\"", ""));
				p.setPaymoney(lt[3].split(":")[1].replaceAll("\"", ""));
				p.setPnum(Utils.decode(lt[4].split(":")[1].replaceAll("\"", "")));
				p.setSupplier(Utils.decode(lt[5].split(":")[1].replaceAll("\"", "")));
				String st0 = Utils.decode(lt[6].split(":")[1]).replaceAll("\"", "");
				if (st0.indexOf("}") != -1)
					p.setId(st0.substring(0, st0.indexOf("}")));
				else
					p.setId(st0);
				ls.add(p);
			}
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return ls;
	}

	protected String getLogsdata(String orderid) throws Exception {
		sql = "select lasttime,lastuser,state  from orderlogs where orderid = '" + orderid + "' order by id desc";
		executeQuery(sql);
		StringBuffer sb = new StringBuffer();
		int t = 0;
		while (rs.next()) {
			if (t > 0)
				sb.append(",");
			sb.append("{'ldate':'" + rs.getDate(1)).append("','ltime':'" + rs.getTime(1))
					.append("','luser':'" + rs.getString(2))
					.append("','lcmnt':'更变订单状态为：" + Helper.getOrterState1(rs.getInt(3)) + "'}");
			t++;
		}
		if (t == 0) {
			return "{'ldate':'无历史操作'}";
		}
		return sb.toString();
	}

	protected void markFinancial(Order order, int fstate, double profit) throws Exception {
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

	protected void markOrderLogs(Order order) {
		String userid = (String) getSessionAttribute(Config.USER_ID);
		sql = "insert into orderlogs(orderid,state,type,producttype,productname,cid,pnr,recmoney,paymoney,lasttime,lasttimei,lastuser) values('"
				+ order.getOrderid()
				+ "',"
				+ order.getState()
				+ ","
				+ order.getType()
				+ ","
				+ order.getProducttype()
				+ ",'"
				+ order.getProductname()
				+ "','"
				+ order.getClientid()
				+ "','"
				+ order.getPnr()
				+ "',"
				+ order.getRecmoney()
				+ ","
				+ order.getPaymoney()
				+ ",'"
				+ Utils.getNowTimestamp()
				+ "',"
				+ Utils.getSystemMillis() + ",'" + userid + "')";
		executeUpdate(sql);
	}

	protected String getOrderID(String carno) throws Exception {
		String date = Utils.getNowDate();
		int num = 1;
		sql = "select orderid from orderinfo where userid='" + carno + "' and date(createtime)=date('" + date
				+ "') order by id desc limit 0,1";
		executeQuery(sql);
		if (rs.next()) {
			String ono = rs.getString(1);//TP20301001
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

	protected void setOfferData() throws Exception {
		StringBuffer bf = new StringBuffer();
		sql = "select id,name from offercompany ";
		executeQuery(sql);
		int c = 0;
		while (rs.next()) {
			if (c > 0)
				bf.append(",");
			bf.append(rs.getString(1) + ":::" + rs.getString(2));
			c++;
		}
		this.offerdata = bf.toString();
	}

}
