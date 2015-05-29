package com.oas.objects;

public class OrderQuery extends Query{
	private int type;
	private int producttype;
	private String productname;
	private String userid;
	private String username;
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public int getProducttype() {
		return producttype;
	}
	public void setProducttype(int producttype) {
		this.producttype = producttype;
	}
	public String getProductname() {
		return productname;
	}
	public void setProductname(String productname) {
		this.productname = productname;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}

}
