package com.oas.common;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.oas.objects.Customer;
import com.oas.objects.User;
import com.opensymphony.xwork2.ActionSupport;

public class DataSourceAction extends ActionSupport {
	private static final long serialVersionUID = 3759812551034611228L;
	protected final Logger log = Logger.getLogger(getClass());
	protected static final String EDIT = "edit";
	protected static final String LIST = "list";
	protected static final String LOGON = "login";
	protected static final String JSON = "json";
	protected static final String CHECK = "check";
	protected static final String VIEW = "view";
	protected static final String DATA = "data";
	protected static final String EDIT1 = "edit1";

	protected Connection conn = null;
	protected Statement stmt = null;
	protected ResultSet rs = null;

	public String sql;
	public String skip = ERROR;
	public StringBuffer bf = new StringBuffer();
	public String term = "";
	public int count = 0;
	public int total = 0;
	public int pages = 1;
	public float amount = 0;

	public HttpServletRequest getRequest() {
		return ServletActionContext.getRequest();
	}

	public HttpServletResponse getResponse() {
		return ServletActionContext.getResponse();
	}
	
	public HttpSession getSession() {
		return ServletActionContext.getRequest().getSession();
	}

	public Object getSessionAttribute(String key) {
		return getSession().getAttribute(key);
	}

	public void setSessionAttribute(String key, Object sobj) {
		getSession().setAttribute(key, sobj);
	}

	protected Connection getConnection() throws SQLException {
		return DriverManager.getConnection(Config.proxool);
	}

	public int getPages() {
		return pages;
	}

	public void setPages(int pages) {
		this.pages = pages;
	}

