package com.coolstore.request;

public class SurveyInfo {
	public boolean IsComplete() {
		return m_nStatus != 0;
	}
	public int m_nId;
	public String m_strTitle;
	public String m_strUrl;
	public int m_nStatus;
	public int m_nMoney;
	public int m_nLevel;
	public String m_strIntroduction;
}
