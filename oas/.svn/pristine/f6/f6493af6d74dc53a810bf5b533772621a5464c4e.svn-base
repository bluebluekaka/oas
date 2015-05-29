package com.oas.common;

import java.util.Hashtable;

import com.oas.objects.User;


public class DBCache {

	public static int USER_MAX_ID = 0;
	public static int ORDER_MAX_ID = 1;
	
	public static Hashtable<String,User> USER_HASHTABLE = new Hashtable<String, User>();
	
	public static Long getSequence() {
		Long x =(long)(Math.random()*100);
		Long s = System.currentTimeMillis();
		
		return s*100+x;
	}
	
	public static void mian(String[] args){
//		DBCache db = new DBCache();
//		System.out.println(db.getSequence());
	}
	
}
