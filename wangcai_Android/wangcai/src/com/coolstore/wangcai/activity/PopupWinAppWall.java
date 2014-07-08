package com.coolstore.wangcai.activity;

import java.util.ArrayList;

import net.miidiwall.SDK.AdWall;
import net.miidiwall.SDK.IAdWallShowAppsNotifier;
import net.youmi.android.offers.OffersManager;

import com.coolstore.request.AppWallConfig;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.AppWallHelper;
import com.punchbox.ads.AdRequest;
import com.punchbox.ads.OfferWallAd;
import com.punchbox.exception.PBException;
import com.punchbox.listener.AdListener;

import android.app.ActionBar.LayoutParams;
import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.text.Html;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.Display;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class PopupWinAppWall extends PopupWindow implements OnClickListener{
	
    public PopupWinAppWall(Activity holderActivity) {  
        super(holderActivity);
        m_ownerActivity = holderActivity;
        LayoutInflater inflater = (LayoutInflater) holderActivity  
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        m_appWin = inflater.inflate(R.layout.win_app_wall, null);  

        this.setContentView(m_appWin);
        WindowManager wm = (WindowManager) holderActivity.getSystemService(Context.WINDOW_SERVICE);  
        Display display = wm.getDefaultDisplay();
        this.setWidth(display.getWidth() + 0);  
        this.setHeight(display.getHeight() + 0); 
        this.setFocusable(true); 
        AppWallConfig appWallConfig = WangcaiApp.GetInstance().GetAppWallConfig();
        if (appWallConfig != null) {
        	InitView(appWallConfig);
        }
        
        AttachEvents();
    }  
    
    private void InitView(AppWallConfig appWallConfig) {
    	ViewGroup defaultPanel = (ViewGroup)m_appWin.findViewById(R.id.app_wall_button_container);
    	ViewGroup morePanel = (ViewGroup)m_appWin.findViewById(R.id.more_panel_button_container);

    	String strText = m_ownerActivity.getString(R.string.app_wall_win_text);
    	CharSequence charSequence = Html.fromHtml(strText);
    	TextView textView = (TextView)m_appWin.findViewById(R.id.text);
    	textView.setText(charSequence);
    	
        //创建按钮
        Resources res = m_ownerActivity.getResources();
        int nTopMargin = res.getDimensionPixelSize(R.dimen.offer_wall_button_margin);
 
        ArrayList<AppWallConfig.AppWallInfo> listAppWallInfo = new ArrayList<AppWallConfig.AppWallInfo>();
        listAppWallInfo.add(new AppWallConfig.AppWallInfo(AppWallConfig.sg_strWanpu, 1));
        listAppWallInfo.add(new AppWallConfig.AppWallInfo(AppWallConfig.sg_strYoumi, 1));
        listAppWallInfo.add(new AppWallConfig.AppWallInfo(AppWallConfig.sg_strMiidi, 3));
        listAppWallInfo.add(new AppWallConfig.AppWallInfo(AppWallConfig.sg_strAnwo, 3));
        
        int nLastId1 = 0, nLastId2 = 0;
    	int nCount = appWallConfig.GetWallCount();
    	nCount = listAppWallInfo.size();
    	for (int i = 0; i < nCount; ++i) {
    		AppWallConfig.AppWallInfo info = listAppWallInfo.get(i);
    		if (!info.IsVisible()) {
    			continue;
    		}
			WallInfo wallInfo = GetWallInfo(info.GetName());
			if (wallInfo == null) {
				continue;
			}
			boolean bIsRecommand = info.IsRecommand();
			wallInfo.SetReommand(bIsRecommand);

	        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(
	        		res.getDimensionPixelSize(R.dimen.app_wall_button_width), res.getDimensionPixelSize(R.dimen.app_wall_button_height));
	        layoutParams.setMargins(0, nTopMargin, 0, 0);
	        
			Button button = CreateButton(wallInfo);
    		if (info.IsInMorePanel()) {
    			if (nLastId2 != 0) {
    				layoutParams.addRule(RelativeLayout.BELOW, nLastId2);
    			}
    			nLastId2 = wallInfo.m_nId;
    			morePanel.addView(button,  layoutParams);
    			if (bIsRecommand) {
    				SetRecommand(morePanel, button);		//推荐
    			}
    		}
    		else {
    			if (nLastId1 != 0) {
    				layoutParams.addRule(RelativeLayout.BELOW, nLastId1);
    			}
    			nLastId1 = wallInfo.m_nId;
    			defaultPanel.addView(button,  layoutParams);
    			if (bIsRecommand) {
    				SetRecommand(defaultPanel, button);		//推荐
    			}
    		}    		
			
    		button.setOnClickListener(this);
			m_listViisibleWalls.add(wallInfo);
    	}      
    	if (m_listViisibleWalls.size() <= 2) {
    		m_appWin.findViewById(R.id.more_button).setVisibility(View.GONE);
    	}
    }
 
    private void SetRecommand(ViewGroup parentView, Button button) {
    	int nButtonId = button.getId();
    	ImageView imageView = new ImageView(m_ownerActivity);
    	imageView.setBackgroundResource(R.drawable.app_wall_recommand);

        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(
        		ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        layoutParams.addRule(RelativeLayout.ALIGN_TOP, nButtonId);
        layoutParams.addRule(RelativeLayout.ALIGN_RIGHT, nButtonId);

        layoutParams.setMargins(0, -4, -4, 0);
    	parentView.addView(imageView, layoutParams);
    }
 
    private Button CreateButton(WallInfo wallInfo) {
    	Button button = new Button(m_ownerActivity);
    	button.setId(wallInfo.m_nId);
    	button.setBackgroundResource(wallInfo.m_nId);
    	button.setText(wallInfo.m_strText);
    	button.setTextColor(Color.rgb(255, 255, 255));
    	button.setTextSize(TypedValue.COMPLEX_UNIT_PX , m_ownerActivity.getResources().getDimensionPixelSize(R.dimen.app_wall_button_text_size));
    	button.setGravity(Gravity.CENTER);
    	return button;
    }

    //触控. 有米  万普  米迪  安沃 (点入没有积分墙)
    private WallInfo GetWallInfo(String strName) {
    	AppWallHelper.AppWall wall = null;
    	int nResId = 0;
    	int nStringId = 0;
    	if (strName.equals(AppWallConfig.sg_strPunchbox)) {		//触控
    		nResId = R.drawable.app_wall_puncbox;
    		nStringId = R.string.app_wall_puncbox_text;
    		wall = new AppWallHelper.ChukongAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strYoumi)) {			//有米
    		nResId = R.drawable.app_wall_youmi;
    		nStringId = R.string.app_wall_youmi_text;
    		wall = new AppWallHelper.YoumiAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strMiidi)) {				//米迪
    		nResId = R.drawable.app_wall_midi;
    		nStringId = R.string.app_wall_midi_text;
    		wall = new AppWallHelper.MidiAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strWanpu)) {			//万普
    		nResId = R.drawable.app_wall_wanpu;
    		nStringId = R.string.app_wall_wanpu_text;
    		wall = new AppWallHelper.WanpuAppWall(m_ownerActivity);
    	}
    	/*
    	else if (strName.equals(AppWallConfig.sg_strMopan)) {					//磨盘		<不允许安卓网赚类>
    		nResId = R.drawable.app_wall_mopan;
    		nStringId = R.string.app_wall_mopan_text;
    		wall = new AppWallHelper.MopanAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strJupeng)) {			//巨鹏		<量小,停止合作>
    		nResId = R.drawable.app_wall_jupeng;
    		nStringId = R.string.app_wall_jupeng_text;
    		wall = new AppWallHelper.JupengAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strDomob)) {			//多盟
    		nResId = R.drawable.app_wall_domob;
    		nStringId = R.string.app_wall_domob_text;
    		wall = new AppWallHelper.DuomengAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strAnwo)) {			//安沃
    		nResId = R.drawable.app_wall_anwo;
    		nStringId = R.string.app_wall_anwo_text;
    		wall = new AppWallHelper.AnwoAppWall(m_ownerActivity);
    	}
    	*/
    	else {
    		return null;	
    	}
    	return new WallInfo(strName, nResId, m_ownerActivity.getString(nStringId), wall);
    }	

    public void onClick(View v) {
  	
    	int nId = v.getId();
    	if (nId == R.id.more_button) {
    		//更多
	        final View defulatPage = m_appWin.findViewById(R.id.default_page);
	        final View moreAppWallPage = m_appWin.findViewById(R.id.more_appwall_page);
        	defulatPage.setVisibility(View.GONE);
        	moreAppWallPage.setVisibility(View.VISIBLE);
    	}
    	else if (nId == R.id.return_button) {
    		//返回
	        final View defulatPage = m_appWin.findViewById(R.id.default_page);
	        final View moreAppWallPage = m_appWin.findViewById(R.id.more_appwall_page);
        	defulatPage.setVisibility(View.VISIBLE);
        	moreAppWallPage.setVisibility(View.GONE);
    	}
    	else if (nId == R.id.important_tip) {
    		//重要提示
    		ActivityHelper.ShowAppInstallActivity(m_ownerActivity);
    		dismiss();
    	}
    	else if (nId == R.id.close_button) {
    		dismiss();
    	}
    	else {
    		for (WallInfo info:m_listViisibleWalls) {
    			if (info.m_nId == nId) {
    				info.m_appWall.Show();
    				dismiss();
    				break;
    			}
    		}
    	}
    }
    private void AttachEvents() {
    	m_appWin.findViewById(R.id.important_tip).setOnClickListener(this);
    	
    	m_appWin.findViewById(R.id.close_button).setOnClickListener(this);
    	
        //更多按钮
    	m_appWin.findViewById(R.id.more_button).setOnClickListener(this);

    	//返回按钮
    	m_appWin.findViewById(R.id.return_button).setOnClickListener(this);
    }

    
    private Activity m_ownerActivity;		
    
    private class WallInfo {
    	public WallInfo(String strName, int nId, String strText, AppWallHelper.AppWall wall) {
    		m_strName = strName;
    		m_nId = nId;
    		m_strText = strText;
    		m_appWall = wall;
    	}
    	public void SetReommand(boolean bRecommand) {
    		m_bRecommand = bRecommand;
    	}
    	String m_strName; 
		String m_strText;
      	int m_nId;
      	boolean m_bRecommand = false;
    	AppWallHelper.AppWall m_appWall;
    }
    private ArrayList<WallInfo> m_listViisibleWalls = new ArrayList<WallInfo>();
    private View m_appWin;
}
