package com.coolstore.request;

import java.util.ArrayList;

public class AppWallConfig {
	public final static String sg_strMopan =  "mopan";			//磨盘	<不允许安卓网赚类>
	public final static String sg_strJupeng = "jupeng";			//巨鹏	<量小,停止合作>
	public final static String sg_strMiidi = "miidi"; 					//米迪
	public final static String sg_strDomob = "domob";			//多盟 	<停止合作>
	public final static String sg_strPunchbox = "punchbox"; 	//触控
	public final static String sg_strMobsmar = "mobsmar";	 	//指盟
	public final static String sg_strLimei = "limei";					//力美
	public final static String sg_strYoumi =  "youmi";				//有米	
	public final static String sg_strAnwo =  "anwo";				//安沃
	public final static String sg_strWanpu =  "wanpu";			//万普
	
	private final static int sg_nHide = 0;
	//private final static int sg_nVisible = 1;
	private final static int sg_nRecommand = 2;
	private final static int sg_nInMorePanel = 3;
	
	public static class AppWallInfo {
		public AppWallInfo(String strName, int nStatus) {
			m_strName = strName;
			m_nStatus = nStatus;
		}
		public String GetName() {
			return m_strName;
		}
		public boolean IsVisible() {
			return m_nStatus != sg_nHide;
		}
		public boolean IsRecommand() {
			return m_nStatus == sg_nRecommand;
		}
		public boolean IsInMorePanel() {
			return m_nStatus == sg_nInMorePanel;
		}
		private String m_strName;
		private int m_nStatus;
	}
	
	public AppWallConfig() {
	}
	
	public void AddWall(String strName, int nStatus) {
		m_listWallInfos.add(new AppWallInfo(strName, nStatus));
	}
	public int GetWallCount() {
		return m_listWallInfos.size();
	}
	public AppWallInfo GetAppWallInfo(int nIndex) {
		if (nIndex < 0 || nIndex >= m_listWallInfos.size()) {
			return null;
		}
		return m_listWallInfos.get(nIndex);
	}
	
	private ArrayList<AppWallInfo> m_listWallInfos = new ArrayList<AppWallInfo>();
}






