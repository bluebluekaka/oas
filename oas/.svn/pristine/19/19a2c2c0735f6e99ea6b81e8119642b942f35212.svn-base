package com.oas.web.json;

import org.apache.log4j.Logger;

import com.oas.common.DataSourceAction;
import com.oas.common.Helper;
import com.oas.common.Utils;
import com.oas.objects.Query;

public class UserLogsJson extends DataSourceAction {
	private static final long serialVersionUID = -5612721889737285900L;
	protected final Logger log = Logger.getLogger(getClass());

	private Query query;
	private String sid;

	public Query getQuery() {
		return query;
	}

	public void setQuery(Query query) {
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
			
			term = Helper.getQuerySql(query, "lasttimei");

			if (!Utils.isNull(sid)) {
				term += " and userid like '%" + sid + "%'";
			}
			skip = JSON;
			sql = "select userid,lasttime,cmnt from userlogs where 1=1 " + term + "  order by id";
			executeQuery(sql);
			while (rs.next()) {
				String userid = rs.getString(1);
				String date = rs.getDate(2)+"";
				String time = rs.getTime(2)+"";
				String cmnt = rs.getString(3);
				if (count != 0)
					bf.append(",");
				bf.append("{'HideID':'" + userid + "'").append(",'日期':'" + date + "'")
						.append(",'操作时间':'" + time + "'").append(",'用户':'" + userid + "'")
						.append(",'操作内容':'" + cmnt + "'}");
				count++;
			}
			String counts = "总数：" + count;
			tojson(counts);
		} catch (Exception e) {
			skip = ERROR;
			addActionError(e.toString());
		} finally {
			closeConnection();
		}
		return skip;
	}
}
