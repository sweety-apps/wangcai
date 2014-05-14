package com.example.wangcai.activity;

import java.util.ArrayList;

import net.miidiwall.SDK.AdWall;
import net.miidiwall.SDK.IAdWallShowAppsNotifier;
import net.youmi.android.offers.OffersManager;
import cn.domob.data.OErrorInfo;
import cn.domob.data.OManager;

import com.example.request.AppWallConfig;
import com.example.wangcai.R;
import com.example.wangcai.WangcaiApp;
import com.jpmob.sdk.wall.JupengWallConnector;
import com.jpmob.sdk.wall.JupengWallListener;
import com.punchbox.ads.AdRequest;
import com.punchbox.ads.OfferWallAd;
import com.punchbox.exception.PBException;
import com.punchbox.listener.AdListener;

import android.app.ActionBar.LayoutParams;
import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.PopupWindow;

public class AppWallWin extends PopupWindow{
	
    public AppWallWin(Activity holderActivity) {  
        super(holderActivity);
        m_ownerActivity = holderActivity;
        LayoutInflater inflater = (LayoutInflater) holderActivity  
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        View appWin = inflater.inflate(R.layout.win_app_wall, null);  

        this.setContentView(appWin);    
        this.setWidth(LayoutParams.FILL_PARENT);  
        this.setHeight(LayoutParams.WRAP_CONTENT); 
        this.setFocusable(true);  
        ColorDrawable dw = new ColorDrawable(0xb0000000);  
        this.setBackgroundDrawable(dw);  
  
        AppWallConfig appWallConfig = WangcaiApp.GetInstance().GetAppWallConfig();
        if (appWallConfig != null) {
        	InitView(appWallConfig, appWin);
        }
        
        AttachEvents(appWin);
    }  
    
    private void InitView(AppWallConfig appWallConfig, View appWin) {
    	int nCount = appWallConfig.GetWallCount();
    	ViewGroup defaultPanel = (ViewGroup)appWin.findViewById(R.id.app_wall_button_container);
    	ViewGroup morePanel = (ViewGroup)appWin.findViewById(R.id.more_appwall_page);

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
 
    	for (int i = 0; i < nCount; ++i) {
    		AppWallConfig.AppWallInfo info = appWallConfig.GetAppWallInfo(i);
    		if (!info.IsVisible()) {
    			continue;
    		}
			WallInfo wallInfo = GetWallInfo(info.GetName());
			wallInfo.SetReommand(info.IsRecommand());
			
			ImageButton button = CreateButton(wallInfo);
    		if (!info.IsInMorePanel()) {
    			defaultPanel.addView(button);
    		}
    		else {
    			morePanel.addView(button);
    		}
			m_listViisibleWalls.add(wallInfo);
    	}        
    }
    private ImageButton CreateButton(WallInfo wallInfo) {
    	ImageButton button = new ImageButton(m_ownerActivity);
    	button.setId(wallInfo.m_nId);
    	button.setBackgroundResource(wallInfo.m_nId);
    	return button;
    }
    private WallInfo GetWallInfo(String strName) {
    	AppWallHelper.AppWall wall = null;
    	int nResId = 0;
    	if (strName.equals(AppWallConfig.sg_strMopan)) {					//磨盘
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
    	else if (strName.equals(AppWallConfig.sg_strPunchbox)) {		//触控
    		nResId = R.drawable.app_tip_punchbox;
    		wall = new AppWallHelper.ChukongAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strMobsmar)) {		//指盟
    		nResId = R.drawable.app_tip_mobsmar;
    	}
    	else if (strName.equals(AppWallConfig.sg_strLimei)) {			//力美
    		nResId = R.drawable.app_tip_limei;
    	}
    	else if (strName.equals(AppWallConfig.sg_strYoumi)) {			//有米
    		nResId = R.drawable.app_tip_youmi;
    		wall = new AppWallHelper.YoumiAppWall(m_ownerActivity);
    	}
    	return new WallInfo(strName, nResId, wall);
    }	
    
    private void AttachEvents(View appWin) {

        appWin.setOnTouchListener(new View.OnTouchListener() {
			@Override
            public boolean onTouch(View v, MotionEvent event) { 
                dismiss();
                return true;  
            }
        }); 
        
        final View defulatPage = appWin.findViewById(R.id.default_page);
        final View moreAppWallPage = appWin.findViewById(R.id.more_appwall_page);

        //更多按钮
    	((Button)appWin.findViewById(R.id.more_button)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	defulatPage.setVisibility(View.GONE);
            	moreAppWallPage.setVisibility(View.VISIBLE);
            }
        });

    	//返回按钮
    	((Button)appWin.findViewById(R.id.return_button)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	defulatPage.setVisibility(View.VISIBLE);
            	moreAppWallPage.setVisibility(View.GONE);
            }
        });

    }

    
    private Activity m_ownerActivity;
    
    private class WallInfo {
    	public WallInfo(String strName, int nId, AppWallHelper.AppWall wall) {
    		m_strName = strName;
    		m_nId = nId;
    		m_appWall = wall;
    	}
    	public void SetReommand(boolean bRecommand) {
    		m_bRecommand = bRecommand;
    	}
    	String m_strName; 
      	int m_nId;
      	boolean m_bRecommand = false;
    	AppWallHelper.AppWall m_appWall;
    }
    private ArrayList<WallInfo> m_listViisibleWalls = new ArrayList<WallInfo>();
}
