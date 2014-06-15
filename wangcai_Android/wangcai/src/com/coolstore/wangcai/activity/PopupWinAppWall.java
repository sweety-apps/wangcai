package com.coolstore.wangcai.activity;

import java.util.ArrayList;

import net.miidiwall.SDK.AdWall;
import net.miidiwall.SDK.IAdWallShowAppsNotifier;
import net.youmi.android.offers.OffersManager;
import cn.domob.data.OErrorInfo;
import cn.domob.data.OManager;

import com.coolstore.request.AppWallConfig;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.AppWallHelper;
import com.jpmob.sdk.wall.JupengWallConnector;
import com.jpmob.sdk.wall.JupengWallListener;
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
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;

public class PopupWinAppWall extends PopupWindow implements OnClickListener{
	
    public PopupWinAppWall(Activity holderActivity) {  
        super(holderActivity);
        m_ownerActivity = holderActivity;
        LayoutInflater inflater = (LayoutInflater) holderActivity  
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        m_appWin = inflater.inflate(R.layout.win_app_wall, null);  
        
        //DisplayMetrics metric = new DisplayMetrics();
        //holderActivity.getWindowManager().getDefaultDisplay().getMetrics(metric);
        
        this.setContentView(m_appWin);
        this.setWidth(ViewGroup.LayoutParams.MATCH_PARENT);  
        this.setHeight(ViewGroup.LayoutParams.MATCH_PARENT); 
        this.setFocusable(true);  
        //ColorDrawable dw = new ColorDrawable(0x00ffffff);  
        //this.setBackgroundDrawable(dw);  
  
        AppWallConfig appWallConfig = WangcaiApp.GetInstance().GetAppWallConfig();
        if (appWallConfig != null) {
        	InitView(appWallConfig);
        }
        
        AttachEvents();
    }  
    
    private void InitView(AppWallConfig appWallConfig) {
    	int nCount = appWallConfig.GetWallCount();
    	ViewGroup defaultPanel = (ViewGroup)m_appWin.findViewById(R.id.app_wall_button_container);
    	ViewGroup morePanel = (ViewGroup)m_appWin.findViewById(R.id.more_appwall_page);

    	String strText = m_ownerActivity.getString(R.string.app_wall_win_text);
    	CharSequence charSequence = Html.fromHtml(strText);
    	TextView textView = (TextView)m_appWin.findViewById(R.id.text);
    	textView.setText(charSequence);
    	
    	
    	//点击应用墙
    	OnClickListener linstener = new OnClickListener() {
            public void onClick(View v) {
            	int nId = v.getId();
            	for (WallInfo wallInfo:m_listViisibleWalls) {
            		if (wallInfo.m_nId == nId) {
            			if (wallInfo.m_appWall != null) {
            				wallInfo.m_appWall.Show();
            				break;
            			}
            		}
            	}
                dismiss();
            }
        };

        //创建按钮
        Resources res = m_ownerActivity.getResources();
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(
        		res.getDimensionPixelSize(R.dimen.app_wall_button_width), res.getDimensionPixelSize(R.dimen.app_wall_button_height));
        int nMargin = m_ownerActivity.getResources().getDimensionPixelSize(R.dimen.offer_wall_button_margin);
        layoutParams.setMargins(0, nMargin, 0, 0);
 
    	for (int i = 0; i < nCount; ++i) {
    		AppWallConfig.AppWallInfo info = appWallConfig.GetAppWallInfo(i);
    		if (!info.IsVisible()) {
    			continue;
    		}
			WallInfo wallInfo = GetWallInfo(info.GetName());
			if (wallInfo == null) {
				continue;
			}
			boolean bIsRecommand = info.IsRecommand();
			wallInfo.SetReommand(bIsRecommand);
			
			Button button = CreateButton(wallInfo);
			bIsRecommand = true;
			if (bIsRecommand) {
				//button.setImageResource(R.drawable.app_tip_recommand);
			}
    		if (info.IsInMorePanel()) {
    			morePanel.addView(button,  layoutParams);
    		}
    		else {
    			defaultPanel.addView(button,  layoutParams);
    		}
			
    		button.setOnClickListener(this);
			m_listViisibleWalls.add(wallInfo);
    	}      
    	if (m_listViisibleWalls.size() <= 2) {
    		m_appWin.findViewById(R.id.more_button).setVisibility(View.GONE);
    	}
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
    	/*
    	else if (strName.equals(AppWallConfig.sg_strMopan)) {					//磨盘
    		nResId = R.drawable.app_tip_domob;
    		//wall = new AppWallHelper.				//磨盘todo
    	}
    	else if (strName.equals(AppWallConfig.sg_strJupeng)) {			//巨鹏
    		nResId = R.drawable.app_tip_jupeng;
    		wall = new AppWallHelper.JupengAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strMiidi)) {				//米迪
    		nResId = R.drawable.app_tip_miidi;
    		wall = new AppWallHelper.MidiAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strDomob)) {			//多盟
    		nResId = R.drawable.app_tip_domob;
    		wall = new AppWallHelper.DuomengAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strMobsmar)) {		//指盟
    		nResId = R.drawable.app_tip_mobsmar;
    	}
    	else if (strName.equals(AppWallConfig.sg_strLimei)) {			//力美
    		nResId = R.drawable.app_tip_limei;
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
