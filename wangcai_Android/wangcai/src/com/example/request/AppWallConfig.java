package com.example.request;

import java.util.ArrayList;

public class AppWallConfig {
	public final static String sg_strMopan =  "mopan";
	public final static String sg_strJupeng = "jupeng";
	public final static String sg_strMiidi = "miidi"; 
	public final static String sg_strDomob = "domob"; 
	public final static String sg_strPunchbox = "punchbox"; 
	public final static String sg_strMobsmar = "mobsmar"; 
	public final static String sg_strLimei = "limei";
	public final static String sg_strYoumi =  "youmi";
    
	
	private final static int sg_nHide = 0;
	private final static int sg_nVisible = 1;
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



