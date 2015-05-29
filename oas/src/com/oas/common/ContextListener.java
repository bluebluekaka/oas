package com.oas.common;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Calendar;
import java.util.Properties;

import javax.servlet.ServletContextEvent;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.web.context.ContextLoaderListener;

public class ContextListener extends ContextLoaderListener implements Runnable {
	protected final Logger log = LogManager.getLogger(getClass());
	private Thread daemon = null;

	public ContextListener() {
	}

	public void contextDestroyed(ServletContextEvent event) {

		super.contextDestroyed(event);
	}

	@Override
	public void contextInitialized(ServletContextEvent event) {
		try {
			if (daemon == null) {
				daemon = new Thread(this);
				daemon.setName("TimerThread");
				daemon.setDaemon(true);
				daemon.start();
			}
			String rootdir = null;
			if (event != null)
				rootdir = event.getServletContext().getRealPath("/");
			if (rootdir == null)
				rootdir = "./";
			else {
				if (!rootdir.endsWith("/") && !rootdir.endsWith("\\"))
					rootdir = rootdir + "/";
			}
			Config.ROOTDIR = rootdir;
			Class<?> claz = Class.forName("org.logicalcobwebs.proxool.configuration.PropertyConfigurator");
			if (claz != null) {
				Method m = claz.getMethod("configure", Properties.class);
				Properties properties = new Properties();
				properties.load(ContextListener.class.getResourceAsStream("/proxool.properties"));

				m.invoke(null, properties);
			}
			setDBCache();
		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		}
		super.contextInitialized(event);
	}

	private void setDBCache() {
		Connection conn = null;
		try {
			conn = Helper.getConnection();
			Statement stmt = conn.createStatement();
			ResultSet rs = null;

			// user max id
			rs = stmt.executeQuery("select max(id) from user");
			if (rs.next())
				DBCache.USER_MAX_ID = rs.getInt(1) + 1;

		} catch (Exception ee) {
			System.out.println("ERRORcode:" + ee.toString());
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (Exception ex) {
				}
			}
		}
	}

	public void dailywork() {
		Connection conn = null;
		try {
			conn = Helper.getConnection();
			Statement stmt = conn.createStatement();
			ResultSet rs = null;
			DBCache.ORDER_MAX_ID = 1;
			rs = stmt.executeQuery("select orderid from orderinfo where id=(select max(id) from orderinfo)");
			if (rs.next()) {
				String s = rs.getString(1);//20130901001
				if ((Utils.getNowDate().replaceAll("-", "")).equals(s.substring(0, 8)))
					DBCache.ORDER_MAX_ID = Integer.valueOf(s.substring(8)) + 1;
			}
		} catch (Exception ee) {
			System.out.println("ERRORcode:" + ee.toString());
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (Exception ex) {
				}
			}
		}
	}

	@Override
	public void run() {
		long t0 = Utils.getDateToMillis(Utils.getNowDate() + " 00:00");//2013-01-01 00:00
		boolean dailywork = false;
		while (true) {
			try {
				Thread.sleep(10001);
				long t1 = Utils.getSystemMillis();
				if (t1 - t0 > 24 * 60 * 60) {
					t0 = t1;
					dailywork = false;
				}

				if (dailywork == false) {
					Calendar cale = Calendar.getInstance();
					int hour = cale.get(Calendar.HOUR_OF_DAY);
					if (hour > 1) {
						dailywork = true;
						dailywork();
					}
				}

			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
	}
}