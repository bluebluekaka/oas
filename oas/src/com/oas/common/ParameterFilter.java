package com.oas.common;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;

public class ParameterFilter implements Filter {

	protected final Logger log = LogManager.getLogger(ParameterFilter.class);

	private long lastaccess = 0;

	public void destroy() {
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest hsr = (HttpServletRequest) request;
		String requrl = hsr.getRequestURI();
		if (requrl.endsWith(".aspx") || requrl.endsWith(".jsp")) {
			if (check(hsr, requrl) == false) {
				response.setContentType("text/html; charset=gbk");   
				response.setCharacterEncoding("utf-8"); 
				PrintWriter pw=response.getWriter();
				String s ="<h1>登陆超时,<a href=\"/oas/logon.jsp\" target=\"_top\">请点击此处重新登陆 </a></h1>"; 
				pw.println(s);
				pw.close();
				return;
			}
		}
		
		chain.doFilter(request, response);
	}

	@SuppressWarnings("unchecked")
	private Boolean check(HttpServletRequest request, String requrl)
			throws IOException, ServletException {
		Boolean secCheck = true;
		if (requrl.startsWith("/oas/pub/")) {
			secCheck = false;
		} else if (requrl.startsWith("/oas/chart/")||requrl.startsWith("/oas/common/")) {
			secCheck = false;
		} else if (requrl.endsWith("/logon.jsp")) {
			Calendar cale = Calendar.getInstance();
			long curr = cale.getTimeInMillis();
			long diff = curr - lastaccess;
			lastaccess = curr;
			if (diff < 1000)
				return false;

			secCheck = false;
		}

		if (secCheck == true) {
			Object user = request.getSession().getAttribute(Config.USER_ID);
			if (user == null) {
				return false;
			}
		}

		request.setCharacterEncoding("GBK");

		Enumeration<String> enu = request.getParameterNames();
		Map<String, String[]> pMap = request.getParameterMap();
		while (enu.hasMoreElements()) {
			String paraName = enu.nextElement();
			String[] value = pMap.get(paraName);
			for (int i = 0; i < value.length; i++) {
				value[i] = filter(value[i]);
			}
		}

		return true;
	}

	public void init(FilterConfig arg0) throws ServletException {
	}

	public String filter(String value) {
		String result = value;
		int pos = value.indexOf("'");
		if (pos != -1) {
			result = value.substring(0, pos);
		}
		return result;
	}
}