	protected void executeQuery(String sqlcmd) {
		try {
			if (conn == null)
				conn = getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sqlcmd);
		} catch (Exception e) {
			log.error(e.toString() + " sql=" + sqlcmd);
		}
	}

	protected void executeUpdate(String sqlcmd) {
		try {
			if (conn == null)
				conn = getConnection();
			stmt = conn.createStatement();
			stmt.executeUpdate(sqlcmd);
		} catch (Exception e) {
			System.out.println(e.toString() + " sql=" + sqlcmd);
			log.error(e.toString() + " sql=" + sqlcmd);
		}
	}

	protected void markUserLogs(String cmnt) {
		String userid = (String) getSessionAttribute(Config.USER_ID);
		String sqlcmd = "insert into userlogs(userid,cmnt,lasttime,lasttimei) values('" + userid + "','" + cmnt + "','"
				+ Utils.getNowTimestamp() + "'," + Utils.getSystemMillis() + ")";
		try {
			if (conn == null)
				conn = getConnection();
			stmt = conn.createStatement();
			stmt.executeUpdate(sqlcmd);
		} catch (Exception e) {
			log.error(e.toString() + " sql=" + sqlcmd);
		}
	}

	protected void markOrderLogs(int orderid, String cmnt) {

	}

	//更新客户信息
	protected boolean getUpdateCustomer(Customer customer) {
		String userid = (String) getSessionAttribute(Config.USER_ID);
		String customerid = customer.getCustomerID();
		Float rv = customer.getResidualValue();//剩余金额
		sql = "update customer set name='" + customer.getName() + "'" + ",company='" + customer.getCompany() + "'"
				+ ",sex='" + customer.getSex() + "'" + ",telephone='" + customer.getTelephone() + "'" + ",phone='"
				+ customer.getQq() + "'" + ",address='" + customer.getAddress() + "'" + ",operator='" + userid + "'"
				+ ",residualValue='" + rv + "'" + " where customerID = '" + customerid + "'";
		try {
			if (conn == null)
				conn = getConnection();
			stmt = conn.createStatement();
			stmt.executeUpdate(sql);
			return true;
		} catch (Exception e) {
			log.error(e.toString() + " sql=" + sql);
			return false;
		}
	}

	//转移用户
	protected boolean changeCustomerOperator(String customerid, String newWorkNo) throws SQLException {
		try {
			String sql1 = "update customer set  oldoperator=operator where customerid='" + customerid + "'";
			executeUpdate(sql1);
		} catch (Exception e) {
			skip = ERROR;
			addActionError("Reason:  " + customerid + " not exists");
			return false;
		}
		try {
			sql = "update customer set operator= '" + newWorkNo + "' where customerid='" + customerid + "'";
			executeUpdate(sql);
		} catch (Exception e) {
			skip = ERROR;
			addActionError("新工卡关联更新失败");
			return false;
		}
		return true;
	}

	//通过ID获得用户信息
	protected Customer getTACustomer(String customerID) throws SQLException {
		Customer customer = new Customer();
		sql = "select customerID,name,company,sex,telephone,phone,QQ,address,operator,residualValue,id from customer where customerid = '"
				+ customerID + "'";
		executeQuery(sql);
		if (rs.next()) {
			customer.setCustomerID(customerID);
			customer.setName(rs.getString(2));
			customer.setCompany(rs.getString(3));
			customer.setSex(rs.getString(4));
			customer.setTelephone(rs.getString(5));
			customer.setPhone(rs.getString(6));
			customer.setQq(rs.getString(7));
			customer.setAddress(rs.getString(8));
			customer.setOperator(rs.getString(9));
			customer.setResidualValue(rs.getFloat(10));
			customer.setId(rs.getInt(11));
			return customer;
		} else {
			skip = ERROR;
			addActionError("Reason:  " + customerID + " not exists");
			return customer;
		}
	}

	//判断是否存在
	protected String getCustid(String userid) throws SQLException {
		User uu = getUser(userid);
		String cardno = "";
		if (uu != null) {
			cardno = uu.getWorkcardno();
		}
		sql = "select customerID from customer where operator = '" + cardno + "' order by id desc LIMIT 0 , 1";
		executeQuery(sql);
		if (rs.next()) {
			String cid = rs.getString("customerID");
			String dd = cid.substring(cid.length() - 4);
			Integer ii = Integer.parseInt(dd) + 1;
			if (ii < 10)
				cardno += "000" + ii;
			else if (ii >= 10 && ii < 100)
				cardno += "00" + ii;
			else if (ii >= 100 && ii < 1000)
				cardno += "0" + ii;
			else
				cardno += ii;
		} else
			cardno += "0001";
		return cardno;
	}

	//通过ID获得用户信息
	protected User getUser(String userCard) throws SQLException {
		User cuser = new User();
		sql = "SELECT uid,name,pwd,email,state,usertype,phone,mobile,lastip,lasttime,leaderid,cmnt,workcardno FROM user where state!=2 and workcardno = '"
				+ userCard + "'";
		executeQuery(sql);
		if (rs.next()) {
			cuser.setCmnt(rs.getString("cmnt"));
			;
			cuser.setUid(rs.getString("uid"));
			cuser.setName(rs.getString("name"));
			cuser.setUsertype(rs.getInt("usertype"));
			cuser.setLeaderid(rs.getString("leaderid"));
			cuser.setWorkcardno(rs.getString("workcardno"));
			return cuser;
		} else {
			skip = ERROR;
			addActionError("工号 " + userCard + "无效！");
			return cuser;
		}
	}

	//通过序列号删除转账信息
	protected boolean delCustomerTransferBySequenceid(long sequenceid) {
		sql = "delete from customer_transfer where other_expenses_id in(" + sequenceid + ")";
		try {
			if (conn == null)
				conn = getConnection();
			stmt = conn.createStatement();
			stmt.executeUpdate(sql);
			markUserLogs("转账失败，回退序列号为：" + sequenceid + " 转账信息");
			return true;
		} catch (Exception e) {
			log.error(e.toString() + " sql=" + sql);
			markUserLogs("转账失败，回退失败，序列号为：" + sequenceid + " 转账信息");
			return false;
		}
	}

	//通过序列号删除票款抵消费用信息
	protected boolean delRelaOrderBySequenceid(long sequenceid) {
		sql = "delete from other_expenses_rela_order where other_expenses_id in(" + sequenceid + ")";
		try {
			if (conn == null)
				conn = getConnection();
			stmt = conn.createStatement();
			stmt.executeUpdate(sql);
			markUserLogs("删除失败，回退序列号为：" + sequenceid + " 转账信息");
			return true;
		} catch (Exception e) {
			log.error(e.toString() + " sql=" + sql);
			markUserLogs("删除失败，回退失败，序列号为：" + sequenceid + " 转账信息");
			return false;
		}
	}

	//通过序列号删除票款抵消费用信息
	protected boolean delRelaOrderOffsetBySequenceid(long sequenceid) {
		sql = "delete from other_expenses_rela_order_offset where other_expenses_id in(" + sequenceid + ")";
		try {
			if (conn == null)
				conn = getConnection();
			stmt = conn.createStatement();
			stmt.executeUpdate(sql);
			markUserLogs("删除失败，回退序列号为：" + sequenceid + " 转账信息");
			return true;
		} catch (Exception e) {
			log.error(e.toString() + " sql=" + sql);
			markUserLogs("删除失败，回退失败，序列号为：" + sequenceid + " 转账信息");
			return false;
		}
	}

	//通过序列号删除其他信息
	protected boolean delOtherExpenseBySequenceid(long sequenceid) {
		sql = "delete from other_expenses where other_expenses_id in(" + sequenceid + ")";
		try {
			if (conn == null)
				conn = getConnection();
			stmt = conn.createStatement();
			stmt.executeUpdate(sql);
			markUserLogs("转账失败，回退序列号为：" + sequenceid + " 其他费用信息");
			return true;
		} catch (Exception e) {
			log.error(e.toString() + " sql=" + sql);
			markUserLogs("转账失败，回退失败，序列号为：" + sequenceid + " 其他费用信息");
			return false;
		}
	}

	//浮点型的加法运算
	protected Float getFloatAdd(Float xx, Float yy) {
		BigDecimal b1 = new BigDecimal(Float.toString(xx));
		BigDecimal b2 = new BigDecimal(Float.toString(yy));
		float ss = b1.add(b2).floatValue();
		return ss;
	}

	//浮点型的减法运算
	protected Float getFloatSub(Float xx, Float yy) {
		BigDecimal b1 = new BigDecimal(Float.toString(xx));
		BigDecimal b2 = new BigDecimal(Float.toString(yy));
		float ss = b1.subtract(b2).floatValue();
		return ss;
	}

	protected void closeConnection() {
		try {
			if (conn != null)
				conn.close();
		} catch (Exception e) {
			log.error(e.toString() + " sql=" + sql);
		}
	}

	//通过ID获得用户信息
	protected String getAllCustomer4Select(String customerID) throws SQLException {

		sql = "select customerID,name,telephone,QQ,residualValue from customer where 1=1 ";
		executeQuery(sql);
		if (rs.next()) {
			String customerid = rs.getString("customerID");
			String name = rs.getString("customerID");
			String telephone = rs.getString("customerID");
			String QQ = rs.getString("customerID");
			String residualValue = rs.getString("customerID");
			if (count != 0)
				bf.append(",");
			bf.append("{'HideID':'" + customerid + "'").append(",'客户编号：':'" + customerid + "'")
					.append(",'客户名称：':'" + name + "'").append(",'客户手机：':'" + telephone + "'")
					.append(",'客户QQ：':'" + QQ + "'").append(",'剩余金额：':'" + residualValue + "'}");
			count++;

		} else {
			skip = ERROR;
			addActionError("Reason:  " + " 数据出错，请重新登录后再进行操作。");
		}
		return bf.toString();

	}

	protected String action;
	public String datas;
	public String totalRender;
	private boolean result = true;

	public final String getAction() {
		return action;
	}

	public final void setAction(String action) {
		this.action = action;
	}

	public final boolean isResult() {
		return result;
	}

	public final void setResult(boolean result) {
		this.result = result;
	}

	public String getDatas() {
		return datas;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public void setDatas(String datas) {
		this.datas = datas;
	}

	public String getTotalRender() {
		return totalRender;
	}

	public void setTotalRender(String totalRender) {
		this.totalRender = totalRender;
	}

	protected void tojson(String counts) {
		if (count == 0)
			bf.append("{'提示':'无数据'}");
		total = count;
		datas = bf.toString();
		totalRender = counts;
	}

	protected void tojsonNew(String counts) {
		total = count;
		datas = bf.toString();
		totalRender = counts;
	}

	public boolean checkExistCutomer(String uid) throws Exception {
		sql = "SELECT c.customerID from user AS u ,  customer c where  c.operator = u.workcardno and u.uid ='" + uid
				+ "'";
		try {
			executeQuery(sql);
			if (rs.next()) {
				setResult(false);
				return true;
			}

		} catch (Exception e) {
			// TODO: handle exception
		}
		return false;
	}

	public boolean checkExistOrder(String id) throws Exception {
		sql = "select orderid from orderinfo where orderid='" + id + "' or cid ='" + id + "'";
		try {
			executeQuery(sql);
			if (rs.next()) {
				setResult(false);
				return true;
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		return false;

	}

	public void makeCustMoneyLog(String cid, String oid, double m1, double m2,String cmmt,int type) throws Exception {
		sql = "insert into customer_amount_logs(customer_id,rela_id,residualValueNew,paid_amount_new,cmnt,type) values('" + cid
				+ "','" + oid + "'," + m1 + "," + m2 + ",'"+cmmt+"',"+type+")";
		 
		executeUpdate(sql);
		 

	}
}
