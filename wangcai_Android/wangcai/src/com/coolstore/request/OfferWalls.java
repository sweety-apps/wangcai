package com.coolstore.request;

import net.miidiwall.SDK.AdWall;
import net.miidiwall.SDK.IAdWallShowAppsNotifier;
import net.youmi.android.AdManager;
import net.youmi.android.offers.OffersManager;
import android.app.Activity;
import cn.waps.AppConnect;

import com.coolstore.common.Config;
import com.coolstore.wangcai.WangcaiApp;
import com.dlnetwork.Dianle;
import com.punchbox.ads.AdRequest;
import com.punchbox.ads.OfferWallAd;
import com.punchbox.exception.PBException;
import com.punchbox.listener.AdListener;
import com.zkmm.appoffer.ZkmmAppOffer;


//����. ����  ���� ���� �׵�  ����


public class OfferWalls {

	public final static String sg_strMopan =  "mopan";			//ĥ��	<������׿��׬��>
	public final static String sg_strJupeng = "jupeng";			//����	<��С,ֹͣ����>
	public final static String sg_strMiidi = "miidi"; 					//�׵�
	public final static String sg_strDomob = "domob";			//���� 	<ֹͣ����>
	public final static String sg_strPunchbox = "punchbox"; 	//����	<������>
	public final static String sg_strMobsmar = "mobsmar";	 	//ָ��
	public final static String sg_strLimei = "limei";					//����
	public final static String sg_strYoumi = "youmi";				//����	
	public final static String sg_strAnwo =  "anwo";				//����		<������>
	public final static String sg_strWanpu =  "wanpu";			//����	
	public final static String sg_strWinAds =  "winads";			//WinAds	<������>
	public final static String sg_strDianLe =  "dianle";				//����
	

	public static abstract class OfferWall {
		protected final static int sg_nHide = 0;
		protected final static int sg_nVisible = 1;
		protected final static int sg_nRecommand = 2;
		protected final static int sg_nInMorePanel = 3;

		public void Init(String strName, int nStatus) {
			m_strName = strName;
			m_nStatus = nStatus;
		}
		
		public boolean Show(Activity activityParent) {
			if (!m_bInit) {
				m_bInit = true;
				Init(activityParent);
			}
			return true;
		}
		protected void Init(Activity activity) {			
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
		public String GetName() {
			return m_strName;
		}
		
		protected String GetUserId() {
			return WangcaiApp.GetInstance().GetUserInfo().GetDeviceId();
		}
		
		protected String m_strName;
		protected int m_nStatus = 0;
		protected boolean m_bInit = false;
	}
	
	public static OfferWall NewOfferWall(String strName, int nStatus) {
		OfferWall offerWall = null;
		if (sg_strYoumi.equals(strName)) {
			offerWall = new YoumiOfferWall();
		}
		else if (sg_strMiidi.equals(strName)) {
			offerWall = new MidiOfferWall();
		}
		else if (sg_strWanpu.equals(strName)) {
			offerWall = new WanpuOfferWall();
		}
		else if (sg_strDianLe.equals(strName)) {
			offerWall = new DianLeOfferWall();
		}
		else if (sg_strPunchbox.equals(strName)) {
			offerWall = new ChukongOfferWall();
		}
		else if (sg_strWinAds.equals(strName)) {
			offerWall = new WinAdsOfferWall();
		}
		else if (sg_strAnwo.equals(strName)) {
			offerWall = new AnwoOfferWall();
		}
		else {
			return null;
		}
		offerWall.Init(strName, nStatus);
		return offerWall;
	}
	
	//==========================================	
	//					����
	public static class YoumiOfferWall extends OfferWall{		
		@Override
		protected void Init(Activity activity) {
	        AdManager.getInstance(activity).init(Config.sg_strYoumiAppId, Config.sg_strYoumiAppSecret, false);
	        AdManager.getInstance(activity).setEnableDebugLog(false);
	        
	        OffersManager.getInstance(activity).setCustomUserId(GetUserId());
			OffersManager.getInstance(activity).onAppLaunch();
		}
		@Override
		public boolean Show(Activity activityParent) {
			super.Show(activityParent);
	    	OffersManager.getInstance(activityParent).showOffersWall();
			return true;
		}
	}



