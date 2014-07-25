package com.coolstore.wangcai.activity;

import java.util.ArrayList;




import com.coolstore.request.OfferWallManager;
import com.coolstore.request.OfferWalls;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.text.Html;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class PopupWinOfferWall extends PopupWindow implements OnClickListener{
	public PopupWinOfferWall(Context context) {
        super(context);
	}
    public PopupWinOfferWall(Activity holderActivity) {  
        super(holderActivity);
        m_ownerActivity = holderActivity;
        LayoutInflater inflater = (LayoutInflater) holderActivity  
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        m_wallListWin = inflater.inflate(R.layout.win_app_wall, null);  

        this.setContentView(m_wallListWin);
        this.setWidth(ViewGroup.LayoutParams.FILL_PARENT);  
        this.setHeight(ViewGroup.LayoutParams.FILL_PARENT); 
        this.setFocusable(true); 
        this.setBackgroundDrawable(holderActivity.getResources().getDrawable(R.drawable.popup_bkg));
        OfferWallManager offerWallConfig = WangcaiApp.GetInstance().GetOfferWallConfig();
        if (offerWallConfig != null) {
        	InitView(offerWallConfig);
        }
        
        AttachEvents();
    }  
    
    private void InitView(OfferWallManager offerWallConfig) {
    	ViewGroup defaultPanel = (ViewGroup)m_wallListWin.findViewById(R.id.app_wall_button_container);
    	ViewGroup morePanel = (ViewGroup)m_wallListWin.findViewById(R.id.more_panel_button_container);

    	String strText = m_ownerActivity.getString(R.string.app_wall_win_text);
    	CharSequence charSequence = Html.fromHtml(strText);
    	TextView textView = (TextView)m_wallListWin.findViewById(R.id.text);
    	textView.setText(charSequence);
    	
        //创建按钮
        Resources res = m_ownerActivity.getResources();
        int nTopMargin = res.getDimensionPixelSize(R.dimen.offer_wall_button_margin);
        
        
        int nLastId1 = 0, nLastId2 = 0;
    	int nCount = offerWallConfig.GetWallCount();

    	//debug
        ArrayList<OfferWalls.OfferWall> listWallInfo = new ArrayList<OfferWalls.OfferWall>();
        listWallInfo.add(OfferWalls.NewOfferWall(OfferWalls.sg_strDianLe, 1));
        listWallInfo.add(OfferWalls.NewOfferWall(OfferWalls.sg_strWanpu, 1));
        listWallInfo.add(OfferWalls.NewOfferWall(OfferWalls.sg_strMiidi, 3));
        listWallInfo.add(OfferWalls.NewOfferWall(OfferWalls.sg_strPunchbox, 3));
        listWallInfo.add(OfferWalls.NewOfferWall(OfferWalls.sg_strAnwo, 3));
        //listWallInfo.add(OfferWalls.NewOfferWall(OfferWalls.sg_strYoumi, 3));
        //listWallInfo.add(OfferWalls.NewOfferWall(OfferWalls.sg_strWanpu, 3));
    	nCount = listWallInfo.size();
    	
    	for (int i = 0; i < nCount; ++i) {
    		OfferWalls.OfferWall offerWall = offerWallConfig.GetOfferWallInfo(i);
    		offerWall = listWallInfo.get(i);	////debug
    		if (offerWall == null || !offerWall.IsVisible()) {
    			continue;
    		}
			WallInfo wallInfo = GetWallInfo(offerWall);
			if (wallInfo == null) {
				continue;
			}
			boolean bIsRecommand = offerWall.IsRecommand();

	        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(
	        		res.getDimensionPixelSize(R.dimen.app_wall_button_width), res.getDimensionPixelSize(R.dimen.app_wall_button_height));
	        layoutParams.setMargins(0, nTopMargin, 0, 0);

			Button button = CreateButton(wallInfo);
    		if (offerWall.IsInMorePanel()) {
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
    		m_wallListWin.findViewById(R.id.more_button).setVisibility(View.GONE);
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
    private WallInfo GetWallInfo(OfferWalls.OfferWall offerWall) {
    	String strName = offerWall.GetName();
    	int nResId = 0;
    	int nStringId = 0;
    	if (strName.equals(OfferWalls.sg_strPunchbox)) {				//触控
    		nResId = R.drawable.app_wall_puncbox;
    		nStringId = R.string.app_wall_puncbox_text;
    	}
    	else if (strName.equals(OfferWalls.sg_strYoumi)) {			//有米
    		nResId = R.drawable.app_wall_youmi;
    		nStringId = R.string.app_wall_youmi_text;
    	}
    	else if (strName.equals(OfferWalls.sg_strMiidi)) {				//米迪
    		nResId = R.drawable.app_wall_midi;
    		nStringId = R.string.app_wall_midi_text;
    	}
    	else if (strName.equals(OfferWalls.sg_strWinAds)) {
    		nResId = R.drawable.app_wall_winads;
    		nStringId = R.string.app_wall_winads_text;
    	}
    	else if (strName.equals(OfferWalls.sg_strDianLe)) {
    		nResId = R.drawable.app_wall_dianle;
    		nStringId = R.string.app_wall_dianle_text;
    	}
    	else if (strName.equals(OfferWalls.sg_strWanpu)) {			//万普
    		nResId = R.drawable.app_wall_wanpu;
    		nStringId = R.string.app_wall_wanpu_text;
    	}
    	else if (strName.equals(OfferWalls.sg_strAnwo)) {				//安沃
    		nResId = R.drawable.app_wall_anwo;
    		nStringId = R.string.app_wall_anwo_text;
    	}
    	/*
    	else if (strName.equals(OfferWalls.sg_strMopan)) {				//磨盘		<不允许安卓网赚类>
    		nResId = R.drawable.app_wall_mopan;
    		nStringId = R.string.app_wall_mopan_text;
    	}
    	else if (strName.equals(OfferWalls.sg_strJupeng)) {			//巨鹏		<量小,停止合作>
    		nResId = R.drawable.app_wall_jupeng;
    		nStringId = R.string.app_wall_jupeng_text;
    	}
    	else if (strName.equals(OfferWalls.sg_strDomob)) {				//多盟
    		nResId = R.drawable.app_wall_domob;
    		nStringId = R.string.app_wall_domob_text;
    	}
    	*/
    	else {
    		return null;	
    	}
    	return new WallInfo(nResId, m_ownerActivity.getString(nStringId), offerWall);
    }	

    public void onClick(View v) {
  	
    	int nId = v.getId();
    	if (nId == R.id.more_button) {
    		//更多
	        final View defulatPage = m_wallListWin.findViewById(R.id.default_page);
	        final View moreOfferWallPage = m_wallListWin.findViewById(R.id.more_offerwall_page);
        	defulatPage.setVisibility(View.GONE);
        	moreOfferWallPage.setVisibility(View.VISIBLE);
    	}
    	else if (nId == R.id.return_button) {
    		//返回
	        final View defulatPage = m_wallListWin.findViewById(R.id.default_page);
	        final View moreOfferWallPage = m_wallListWin.findViewById(R.id.more_offerwall_page);
        	defulatPage.setVisibility(View.VISIBLE);
        	moreOfferWallPage.setVisibility(View.GONE);
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
    				info.m_offerWall.Show(m_ownerActivity);
    				dismiss();
    				break;
    			}
    		}
    	}
    }
    private void AttachEvents() {
    	m_wallListWin.findViewById(R.id.important_tip).setOnClickListener(this);
    	
    	m_wallListWin.findViewById(R.id.close_button).setOnClickListener(this);
    	
        //更多按钮
    	m_wallListWin.findViewById(R.id.more_button).setOnClickListener(this);

    	//返回按钮
    	m_wallListWin.findViewById(R.id.return_button).setOnClickListener(this);
    }

    
    private Activity m_ownerActivity;		
    
    private class WallInfo {
    	public WallInfo(int nId, String strText, OfferWalls.OfferWall wall) {
    		m_nId = nId;
    		m_strText = strText;
    		m_offerWall = wall;
    	}
		String m_strText;
      	int m_nId;
    	OfferWalls.OfferWall m_offerWall;
    }
    private ArrayList<WallInfo> m_listViisibleWalls = new ArrayList<WallInfo>();
    private View m_wallListWin;
}
