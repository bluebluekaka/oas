package com.oas.common;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Enumeration;

import org.apache.log4j.Logger;

import com.oas.objects.Query;

public class Helper {

	protected final static Logger log = Logger.getLogger(Helper.class);

	public static Connection getConnection() throws Exception {
		return DriverManager.getConnection(Config.proxool);
	}

	public static String getLocalIP() throws Exception {
		String localip = "";
		InetAddress inetaddress = InetAddress.getLocalHost();
		localip = inetaddress.getHostAddress();
		if ("127.0.0.1".equals(localip) || "localhost".equals(localip) || localip.indexOf("local") != -1) {
			Enumeration<NetworkInterface> allnetinterface = NetworkInterface.getNetworkInterfaces();
			while (allnetinterface.hasMoreElements()) {
				NetworkInterface net = allnetinterface.nextElement();
				Enumeration<InetAddress> ipenum = net.getInetAddresses();
				while (ipenum.hasMoreElements()) {
					InetAddress ip = ipenum.nextElement();
					String t_ip = ip.getHostAddress();
					if (!"127.0.0.1".equals(t_ip) && !"localhost".equals(t_ip) && !t_ip.contains(":")) {
						localip = t_ip;
					}
				}
			}
		}
		return localip;
	}

	public static String getOtherExpensesType(int type) {
		String otherExpensesType = "";
		switch (type) {
		case 0:
			otherExpensesType = "转账";
			break;
		case 1:
			otherExpensesType = "订单其他费用";
			break;
		case 2:
			otherExpensesType = "票款抵消费用";
			break;
		}
		return otherExpensesType;
	}

	public static String getUseState(int state) {
		String states = "";
		switch (state) {
		case 1:
			states = "启用";
			break;
		case 0:
			states = "禁用";
			break;
		case 2:
			states = "删除";
			break;
		}
		return states;
	}

	public static String getUserType(int type) {
		String states = "-";
		switch (type) {
		case Config.USER_TYPE_ADMIN:
			states = "系统管理员";
			break;
		case Config.USER_TYPE_COMMON:
			states = "业务员";
			break;
		case Config.USER_TYPE_COMMON_MANERGER:
			states = "业务员经理";
			break;
		case Config.USER_TYPE_FINANCE:
			states = "财务员";
			break;
		case Config.USER_TYPE_FINANCE_MANERGER:
			states = "财务经理";
			break;
		case Config.USER_TYPE_TOP_MANERGER:
			states = "总经理";
			break;
		}
		return states;
	}

	public static String getOrterState(int state) {
		String states = "-";
		switch (state) {
		case Config.ORDER_STATE_WAIT_COMMON_MANAGER:
			states = "经理审核中";//"业务员生成订单-待业务员经理初步审核";
			break;
		case Config.ORDER_STATE_ALLOW_COMMON_MANAGER:
			states = "审核不通过";//"业务员经理初步审核通过-待业务员复录入";
			break;
		case Config.ORDER_STATE_DISALLOW_COMMON_MANAGER:
			states = "业务员经理初步审核不通过-订单作废";
			break;
		case Config.ORDER_STATE_WAIT_FINANCE:
			states = "业务员复录入完成提交订单-待财务员录入";
			break;
		case Config.ORDER_STATE_WAIT_FINANCE_MANAGER:
			states = "财务员录入完成-待财务经理审核";
			break;
		case Config.ORDER_STATE_ALLOW_FINANCE_MANAGER:
			states = "财务经理审核通过-待总经理审核";
			break;
		case Config.ORDER_STATE_DISALLOW_FINANCE_MANAGER:
			states = "财务经理审核不通过-待总经理审核";
			break;
		case Config.ORDER_STATE_ALLOW_TOP_MANAGER:
			states = "总经理审核通过-订单存档";
			break;
		case Config.ORDER_STATE_DISALLOW_TOP_MANAGER:
			states = "总经理审核不通过-订单作废";
			break;
		case Config.ORDER_STATE_CREATE:
			states = "生成中";//"总经理审核不通过-订单作废";
			break;
		}
		return states;
	}