	//==========================================	
	//����			done
	public static class WanpuOfferWall extends OfferWall{	
		@Override
		public boolean Show(Activity activityParent) {
			super.Show(activityParent);
			AppConnect.getInstance(activityParent).showAppOffers(activityParent, GetUserId());
			//AppConnect.getInstance(m_activity).showOffers(m_activity);			
			return true;
		}
	}


	//==========================================	
	//					�׵�		DONE
	public static class MidiOfferWall extends OfferWall{
		@Override
		protected void Init(Activity activity) {
    		//AdWall.init(activity, "18194", "l83il64am89r9y6b");
    		AdWall.init(activity, Config.sg_strMidiPublishId, Config.sg_strMidiAppSecret);
    		AdWall.setUserActivity(activity, "com.coolstore.wangcai.activity.MidiActivity");
    		AdWall.setUserParam(GetUserId());			
		}
		@Override
		public boolean Show(Activity activityParent) {
			super.Show(activityParent);

	    	AdWall.showAppOffers(new IAdWallShowAppsNotifier() {
				@Override
				public void onDismissApps() {
				}
				@Override
				public void onShowApps() {
				}});
			return true;
		}
	}
	

	//==========================================	
	//					����
	public static class ChukongOfferWall extends OfferWall{		
		public boolean Show(Activity activityParent) {
			super.Show(activityParent);
			
	    	m_chukongAd = new OfferWallAd(activityParent);
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
	        	m_chukongAd.showFloatView(activityParent, 1.0, Config.sg_strPunchboxPlacementId);
	        } catch (Exception e) {
	            //�����õ�scale���ڷ�Χ�ڣ�����isReady()����Ϊfalse
	        	e.printStackTrace();
	        }
			return true;
		}
	    private OfferWallAd m_chukongAd;
	}
	

	//==========================================	
	//����
	public static class DianLeOfferWall extends OfferWall{
		@Override
		protected void Init(Activity activity) {
			Dianle.setCurrentUserID(activity, GetUserId());
			Dianle.initGoogleContext(activity, Config.sg_strDianleAppId);//"a903aa22facdfe9af70d7259791bbe92");	
		}
		@Override
		public boolean Show(Activity activityParent) {
			super.Show(activityParent);

			Dianle.showOffers(activityParent);
			return true;
		}
	}
	
	//==========================================	
	//WinAds
	public static class WinAdsOfferWall extends OfferWall {
		@Override
		protected void Init(Activity activity) {
			ztxi.fxmi.plhr.offers.AdManager.setUserID(activity, GetUserId());
			ztxi.fxmi.plhr.offers.AdManager.setPointUnit(activity, "���");
			ztxi.fxmi.plhr.offers.AdManager.init(activity);

		}
		public boolean Show(Activity activityParent) {
			super.Show(activityParent);

			ztxi.fxmi.plhr.offers.AdManager.showAdOffers(activityParent);
			return true;
		}
	}
	
	//==========================================	
	public static class AnwoOfferWall extends OfferWall{
		public boolean Show(Activity activityParent) {
			if (m_appOffer == null) {
				m_appOffer = ZkmmAppOffer.getInstance(activityParent, "922e6a63999b44248ef387e1d1ab4ab4");
			}
			m_appOffer.showOffer(activityParent);
			return true;
		}

		ZkmmAppOffer m_appOffer = null;
	}
	
	/*
	//==========================================	
	//					����		ֹͣ����
	public static class DuomengOfferWall extends OfferWall{		
		public boolean Show(Activity activityParent) {
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
	public static class JupengOfferWall extends OfferWall{
		public boolean Show(Activity activityParent) {
	    	if (!ms_bInited) {
	    		ms_bInited = true;
		        JupengWallConnector.getInstance(m_activity).setListener(new JupengWallListener() {
		
		   		@Override
		   		public void dismissOfferWall() {
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
		   		public void showOfferWall() {			
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
	public static class MopanOfferWall extends OfferWall{
		
		public boolean Show(Activity activityParent) {
			if (!m_bInited) {
				MopanWallManager.getInstance(m_activity).startMopanWall("12815", "9028ao9hjys6owmn");
			}
			
			MopanWallManager.getInstance(m_activity).showOfferWall();
			return true;
		}
		
		private static  boolean m_bInited = false;
	}
	*/
}
