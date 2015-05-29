package com.oas.objects;

public class OrderOffset extends BaseOrder{

	private Long offsetId;

	private String offsetIds;
	
	private String customerId;
	
	private Long transferId;
	
	private Float offsetTransferAmounts;
	
	private Float offsetFinancialAmountsAll;
	
	private Float offsetAmounts;
	
	private String financialOrderCodes;
	
	private Float balance;
	
	private String offsetListStr;

	public Long getOffsetId() {
		return offsetId;
	}

	public void setOffsetId(Long offsetId) {
		this.offsetId = offsetId;
	}

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public Long getTransferId() {
		return transferId;
	}

	public void setTransferId(Long transferId) {
		this.transferId = transferId;
	}

	public Float getOffsetTransferAmounts() {
		return offsetTransferAmounts;
	}

	public void setOffsetTransferAmounts(Float offsetTransferAmounts) {
		this.offsetTransferAmounts = offsetTransferAmounts;
	}

	public Float getOffsetFinancialAmountsAll() {
		return offsetFinancialAmountsAll;
	}

	public void setOffsetFinancialAmountsAll(Float offsetFinancialAmountsAll) {
		this.offsetFinancialAmountsAll = offsetFinancialAmountsAll;
	}

	public Float getOffsetAmounts() {
		return offsetAmounts;
	}

	public void setOffsetAmounts(Float offsetAmounts) {
		this.offsetAmounts = offsetAmounts;
	}

	public String getFinancialOrderCodes() {
		return financialOrderCodes;
	}

	public void setFinancialOrderCodes(String financialOrderCodes) {
		this.financialOrderCodes = financialOrderCodes;
	}

	public Float getBalance() {
		return balance;
	}

	public void setBalance(Float balance) {
		this.balance = balance;
	}

	public String getOffsetIds() {
		return offsetIds;
	}

	public void setOffsetIds(String offsetIds) {
		this.offsetIds = offsetIds;
	}

	public String getOffsetListStr() {
		return offsetListStr;
	}

	public void setOffsetListStr(String offsetListStr) {
		this.offsetListStr = offsetListStr;
	}
	
	
	
}
