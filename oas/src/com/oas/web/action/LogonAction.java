package com.oas.web.action;

import com.oas.common.Config;
import com.oas.common.DataSourceAction;
import com.oas.common.Utils;
import com.oas.objects.User;

public class LogonAction extends DataSourceAction {

	private static final long serialVersionUID = -4364047859833772247L;
	private User user;

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@Override
	public String execute() throws Exception {
		String skip = LOGON;
		if (user != null) {
			try {
				sql = "select state,pwd,usertype,phone,id,name,mobile,workcardno from user where uid='" + user.getUid()
						+ "'";
				executeQuery(sql);
				if (rs.next()) {
					String pwd = Utils.getMD5(user.getPwd().getBytes());
					int state = rs.getInt(1);
					if (state == 0) {
						addActionError("该用户已被禁用");
					} else if (!pwd.equals(rs.getString("pwd"))) {
						addActionError("登录帐号或者密码出错");
					} else {
						user.setId(rs.getInt("id"));
						getSession().setAttribute(Config.USER_ID, user.getUid());
						getSession().setAttribute(Config.USER_TYPE, rs.getString("usertype"));
						getSession().setAttribute(Config.USER_NAME, rs.getString("name"));
						getSession().setAttribute(Config.USER_WORKNO, rs.getString("workcardno"));
						String clientIP = getRequest().getRemoteAddr();
						sql = "update user set lastip = '" + clientIP + "',lasttime = '" + Utils.getNowTimestamp()
								+ "' where id= " + user.getId();
						stmt.executeUpdate(sql);
						skip = SUCCESS;
						markUserLogs("登陆系统");
					}
				} else {
					addActionError(user.getUid() + " is not exist");
				}
			} catch (Exception e) {
				addActionError(e.toString() + " sql=" + sql);
			} finally {
				closeConnection();
			}
		}
		return skip;
	}
}
