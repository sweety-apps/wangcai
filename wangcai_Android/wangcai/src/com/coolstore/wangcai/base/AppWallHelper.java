package com.coolstore.wangcai.base;

import net.miidiwall.SDK.AdWall;
import net.miidiwall.SDK.IAdWallShowAppsNotifier;
import net.youmi.android.offers.OffersManager;
import android.app.Activity;
import cn.waps.AppConnect;

import com.coolstore.common.Config;
import com.punchbox.ads.AdRequest;
import com.punchbox.ads.OfferWallAd;
import com.punchbox.exception.PBException;
import com.punchbox.listener.AdListener;


//����. ����  ���� ���� �׵�  ����

public class AppWallHelper {
	public static abstract class AppWall {
		AppWall(Activity activity) {
			m_activity = activity;
		}
		public abstract boolean Show();
		
		protected Activity m_activity;
	}
	
	//==========================================	
	//					����
	public static class YoumiAppWall extends AppWall{
		public YoumiAppWall(Activity activity) {
			super(activity);
		}
		
		public boolean Show() {
	    	OffersManager.getInstance(m_activity).showOffersWall();
			return true;
		}
	}



	//==========================================	
	//����			done
	public static class WanpuAppWall extends AppWall{
		public WanpuAppWall(Activity activity) {
			super(activity);
		}

		public boolean Show() {
			AppConnect.getInstance(m_activity).showOffers(m_activity);			
			return true;
		}
	}


	//==========================================	
	//					�׵�		DONE
	public static class MidiAppWall extends AppWall{
		public MidiAppWall(Activity activity) {
			super(activity);
		}		
		public boolean Show() {
	    	if (!ms_bInited) {
	    		AdWall.init(m_activity, "18194", "l83il64am89r9y6b");
	    		AdWall.setUserActivity(m_activity, "com.coolstore.wangcai.activity.MidiActivity");	    		
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
	

	//==========================================	
	//					����
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
				public void onPresentScreen() {
				}
				@Override
				public void onReceiveAd() {
				}
				@Override
				public void onFailedToReceiveAd(PBException arg0) {					
				}
	    	});
	    	m_chukongAd.loadAd(new AdRequest());
	    	
	        try {
	        	m_chukongAd.showFloatView(m_activity, 1.0, Config.sg_strPunchboxPlacementId);
	        } catch (Exception e) {
	            //�����õ�scale���ڷ�Χ�ڣ�����isReady()����Ϊfalse
	        	e.printStackTrace();
	        }
			return true;
		}
	    private OfferWallAd m_chukongAd;
	}
	

	/*
	//==========================================	
	//����
	public static class AnwoAppWall extends AppWall{
		public AnwoAppWall(Activity activity) {
			super(activity);
		}

		public boolean Show() {
			if (m_appOffer == null) {
				m_appOffer = ZkmmAppOffer.getInstance(m_activity, "922e6a63999b44248ef387e1d1ab4ab4");
			}
			m_appOffer.showOffer(m_activity);	
			return true;
		}

		ZkmmAppOffer m_appOffer = null;
	}
	
	//==========================================	
	//					����		ֹͣ����
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



	//==========================================	
	//					���� DONE  <��Ҫ��>
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
		        // ����SDK�ʺ�
		        JupengWallConnector.getInstance(m_activity).startWall("10395", "r5e3faf152qoy5ax");
	    	}
	    	JupengWallConnector.getInstance(m_activity).showOffers();
			return true;
		}
	    private static boolean ms_bInited = false;
	}


	//==========================================	
	//					ĥ��---�����ܰ�׿��׬
	public static class MopanAppWall extends AppWall{
		public MopanAppWall(Activity activity) {
			super(activity);
		}
		
		public boolean Show() {
			if (!m_bInited) {
				MopanWallManager.getInstance(m_activity).startMopanWall("12815", "9028ao9hjys6owmn");
			}
			
			MopanWallManager.getInstance(m_activity).showAppWall();
			return true;
		}
		
		private static  boolean m_bInited = false;
	}
	*/
}
