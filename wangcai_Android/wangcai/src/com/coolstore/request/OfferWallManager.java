package com.coolstore.request;

import java.util.ArrayList;

public class OfferWallManager {
	
	public OfferWallManager() {
	}
	
	public void AddWall(String strName, int nStatus) {
		for (OfferWalls.OfferWall wall : m_listOfferWall) {
			if (wall.GetName().equals(strName)) {
				return;
			}
			
		}
		OfferWalls.OfferWall wall = OfferWalls.NewOfferWall(strName, nStatus);
		if (wall != null) {
			m_listOfferWall.add(wall);
		}
	}
	public int GetWallCount() {
		return m_listOfferWall.size();
	}
	public OfferWalls.OfferWall GetOfferWallInfo(int nIndex) {
		if (nIndex < 0 || nIndex >= m_listOfferWall.size()) {
			return null;
		}
		return m_listOfferWall.get(nIndex);
	}
	
	private ArrayList<OfferWalls.OfferWall> m_listOfferWall = new ArrayList<OfferWalls.OfferWall>();
}






