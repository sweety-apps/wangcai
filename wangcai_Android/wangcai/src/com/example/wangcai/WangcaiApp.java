package com.example.wangcai;

import java.util.ArrayList;

public class WangcaiApp {

	public class TaskInfo {
		public int m_nId;
		public int m_nType;
		public String m_strTitle;
		public String m_strHintText;
		public String m_strIcon;
		public boolean m_bComplete;
		public int m_nMoney;
	}
	
	public int GetTaskCount() {
		return m_listTaskInfos.size();
	}
	TaskInfo GetTaskInfo(int nIndex){
		if (nIndex < 0 || nIndex >= m_listTaskInfos.size()) {
			return null;
		}
		return m_listTaskInfos.get(nIndex);
	}
	int GetUserId() {
		return m_nUserId;
	}
	int GetBalance() {
		return m_nBalance;
	}
	int GetTotalIncome() {
		return m_nTotalIncome;
	}
	public int GetTotalOutgo() {
		return m_nTotalOutgo;
	}
	public int GetShareIncome() {
		return m_nShareIncome;
	}
	public int GetRecentIncome() {
		return m_nRecentIncome;
	}
	public boolean CanWithdrawal() {
		return m_bCanWithdrawal;
	}
	public String GetInviter() {
		return m_strInviter;
	}
	public String GetPhoneNumber() {
		return m_strPhoneNumber;
	}

	private ArrayList<TaskInfo> m_listTaskInfos;

	private String m_strInviter;
	private String m_strPhoneNumber;
	
	
	private int m_nUserId = 0;
	private int m_nBalance = 0;
	private int m_nTotalIncome = 0;
	private int m_nTotalOutgo = 0;
	private int m_nShareIncome = 0;
	private int m_nRecentIncome = 0;
	private boolean m_bCanWithdrawal = true;
	
	private String m_strSessionId;
}
