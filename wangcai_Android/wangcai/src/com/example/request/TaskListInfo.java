package com.example.request;

import java.util.ArrayList;

public class TaskListInfo {
	public final static int TypeInstallWangcai = 1;				//��װ����
	public final static int TaskTypeUserInfo = 2;				//��д��������
	public final static int TaskTypeInviteFriends = 3;			//��д������
	public final static int TaskTypeEverydaySign = 4;		//ǩ��
	public final static int TaskTypeOfferWall = 5;				//Ӧ����������
	public final static int TaskTypeCommetWangcai = 6;	//��������
	public final static int TaskTypeUpgrade = 7;				//����������LV3
	public final static int TaskTypeShare   = 8;					//ɹ���н�
	public final static int TaskTypeIntallApp = 10000;		//
	public final static int TaskTypeCommon = 10001;		//
	public final static int TaskTypeYoumiEc = 99999;		//

	public static class TaskInfo {
		public int m_nTaskType;
		public int m_nTaskStatus;
		public int m_nId;		
		public int m_nLevel;
		public String m_strTitle;					//�����б��еı���
		public String m_strDescription;		//�����б��еĽ���
		public String m_strIntroduction;		//����󵯳�����ʾ
		public int m_nMoney;					//
		public String m_strIconUrl;				//todo  �еĻ�Ҫ����
		public String m_strRedirctUrl;			//
	}
	
	
	public void AddTaskInfo(TaskInfo taskInfo) {
		m_listTaskInfos.add(taskInfo);
	}
	public int GetTaskCount() {
		return m_listTaskInfos.size();
	}
	public TaskInfo GetTaskInfo(int nIndex) {
		if (nIndex < 0 || nIndex >= m_listTaskInfos.size()) {
			return null;
		}
		return m_listTaskInfos.get(nIndex);
	}
	public TaskInfo GetTaskInfoByType(int nType) {
		for(TaskInfo info : m_listTaskInfos) {
			if (nType == info.m_nTaskType) {
				return info;
			}
		}
		return null;
	}
	public int GetRemainMoneyToday() {
		int nMoney = 0;
		for(TaskInfo info : m_listTaskInfos) {
			if (!IsComplete(info)) {
				nMoney = info.m_nMoney;
			}
		}		
		return nMoney;
	}
	   
	public static boolean IsComplete(TaskInfo taskInfo) {
		return taskInfo.m_nTaskStatus != 0;
	}
			
	
	private ArrayList<TaskInfo> m_listTaskInfos = new ArrayList<TaskInfo>();
}

