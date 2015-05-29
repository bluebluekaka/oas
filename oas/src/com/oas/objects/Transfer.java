package com.oas.objects;

public class Transfer extends BaseOrder {

	private Long transferId;

	private String transferIds;
	
	private String customerId;
	
	private String transferAccount;
	
	private Float transferAmount;
	
	private String remark;

	private String orderCodes;
	
	private Float paymoneys;
	
	private Float recmoneys;
	
	private Integer transferState;
	
	private Integer transferSubmitState;
	
	private Integer transferType;
	
	private String transferTypeName;
	
	private Float usableAmount;
	
	private Integer usableState;
	
	private Integer state;

	public Long getTransferId() {
		return transferId;
	}

	public void setTransferId(Long transferId) {
		this.transferId = transferId;
	}

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public String getTransferAccount() {
		return transferAccount;
	}

	public void setTransferAccount(String transferAccount) {
		this.transferAccount = transferAccount;
	}

	public Float getTransferAmount() {
		return transferAmount;
	}

	public void setTransferAmount(Float transferAmount) {
		this.transferAmount = transferAmount;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getOrderCodes() {
		return orderCodes;
	}

	public void setOrderCodes(String orderCodes) {
		this.orderCodes = orderCodes;
	}

	public String getTransferIds() {
		return transferIds;
	}

	public void setTransferIds(String transferIds) {
		this.transferIds = transferIds;
	}

	public Float getPaymoneys() {
		return paymoneys;
	}

	public void setPaymoneys(Float paymoneys) {
		this.paymoneys = paymoneys;
	}

	public Integer getTransferState() {
		return transferState;
	}

	public void setTransferState(Integer transferState) {
		this.transferState = transferState;
	}

	public Float getRecmoneys() {
		return recmoneys;
	}

	public void setRecmoneys(Float recmoneys) {
		this.recmoneys = recmoneys;
	}

	public Integer getTransferSubmitState() {
		return transferSubmitState;
	}

	public void setTransferSubmitState(Integer transferSubmitState) {
		this.transferSubmitState = transferSubmitState;
	}

	public Integer getTransferType() {
		return transferType;
	}

	public void setTransferType(Integer transferType) {
		this.transferType = transferType;
	}

	public Float getUsableAmount() {
		return usableAmount;
	}

	public void setUsableAmount(Float usableAmount) {
		this.usableAmount = usableAmount;
	}

	public String getTransferTypeName() {
		return transferTypeName;
	}

	public void setTransferTypeName(String transferTypeName) {
		this.transferTypeName = transferTypeName;
	}

	public Integer getUsableState() {
		return usableState;
	}

	public void setUsableState(Integer usableState) {
		this.usableState = usableState;
	}

	public Integer getState() {
		return state;
	}

	public void setState(Integer state) {
		this.state = state;
	}
	
	
}