	public static String getOrterState1(int check) {
		String states = "-";
		switch (check) {
		case Config.ORDER_STATE_CREATE:
			states = "生成中";
			break;
		case Config.ORDER_STATE_WAIT_COMMON_MANAGER:
			states = "待审核";
			break;
		case Config.ORDER_STATE_DISALLOW_COMMON_MANAGER:
			states = "审核不通过";
			break;
		case Config.ORDER_STATE_ALLOW_COMMON_MANAGER:
			states = "待出票";
			break;
		case Config.ORDER_STATE_WAIT_FINANCE:
			states = "出票成功";
			break;
		case Config.ORDER_STATE_DISALLOW_FINANCE:
			states = "待复出票";
			break;
		case Config.ORDER_STATE_WAIT_FINANCE_MANAGER:
			states = "待财经审核";
			break;
		case Config.ORDER_STATE_DISALLOW_FINANCE_MANAGER:
			states = "复待办";
			break;
		case Config.ORDER_STATE_CANCLE:
			states = "取消";
			break;
		case Config.ORDER_STATE_END:
			states = "结束";
			break;
		case Config.ORDER_TYPE_ALL:
			states = "全部";
			break;
		}

		return states;
	}

	public static String getOrderType(int state) {
		String states = "";
		switch (state) {
		case Config.ORDER_TYPE_ORDER:
			states = "订票";
			break;
		case Config.ORDER_TYPE_CANCEL:
			states = "退票";
			break;
		}
		return states;
	}

	public static String getOrderType1(int state) {
		String states = "";
		switch (state) {
		case Config.ORDER_TYPE_ORDER:
			states = "JP";
			break;
		case Config.ORDER_TYPE_CANCEL:
			states = "TP";
			break;
		}
		return states;
	}

	public static String getProductType(int state) {
		String states = "";
		switch (state) {
		case Config.ORDER_PRC_TYPE_INTERNATIONL:
			states = "国际机票";
			break;
		case Config.ORDER_PRC_TYPE_INTERNAL:
			states = "国内机票";
			break;
		case Config.ORDER_PRC_TYPE_HOTEL:
			states = "酒店";
			break;
		case Config.ORDER_PRC_TYPE_MARK:
			states = "签证";
			break;
		}
		return states;
	}

	public static String getStrDate(String str) {//str = "SA18JAN"
		String year = Utils.getNowDate().substring(0, 4);
		String day = str.substring(2, 4);
		int m = Utils.getEnligthMonth(str.substring(4));
		if (m < 10)
			return year + "-0" + m + "-" + day;
		else
			return year + "-" + m + "-" + day;
	}

	public static String getOrderID() {
		String states = Utils.getNowDate().replaceAll("-", "");
		if (DBCache.ORDER_MAX_ID < 10) {
			states += "00" + DBCache.ORDER_MAX_ID;
		} else if (DBCache.ORDER_MAX_ID < 100) {
			states += "0" + DBCache.ORDER_MAX_ID;
		} else {
			states += DBCache.ORDER_MAX_ID;
		}
		DBCache.ORDER_MAX_ID++;
		return states;
	}

	public static String getQuerySql(Query query, String timename) {
		String term = "";
		if (query != null) {
			if (!Utils.isNull(query.getStime()))
				term += " and " + timename + " >= " + Utils.getDateToMillis(query.getStime());
			else
				term += " and " + timename + " >= " + Utils.getDateToMillis(Utils.getNowDate() + " 00:00");
			if (!Utils.isNull(query.getEtime()))
				term += " and " + timename + " <= " + Utils.getDateToMillis(query.getEtime());
			else
				term += " and " + timename + " <= " + Utils.getDateToMillis(Utils.getNowDate() + " 23:59");
		} else {
			term += " and " + timename + " >= " + Utils.getDateToMillis(Utils.getNowDate() + " 00:00") + " and "
					+ timename + " <= " + Utils.getDateToMillis(Utils.getNowDate() + " 23:59");
		}
		return term;
	}

	public static String getQuerySqlNull(Query query, String timename) {
		String term = "";
		if (query != null) {
			if (!Utils.isNull(query.getStime())&&!"".equals(query.getStime()))
				term += " and " + timename + " >= " + Utils.getDateToMillis(query.getStime());
			else
				term += "";
			if (!Utils.isNull(query.getEtime())&&!"".equals(query.getEtime()))
				term += " and " + timename + " <= " + Utils.getDateToMillis(query.getEtime());
			else
				term += "";
		}
		return term;
	}

	public static String getFileName(String str) {
		String str1 = str;
		str = str.substring(str1.lastIndexOf("/") + 1);
		return str;
	}

	public static String getRstate(String state) {
		String states = "";
		if(Utils.isNull(state)) return  "未收款";
		switch (Integer.valueOf(state)) {
		case 0:
			states = "未收款";
			break;
		case 1:
			states = "已收款";
			break;
		case 2:
			states = "部分收款";
			break;
		case 3:
			states = "已转结";
			break;
		}
		return states;
	}

}