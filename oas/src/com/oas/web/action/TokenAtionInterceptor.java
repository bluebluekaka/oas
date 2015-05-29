package com.oas.web.action;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import com.oas.util.RandomGUIDUtil;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;

public class TokenAtionInterceptor extends AbstractInterceptor {

	public String intercept(ActionInvocation invocation) throws Exception {
		Map<String, Object> session = invocation.getInvocationContext()
				.getSession();
		HttpServletRequest request = ServletActionContext.getRequest();
		String strGUID = RandomGUIDUtil.newGuid();

		// 生成令牌
		String strRequestToken = (String) session.get("request_token"); // 取出会话中的令牌
		String strToken = request.getParameter("token");
		// 页面中的令牌
		if (strRequestToken != null && !strRequestToken.equals(strToken)) {
			// 重复提交，重置令牌 session.put("request_token", strGUID);
			// request.setAttribute("token", strGUID); return "invalidToken";
		}
		session.put("request_token", strGUID);
		request.setAttribute("token", strGUID);
		return invocation.invoke(); // 否则正常运行
	}

}
