package com.oas.web.json;

import java.net.URLDecoder;

import org.apache.log4j.Logger;

import com.oas.common.Config;
import com.oas.common.DataSourceAction;
import com.oas.common.Utils;
import com.oas.objects.OfferCompany;

public class OfferCompanyJson extends DataSourceAction {
	private static final long serialVersionUID = -5612721881117285900L;
	protected final Logger log = Logger.getLogger(getClass());

	private OfferCompany offer;
	private String sid;
	private String name;
	private String phone;
	private String qq;
	private String man;

	public OfferCompany getOffer() {
		return offer;
	}

	public void setOffer(OfferCompany offer) {
		this.offer = offer;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getQq() {
		return qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}

	public String getMan() {
		return man;
	}

	public void setMan(String man) {
		this.man = man;
	}

	public String execute() throws Exception {
		//		String now_user_id = (String) getSession().getAttribute(Config.USER_ID);
		String now_user_workNo = (String) getSession().getAttribute(Config.USER_WORKNO);
		try {
			if (action != null) {
				skip = SUCCESS;
				if ("add".equals(action)) {
					if (checkName(offer.getName(), null)) {
						sql = "insert into offercompany(name,man,qq,phone,fox,num_code,addr,cmnt,creater,create_time,create_timei,state) values('"
								+ offer.getName()
								+ "','"
								+ offer.getMan()
								+ "','"
								+ offer.getQq()
								+ "','"
								+ offer.getPhone()
								+ "','"
								+ offer.getFox()
								+ "','"
								+ offer.getNum_code()
								+ "','"
								+ offer.getAddr()
								+ "','"
								+ offer.getCmnt()
								+ "','"
								+ now_user_workNo
								+ "','"
								+ Utils.getNowTimestamp()
								+ "',"
								+ Utils.getSystemMillis()
								+ ","
								+ offer.getState()
								+ ")";
						executeUpdate(sql);
						markUserLogs("添加" + offer.getName() + "供应商");
					} else {
						skip = ERROR;
						addActionError("该供应商姓名已经存在");
					}
				} else if ("delete".equals(action)) {//删除判断
					if (!checkUsed(sid)) {
						skip = ERROR;
						addActionError("该供应商有相关订单信息");
					} else {
						sql = "delete from offercompany where id in('" + sid + "')";
						executeUpdate(sql);
						markUserLogs("删除" + sid + "供应商");
					}
				} else if ("change".equals(action)) {
					sql = "select id from offercompany where id="+sid;
					executeQuery(sql);
					if (rs.next()) {
						sql = "update offercompany set name='" + offer.getName() + "',man='" + offer.getMan()
								+ "',qq='" + offer.getQq() + "',phone='" + offer.getPhone() + "',fox='"
								+ offer.getFox() + "',num_code='" + offer.getNum_code() + "',addr='" + offer.getAddr()
								+ "',cmnt='" + offer.getCmnt() + "' where id=" + sid;
						executeUpdate(sql);
						markUserLogs("修改" + offer.getName() + "供应商信息");
					} else {
						skip = ERROR;
						addActionError("该供应商已被删除");
					}
				} else if ("display".equals(action)) {
					sql = "select name,man,qq,phone,fox,num_code,addr,cmnt,id from offercompany where id=" + sid;
					executeQuery(sql);
					if (rs.next()) {
						offer = new OfferCompany();
						offer.setName(rs.getString(1));
						offer.setMan(rs.getString(2));
						offer.setQq(rs.getString(3));
						offer.setPhone(rs.getString(4));
						offer.setFox(rs.getString(5));
						offer.setNum_code(rs.getString(6));
						offer.setAddr(rs.getString(7));
						offer.setCmnt(rs.getString(8));
						offer.setId(rs.getInt(9));
						skip = EDIT;
					} else {
						skip = ERROR;
						addActionError("供应商  " + sid + " not exists");
					}
				} else if ("check".equals(action)) {
					setResult(checkName(offer.getName(), sid));
					skip = CHECK;
				} else if ("data".equals(action)) {
					sql = "select id,name from offercompany where 1=1   order by name";
					executeQuery(sql);
					while (rs.next()) {
						int id = rs.getInt(1);
						String name = rs.getString(2);
						if (count != 0)
							bf.append(",");
						bf.append("{'id':'" + id + "'").append(",'name':'" + name + "'}");
						count++;
					}
					String counts = "总数：" + count;
					tojson(counts);
					skip = DATA;
				}
			} else {
				if(offer!=null) {
					if(!Utils.isNull(offer.getName())) {
					String name0 = URLDecoder.decode(offer.getName(),"UTF-8");
						term += " and name like '%" + name0 + "%'";
					}
					if(!Utils.isNull(offer.getQq())) {
						term += " and qq like '%" + offer.getQq() + "%'";
					}
					if(!Utils.isNull(offer.getMan())) {
						String name1 = URLDecoder.decode(offer.getMan(),"UTF-8");
						term += " and man like '%" + name1 + "%'";
					}
					if(!Utils.isNull(offer.getPhone())) {
						term += " and phone like '%" + offer.getPhone() + "%'";
					}
				}
				skip = JSON;
				sql = "select id,name,man,qq,phone,addr,fox,num_code,creater,cmnt from offercompany where 1=1 " + term
						+ "  order by id";
				executeQuery(sql);
				while (rs.next()) {
					int id = rs.getInt(1);
					String name = rs.getString(2);
					String man = rs.getString(3);
					String qq = rs.getString(4);
					String phone = rs.getString(5);
					String addr = rs.getString(6);
					String fox = rs.getString(7);
					String creater = rs.getString(9);
					String cmnt = rs.getString(10);
					String num_code = rs.getString(8);
					if (count != 0)
						bf.append(",");
					bf.append("{'HideID':'" + id + "'").append(",'供应商名称':'" + name + "'")
							.append(",'联系人':'" + man + "'").append(",'QQ':'" + qq + "'")
							.append(",'联系电话':'" + phone + "'").append(",'传真':'" + fox + "'")
							.append(",'配置号':'" + num_code + "'").append(",'地址':'" + addr + "'")
							.append(",'创建人工号':'" + creater + "'").append(",'备注':'" + cmnt + "'}");
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

	public boolean checkName(String name, String sid) throws Exception {
		sql = "select id from offercompany where name = '" + name + "'";
		executeQuery(sql);
		if (rs.next()) {
			if (!Utils.isNull(sid)) {
				if (sid.equals(rs.getString(1)))
					return true;
			}
			return false;
		}
		return true;
	}

	public boolean checkUsed(String id) throws Exception {
		sql = "select supplier from ordertraveller where supplier ='"+ id+"'";
		executeQuery(sql);
		if (rs.next()) {
			return false;
		}
		return true;
	}

}
