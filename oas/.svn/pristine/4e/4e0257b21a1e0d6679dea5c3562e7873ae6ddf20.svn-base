package com.oas.util;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

public class StringUtil {
	public static String zeroToStr(String fStr, String lStr) {
		if(fStr.equals("0.00") || fStr.equals("0")) fStr = lStr;
		return fStr;
	}
	
	public static String toString(Object obj) {
		return obj != null ? obj.toString() : "";
	}
	
	public static String toString(Object obj, String str) {
		return obj != null ? obj.toString() : str;
	}
	
	public static String decodeToUtf(Object obj) {
		String reStr = obj != null ? obj.toString() : "";
		String regEx = "[+]";
    	Pattern p = Pattern.compile(regEx);       
    	Matcher m = p.matcher(reStr);
    	reStr = m.replaceAll("��SPSOFT������SPSOFT��");
		try {
			reStr = URLDecoder.decode(reStr, "UTF-8");
			reStr = reStr.replaceAll("��SPSOFT������SPSOFT��", "+");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return reStr;
	}
	
	public static String decodeToUtf(Object obj, String str) {
		String reStr = obj != null ? obj.toString() : str;
		String regEx = "[+]";
    	Pattern p = Pattern.compile(regEx);       
    	Matcher m = p.matcher(reStr);
    	reStr = m.replaceAll("��SPSOFT������SPSOFT��");
		try {
			reStr = URLDecoder.decode(reStr, "UTF-8");
			reStr = reStr.replaceAll("��SPSOFT������SPSOFT��", "+");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return reStr;
	}
	
	public static int toInt(Object obj) {
		String str = obj != null ? obj.toString().trim() : "";
		return "".equals(str) ? 0 : Integer.parseInt(str);
	}
	
	public static int toInt(Object obj, int intStr) {
		String str = obj != null ? obj.toString().trim() : "";
		return "".equals(str) ? intStr : Integer.parseInt(str);
	}
	
	public static double toDouble(Object obj) {
		String str = obj != null ? obj.toString().trim() : "";
		return "".equals(str) ? 0.00 : Double.parseDouble(str);
	}
	
	public static double toDouble(Object obj, double doubleStr) {
		String str = obj != null ? obj.toString().trim() : "";
		return "".equals(str) ? doubleStr : Double.parseDouble(str);
	}
	
	public static String getISOToGBK(String str){
		String strName = "";
		try{
			if(str!=null){
				strName = new String(str.getBytes("ISO8859_1"),"GBK");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return strName;
	}
	
	public static String getISOToUTF8(String str){
		String strName = "";
		try{
			if(str!=null){
				strName = new String(str.getBytes("ISO8859_1"),"UTF8");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return strName;
	}
	
	//��ݲ����ȡ���ֵ����λ��
	public static String getRandom(int num) {
		return (Math.random()+"").substring(2, num + 2);
	}
	
	public static String showTrace() {
    	StackTraceElement[] ste = new Throwable().getStackTrace();
    	StringBuffer CallStack = new StringBuffer();
    	
    	for (int i = 1; i < ste.length; i++) {
    		CallStack.append(ste[i].toString()+ "\n");
    		if (i > 4 ) break;
		}
    	return CallStack.toString();        
    }
	
	public static String checkTableDefKey(String[] key, String[] value, String name) {
		String str = "";
		for(int i=0; i<key.length; i++) {
			if(name.equals(key[i])) {
				str = value[i];
				break;
			}
		}
		return str;
	}
	
	public static boolean isChinese(String str) {
		String regEx = "[\\u4e00-\\u9fa5]";
		Pattern p = Pattern.compile(regEx);
		Matcher m = p.matcher(str);
		return m.find();
	}

	public static String getStrToGbk(String str){
		String strName = "";
		try{
			if(str!=null){
				strName = new String(str.getBytes("UTF-8"), "GBK");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return strName;
	}
	
	public static String getGBKToUTF8(String str){
		String strName = "";
		try{
			if(str!=null){
				strName = new String(str.getBytes("GBK"), "UTF8");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return strName;
	}

	public static int getRowsPan(String reStr, String reName, List list){
		int rowsPan = 0;
		for(int i = 0; i < list.size(); i++){
			Map map = (Map)list.get(i);
			if(reStr.equals(map.get(reName).toString())) rowsPan += 1;
		}
		return rowsPan;
	}
	
	public static int getRowsPan_twoElement(String reStr1, String reName1,String reStr2, String reName2, List list){
		int rowsPan = 0;
		for(int i = 0; i < list.size(); i++){
			Map map = (Map)list.get(i);
			if(reStr1.equals(map.get(reName1).toString())&&reStr2.equals(map.get(reName2).toString())) rowsPan += 1;
		}
		return rowsPan;
	}
	
	public static String toUtf8String(String s) {
		StringBuffer sb = new StringBuffer();
	    for (int i=0;i<s.length();i++) {
	    	char c = s.charAt(i);
	        if (c >= 0 && c <= 255) {
	            sb.append(c);
	        } else {
	            byte[] b;
	            try {
	                b = Character.toString(c).getBytes("utf-8");
	            } catch (Exception ex) {
	                b = new byte[0];
	            }
	            for (int j = 0; j < b.length; j++) {
	                 int k = b[j];
	                 if (k < 0) k += 256;
	                 sb.append("%" + Integer.toHexString(k).
	                 toUpperCase());
	            }
	       }
	    }
	    return sb.toString();
	}
	
	/**
	 * ����sqlע��"'"������
	 * @param str
	 * @return
	 */
	public static String affluxFilter(Object obj){
		String str = obj != null ? obj.toString() : "";
		return str.replaceAll("'", "��");
	}
	
	/**
	 * ����sqlע��"'"������
	 * @param str
	 * @return
	 */
	public static String affluxFilter(Object obj,String defaultValue){
		String str = obj != null ? obj.toString() : defaultValue;
		return str.replaceAll("'", "��");
	}
	
	/**
	 * �������������ַ�
	 * @param str
	 * @return
	 * @throws PatternSyntaxException
	 */
    public static String StringFilter(String str) throws PatternSyntaxException{        
    	String regEx="[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~��@#��%����&*��������+|{}������������������������\"]";
    	Pattern p = Pattern.compile(regEx);       
    	Matcher m = p.matcher(str);       
    	return m.replaceAll("").trim();       
    }
    
    /**
     * �ַ��ʽ���ɻ�Ƹ�ʽ
     * @param str
     * @param scale
     * @return
     */
    public static String toAccountantFormat(String str,  int scale){
    	if (str != null) {
			String temp = "#,###,###,###,##0.";
			for (int i = 0; i < scale; i++) {
				temp += "0";
			}
			return new java.text.DecimalFormat(temp).format(Double.valueOf(str));
		} else {
			return "0.00";
		}
    }
    
    public static void main(String[] args){
    	String reStr = "+";
    	System.out.println("AAA"+reStr);
    	String regEx = "[+]";
    }
}