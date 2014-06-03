package com.coolstore.wangcai.base;

import net.miidiwall.SDK.AdWall;
import net.miidiwall.SDK.IAdWallShowAppsNotifier;
import net.youmi.android.offers.OffersManager;
import android.app.Activity;
import android.content.Context;
import cn.domob.data.OErrorInfo;
import cn.domob.data.OManager;

import com.jpmob.sdk.wall.JupengWallConnector;
import com.jpmob.sdk.wall.JupengWallListener;
import com.punchbox.ads.AdRequest;
import com.punchbox.ads.OfferWallAd;
import com.punchbox.exception.PBException;
import com.punchbox.listener.AdListener;

public class AppWallHelper {
	public static abstract class AppWall {
		AppWall(Activity activity) {
			m_activity = activity;
		}
		public abstract boolean Show();
		
		protected Activity m_activity;
	}
	
	
	public static class DuomengAppWall extends AppWall{
		public DuomengAppWall(Activity activity) {
			super(activity);
		}
		
		public boolean Show() {
	    	if (m_manager == null) {
	    	    final String m_strPublicId = "96ZJ2b8QzehB3wTAwQ"; 
	    	    final String m_strUserId = "domob_test_user";
		    	m_manager = new OManager(m_activity, m_strPublicId, m_strUserId);
		    	m_manager.setAddWallListener(new OManager.AddWallListener() {
					@Override
					public void onAddWallSucess() {
					}
					@Override
					public void onAddWallFailed(OErrorInfo arg0) {						
					}
					@Override
					public void onAddWallClose() {
					}
				});
	    	}
	    	m_manager.loadOfferWall();
			return true;
		}

	    private OManager m_manager;
	}

	public static class YoumiAppWall extends AppWall{
		public YoumiAppWall(Activity activity) {
			super(activity);
		}
		
		public boolean Show() {
	    	OffersManager.getInstance(m_activity).showOffersWall();
			return true;
		}
	}
	

	public static class JupengAppWall extends AppWall{
		public JupengAppWall(Activity activity) {
			super(activity);
		}
		
		public boolean Show() {
	    	if (!ms_bInited) {
	    		ms_bInited = true;
		        JupengWallConnector.getInstance(m_activity).setListener(new JupengWallListener() {
		
		   		@Override
		   		public void dismissAppWall() {
		   		}
		   		@Override
		   		public void getTotalMoneyFail() {
		   		}
		   		@Override
		   		public void getTotalMoneySuccess(Integer arg0) {
		   		}
		   		@Override
		   		public void giveMoneyFail() {
		   		}
		   		@Override
		   		public void giveMoneySuccess(Integer arg0) {
		   		}
		   		@Override
		   		public void monitorMoney(String arg0, String arg1, Integer arg2) {
		   		}
		   		@Override
		   		public void showAppWall() {			
		   		}
		   		@Override
		   		public void spendMoneyFail() {
		   		}
		   		@Override
		   		public void spendMoneySuccess(Integer arg0) {
		   		}});
		        // 设置SDK帐号
		        JupengWallConnector.getInstance(m_activity).startWall("xxxxx", "xxxx");
	    	}
	    	JupengWallConnector.getInstance(m_activity).showOffers();
			return true;
		}
	    private static boolean ms_bInited = false;
	}
	

	public static class MidiAppWall extends AppWall{
		public MidiAppWall(Activity activity) {
			super(activity);
		}
		
		public boolean Show() {
	    	if (!ms_bInited) {
	    		AdWall.init(m_activity, "5", "5555555");
	    	}
	    	AdWall.showAppOffers(new IAdWallShowAppsNotifier() {
				@Override
				public void onDismissApps() {
				}
				@Override
				public void onShowApps() {
				}});
			return true;
		}
	    private static boolean ms_bInited = false;
	}
	

	public static class ChukongAppWall extends AppWall{
		public ChukongAppWall(Activity activity) {
			super(activity);
		}
		
		public boolean Show() {
	    	m_chukongAd = new OfferWallAd(m_activity);
	    	m_chukongAd.setAdListener(new AdListener() {
				@Override
				public void onDismissScreen() {				
				}
				@Override
				public void onFailedToReceiveAd(PBException arg0) {
				}
				@Override
				public void onPresentScreen() {
				}
				@Override
				public void onReceiveAd() {
				}
	    	});
	    	m_chukongAd.loadAd(new AdRequest());
	    	
	        try {
	        	String placementID = "";
	        	m_chukongAd.showFloatView(m_activity, 1.0, placementID);
	        } catch (Exception e) {
	            //当设置的scale不在范围内，或者isReady()属性为false
	        }
			return true;
		}
	    private OfferWallAd m_chukongAd;
	}
}
