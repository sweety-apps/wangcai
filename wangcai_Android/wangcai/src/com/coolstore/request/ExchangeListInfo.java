package com.coolstore.request;

import java.util.ArrayList;

public class ExchangeListInfo {
	public static class ExchangeItem {
		ExchangeItem(String strName, int nType, String strIcon, int nPrice, int nRemainCount) {
			m_strName = strName;
			m_nType = nType;
			m_strIconUrl = strIcon;
			m_nPrice = nPrice;
			m_nRemainCount = nRemainCount;
		}
		public String m_strName;
		public int m_nType;
		public String m_strIconUrl;
		public int m_nPrice;
		public int m_nRemainCount;
	}
	
	public void AddExchangeItem(String strName, int nType, String strIcon, int nPrice, int nRemainCount) {
		ExchangeItem item = new ExchangeItem(strName, nType, strIcon, nPrice, nRemainCount);
		m_listExchangeItems.add(item);
	}
	
	public int GetExchangeItemCount() {
		return m_listExchangeItems.size();
	}
	public ExchangeItem GetExchangeItem(int nIndex) {
		if (nIndex < 0 || nIndex >= m_listExchangeItems.size()) {
			return null;
		}
		return m_listExchangeItems.get(nIndex);
	}
	
	private ArrayList<ExchangeItem> m_listExchangeItems = new ArrayList<ExchangeItem>();
}
