package com.oas.common;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.security.MessageDigest;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class Utils {
	static final byte[] KEYVALUE = "6^)(9-@=+@j.&6^)(p35@%3%!#O@*GpG0#4S!4S0)$Y%%Y-=+".getBytes();

	static final int BUFFERLEN = 1024;

	public static void encryptFile(InputStream in, String dstFile) throws Exception {
		File file = new File(dstFile);
		if (!file.exists())
			file.createNewFile();
		FileOutputStream out = new FileOutputStream(file);
		int c, pos, keylen;
		pos = 0;
		keylen = KEYVALUE.length;
		byte buffer[] = new byte[BUFFERLEN];
		while ((c = in.read(buffer)) != -1) {
			for (int i = 0; i < c; i++) {
				buffer[i] ^= KEYVALUE[pos];
				out.write(buffer[i]);
				pos++;
				if (pos == keylen)
					pos = 0;
			}
		}
		in.close();
		out.close();
	}

	public static void decryptFile(InputStream in, String dstFile) throws Exception {
		// FileInputStream in = new FileInputStream(srcFile);
		File file = new File(dstFile);
		if (!file.exists())
			file.createNewFile();
		FileOutputStream out = new FileOutputStream(file);
		int c, pos, keylen;
		pos = 0;
		keylen = KEYVALUE.length;
		byte buffer[] = new byte[BUFFERLEN];
		while ((c = in.read(buffer)) != -1) {
			for (int i = 0; i < c; i++) {
				buffer[i] ^= KEYVALUE[pos];
				out.write(buffer[i]);
				pos++;
				if (pos == keylen)
					pos = 0;
			}
		}
		in.close();
		out.close();
	}

	static char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

	public static String getMD5(byte[] binsrc) {
		String s = null;
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(binsrc);
			byte tmp[] = md.digest();
			char str[] = new char[16 * 2];
			int k = 0;
			for (int i = 0; i < 16; i++) {
				byte byte0 = tmp[i];
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf];
			}
			s = new String(str);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return s;
	}

	public static String decode(String str) {
		String[] tmp = str.split(";&#|&#|;");
		StringBuffer sb = new StringBuffer("");

		for (int i = 0; i < tmp.length; i++) {
			if (tmp[i].matches("\\d{5}")) {
				sb.append((char) Integer.parseInt(tmp[i]));
			} else {
				sb.append(tmp[i]);
			}
		}
		return sb.toString();
	}

	public static boolean isNull(String str) {
		if (str == null || "".equals(str) || "null".equals(str))
			return true;
		return false;
	}

	public static long getSystemMillis() {
		long t = System.currentTimeMillis() / 1000;
		return t;
	}

	public static long getDateToMillis(String date) {//2013-10-10 00:00
		long t = 0;
		try {
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			Date d = dateFormat.parse(date);
			t = d.getTime() / 1000;
		} catch (Exception e) {
		}
		return t;
	}

	public static String getNowTimestamp() {
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");// yyyy年MM月dd日HH:mm:ss
		java.util.Date date = new java.util.Date();
		return dateFormat.format(date);
	}

	public static String getNowDate() {
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");// yyyy年MM月dd日HH:mm:ss
		java.util.Date date = new java.util.Date();
		return dateFormat.format(date);
	}

	public static int getNowDateInt() {
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");// yyyy年MM月dd日HH:mm:ss
		java.util.Date date = new java.util.Date();
		return Integer.valueOf(dateFormat.format(date));
	}

	public static int getNowTime() {
		DateFormat dateFormat = new SimpleDateFormat("HHmmss");// yyyy年MM月dd日HH:mm:ss
		java.util.Date date = new java.util.Date();
		return Integer.valueOf(dateFormat.format(date));
	}

	public static String getAddDate(String date, int t) {
		Calendar calendar = Calendar.getInstance();
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		try {
			calendar.setTime(dateFormat.parse(date));
			calendar.set(Calendar.DAY_OF_MONTH, calendar.get(Calendar.DAY_OF_MONTH) + (t));//让日期加1 
		} catch (ParseException e) {
		}
		return dateFormat.format(calendar.getTime());
	}

	public static int getEnligthMonth(String en) {//en = Jan
		int m = 0;
		en = en.toLowerCase();
		if ("january".indexOf(en) != -1) {
			m = 1;
		} else if ("february".indexOf(en) != -1) {
			m = 2;
		} else if ("march".indexOf(en) != -1) {
			m = 3;
		} else if ("april".indexOf(en) != -1) {
			m = 4;
		} else if ("may".indexOf(en) != -1) {
			m = 5;
		} else if ("june".indexOf(en) != -1) {
			m = 6;
		} else if ("july".indexOf(en) != -1) {
			m = 7;
		} else if ("august".indexOf(en) != -1) {
			m = 8;
		} else if ("september".indexOf(en) != -1) {
			m = 9;
		} else if ("october".indexOf(en) != -1) {
			m = 10;
		} else if ("november".indexOf(en) != -1) {
			m = 11;
		} else if ("december".indexOf(en) != -1) {
			m = 12;
		}
		return m;
	}

	public static boolean isNumeric(String str) {
		if (isNull(str))
			return false;
		for (int i = str.length(); --i >= 0;) {
			int chr = str.charAt(i);
			if (chr < 48 || chr > 57)
				return false;
		}
		return true;
	}

	public static boolean isDateBefore(String date1) {
		try {
			String date2 = date1.substring(0, 10) + " 23:59:59";
			DateFormat df = DateFormat.getDateTimeInstance();
			return df.parse(date1).before(df.parse(date2));
		} catch (ParseException e) {
			System.out.print("[SYS] " + e.getMessage());
			return false;
		}
	}

	public static String getPoint(float d, int p) {
		double ps = Math.pow(10, p);
		double b = ((Math.round(d * ps)) / ps);
		String df = b + "";
		int t = df.substring(df.indexOf('.') + 1).length();
		while (p > t) {
			df += "0";
			t++;
		}
		return df;
	}
}
