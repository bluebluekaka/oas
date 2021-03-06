package com.oas.web.json;

import org.apache.log4j.Logger;

import com.oas.common.Config;
import com.oas.common.DBCache;
import com.oas.common.DataSourceAction;
import com.oas.common.Helper;
import com.oas.common.Utils;
import com.oas.objects.User;

public class UserJson extends DataSourceAction {
	private static final long serialVersionUID = -5612721889737285900L;
	protected final Logger log = Logger.getLogger(getClass());

	private User user;
	private String sid;
	private String uid;
	private String name;
	private String mobile;
	private String qq;

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getQq() {
		return qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Logger getLog() {
		return log;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String execute() throws Exception {
		String now_user_id = (String) getSession().getAttribute(Config.USER_ID);
//		String now_user_workNo = (String) getSession().getAttribute(Config.USER_WORKNO);
		try {
			if (action != null) {
				skip = SUCCESS;
				if ("add".equals(action)) {
					String pwd = Utils.getMD5(user.getPwd().getBytes());
					sql = "insert into user(id,uid,name,pwd,email,state,usertype,phone,mobile,cmnt,leaderid,workcardno,sex,qq,address,birthday) values("
							+ DBCache.USER_MAX_ID
							+ ",'"
							+ user.getUid().trim()
							+ "','"
							+ user.getName().trim()
							+ "','"
							+ pwd
							+ "','"
							+ user.getEmail()
							+ "',"
							+ user.getState()
							+ ","
							+ user.getUsertype()
							+ ",'"
							+ user.getPhone()
							+ "','"
							+ user.getMobile()
							+ "','"
							+ user.getCmnt()
							+ "','"
							+ user.getLeaderid()
							+ "','"
							+ user.getWorkcardno().trim()
							+ "','"
							+ user.getSex()
							+ "','"
							+ user.getQq() + "','" + user.getAddress() + "','" + user.getBirthday() + "')";
					executeUpdate(sql);
					DBCache.USER_MAX_ID++;
					markUserLogs("添加" + user.getUid() + "用户");
				} else if ("delete".equals(action)) {//删除判断
					if (sid.equals(now_user_id)) {
						skip = ERROR;
						addActionError("不能删除自己");
					} else if (this.checkExistCutomer(sid)) {
						skip = ERROR;
						addActionError("该用户下有相关客户信息");
					} else if (this.checkExistOrder(sid)) {
						skip = ERROR;
						addActionError("该用户下有相关订单信息");
					} else {
						sql = "delete from user where uid in('" + sid + "')";
						executeUpdate(sql);
						markUserLogs("删除" + sid + "用户");
					}
				} else if ("forbid".equals(action)) {
					if (sid.equals(now_user_id)) {
						skip = ERROR;
						addActionError("不能禁用自己");
					} else {
						sql = "update user set state =0 where uid ='" + sid + "'";
						executeUpdate(sql);
						markUserLogs("禁用" + sid + "用户");
					}
				} else if ("change".equals(action)) {
					if (!Utils.isNull(user.getPwd())) {
						term = ", pwd = '" + Utils.getMD5(user.getPwd().getBytes()) + "'";
						markUserLogs("修改" + user.getWorkcardno() + "用户密码");
					}
					sql = "update user set name='" + user.getName() + "'" + ",email='" + user.getEmail() + "',uid='" + user.getUid() + "'"
							+ ",state=" + user.getState() + ",usertype=" + user.getUsertype() + ",phone='"
							+ user.getPhone() + "'" + ",mobile='" + user.getMobile() + "'" + ",cmnt='" + user.getCmnt()
							+ "',leaderid='" + user.getLeaderid() + "'" + ",workcardno='" + user.getWorkcardno()
							+ "',sex='" + user.getSex() + "'" + ",qq='" + user.getQq() + "'" + ",address='"
							+ user.getAddress() + "'" + ",birthday='" + user.getBirthday() + "'" + term
							+ " where workcardno = '" + user.getWorkcardno() + "'";
					executeUpdate(sql);
					markUserLogs("修改" + user.getWorkcardno() + "用户信息");
				} else if ("display".equals(action)) {
					sql = "select name,id,email,state,usertype,phone,mobile,cmnt,leaderid ,workcardno,sex,qq,address,birthday from user where state!=2 and uid = '"
							+ sid + "'";
					executeQuery(sql);
					if (rs.next()) {
						User user = new User();
						user.setUid(sid);
						user.setName(rs.getString(1));
						user.setGid(rs.getInt(2));
						user.setEmail(rs.getString(3));
						user.setState(rs.getInt(4));
						user.setUsertype(rs.getInt(5));
						user.setPhone(rs.getString(6));
						user.setMobile(rs.getString(7));
						user.setCmnt(rs.getString(8));
						user.setLeaderid(rs.getString(9));
						user.setWorkcardno(rs.getString("workcardno"));
						user.setSex(rs.getString("sex"));
						user.setQq(rs.getString("qq"));
						user.setAddress(rs.getString("address"));
						user.setBirthday(rs.getString("birthday"));
						this.user = user;
						skip = EDIT;
					} else {
						skip = ERROR;
						addActionError("Reason:  " + sid + " not exists");
					}
				} else if ("check".equals(action)) {
					String old = (String)getRequest().getParameter("old");
					sql = "select uid from user where uid = '" + user.getUid() + "'";
					System.out.println("sss="+old);
					if(!Utils.isNull(old)){
						if(!old.equals(user.getUid())){
							executeQuery(sql);
							if (rs.next()) {
								setResult(false);
							}
						}
					}else {
						executeQuery(sql);
						if (rs.next()) {
							setResult(false);
						}
					}
					skip = CHECK;
				} else if ("checkCardno".equals(action)) {
					sql = "select workcardno from user where workcardno = '" + user.getWorkcardno() + "'";
					executeQuery(sql);
					if (rs.next()) {
						setResult(false);
					}
					skip = CHECK;

				}
			} else {
				if (user != null && !Utils.isNull(user.getUid())) {
					term = " and uid like '%" + user.getUid() + "%'";
				}
				if (user != null && !Utils.isNull(user.getName())) {
					term = " and name like '%" + user.getName() + "%'";
				}
				if (user != null && !Utils.isNull(user.getMobile())) {
					term = " and mobile like '%" + user.getMobile() + "%'";
				}
				if (user != null && !Utils.isNull(user.getQq())) {
					term = " and qq like '%" + user.getQq() + "%'";
				}
				skip = JSON;
				sql = "select uid,name,id,state,usertype,phone,mobile,lastip,lasttime,email,leaderid,workcardno ,sex,qq,address,birthday from user where 1=1 and state!=2 "
						+ term + "  order by id";
				executeQuery(sql);
				while (rs.next()) {
					String phone = rs.getString(6);
					String mobile = rs.getString(7);
					String email = rs.getString(10);
					//					String leaderid=rs.getString("leaderid");
					String workcardno = rs.getString("workcardno");
					String sex = rs.getString("sex");
					String qq = rs.getString("qq");
					String address = rs.getString("address");
					String birthday = rs.getString("birthday");
					String ip = rs.getString(8);
					String time = rs.getDate(9) + "";
					if (Utils.isNull(phone))
						phone = "-";
					if (Utils.isNull(qq))
						qq = "-";
					if (Utils.isNull(mobile))
						mobile = "-";
					if (Utils.isNull(email))
						email = "-";
					if (Utils.isNull(address))
						address = "-";
					if (Utils.isNull(ip)) {
						ip = "-";
						time = "-";
					}
					if (sex.equals("1")) {
						sex = "男";
					} else {
						sex = "女";
					}
					if (count != 0)
						bf.append(",");
					bf.append("{'HideID':'" + rs.getString(1) + "'").append(",'登陆ID':'" + rs.getString(1) + "'")
							.append(",'姓名':'" + rs.getString(2) + "'").append(",'工卡号':'" + workcardno + "'")
							.append(",'性别':'" + sex + "'").append(",'QQ号':'" + qq + "'")
							.append(",'生日':'" + birthday + "'").append(",'工作电话':'" + mobile + "'")
							.append(",'手机号':'" + phone + "'").append(",'地址':'" + address + "'")
							.append(",'状态':'" + Helper.getUseState(rs.getInt(4)) + "'")
							.append(",'权限':'" + Helper.getUserType(rs.getInt(5)) + "'")
							.append(",'最近登录IP':'" + ip + "'").append(",'邮箱':'" + email + "'")
							.append(",'最近登录时间':'" + time + "'}");
					count++;
				}
				String counts = "总数：" + count;
				tojson(counts);
			}
		} catch (Exception e) {
			skip = ERROR;
			addActionError(e.toString());
			System.out.println(e.toString());
		} finally {
			closeConnection();
		}
		return skip;
	}
	
}
