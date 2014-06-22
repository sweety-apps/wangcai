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
    	ViewGroup morePanel = (ViewGroup)m_appWin.findViewById(R.id.more_panel_button_container);

    	String strText = m_ownerActivity.getString(R.string.app_wall_win_text);
    	CharSequence charSequence = Html.fromHtml(strText);
    	TextView textView = (TextView)m_appWin.findViewById(R.id.text);
    	textView.setText(charSequence);
    	
    	
    	//���Ӧ��ǽ
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

        //������ť
        Resources res = m_ownerActivity.getResources();
        int nTopMargin = res.getDimensionPixelSize(R.dimen.offer_wall_button_margin);
 
        int nLastId1 = 0, nLastId2 = 0;
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
    				SetRecommand(morePanel, button);		//�Ƽ�
    			}
    		}
    		else {
    			if (nLastId1 != 0) {
    				layoutParams.addRule(RelativeLayout.BELOW, nLastId1);
    			}
    			nLastId1 = wallInfo.m_nId;
    			defaultPanel.addView(button,  layoutParams);
    			if (bIsRecommand) {
    				SetRecommand(defaultPanel, button);		//�Ƽ�
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
        //layoutParams.addRule3(RelativeLayout.ALIGN_BOTTOM, nButtonId);
        layoutParams.addRule(RelativeLayout.ALIGN_RIGHT, nButtonId);

        //Resources res = m_ownerActivity.getResources();
        //int nButtonHeight = res.getDimensionPixelSize(R.dimen.app_wall_button_height);
        //int nMargin = res.getDimensionPixelSize(R.dimen.app_wall_recommand_right_margin);
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
  
    private WallInfo GetWallInfo(String strName) {
    	AppWallHelper.AppWall wall = null;
    	int nResId = 0;
    	int nStringId = 0;
    	if (strName.equals(AppWallConfig.sg_strPunchbox)) {		//����
    		nResId = R.drawable.app_wall_puncbox;
    		nStringId = R.string.app_wall_puncbox_text;
    		wall = new AppWallHelper.ChukongAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strYoumi)) {			//����
    		nResId = R.drawable.app_wall_youmi;
    		nStringId = R.string.app_wall_youmi_text;
    		wall = new AppWallHelper.YoumiAppWall(m_ownerActivity);
    	}
    	/*
    	else if (strName.equals(AppWallConfig.sg_strMopan)) {					//ĥ��
    		nResId = R.drawable.app_tip_domob;
    		//wall = new AppWallHelper.				//ĥ��todo
    	}
    	else if (strName.equals(AppWallConfig.sg_strJupeng)) {			//����
    		nResId = R.drawable.app_tip_jupeng;
    		wall = new AppWallHelper.JupengAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strMiidi)) {				//�׵�
    		nResId = R.drawable.app_tip_miidi;
    		wall = new AppWallHelper.MidiAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strDomob)) {			//����
    		nResId = R.drawable.app_tip_domob;
    		wall = new AppWallHelper.DuomengAppWall(m_ownerActivity);
    	}
    	else if (strName.equals(AppWallConfig.sg_strMobsmar)) {		//ָ��
    		nResId = R.drawable.app_tip_mobsmar;
    	}
    	else if (strName.equals(AppWallConfig.sg_strLimei)) {			//����
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
    		//����
	        final View defulatPage = m_appWin.findViewById(R.id.default_page);
	        final View moreAppWallPage = m_appWin.findViewById(R.id.more_appwall_page);
        	defulatPage.setVisibility(View.GONE);
        	moreAppWallPage.setVisibility(View.VISIBLE);
    	}
    	else if (nId == R.id.return_button) {
    		//����
	        final View defulatPage = m_appWin.findViewById(R.id.default_page);
	        final View moreAppWallPage = m_appWin.findViewById(R.id.more_appwall_page);
        	defulatPage.setVisibility(View.VISIBLE);
        	moreAppWallPage.setVisibility(View.GONE);
    	}
    	else if (nId == R.id.important_tip) {
    		//��Ҫ��ʾ
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
    	
        //���ఴť
    	m_appWin.findViewById(R.id.more_button).setOnClickListener(this);

    	//���ذ�ť
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
