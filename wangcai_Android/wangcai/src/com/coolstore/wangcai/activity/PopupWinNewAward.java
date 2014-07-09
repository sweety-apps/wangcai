package com.coolstore.wangcai.activity;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.coolstore.common.Util;
import com.coolstore.common.ViewHelper;
import com.coolstore.request.UserInfo;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;

public class PopupWinNewAward extends PopupWindow implements OnClickListener{

    public PopupWinNewAward(Activity holderActivity, String strAwardName, int nAward) {  
        super(holderActivity);
        //m_ownerActivity = holderActivity;
        LayoutInflater inflater = (LayoutInflater) holderActivity  
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        m_win = inflater.inflate(R.layout.win_new_award, null);  

        this.setContentView(m_win);
        this.setWidth(ViewGroup.LayoutParams.FILL_PARENT);  
        this.setHeight(ViewGroup.LayoutParams.FILL_PARENT); 
        this.setFocusable(true); 
        this.setBackgroundDrawable(holderActivity.getResources().getDrawable(R.drawable.popup_bkg));
        
        UserInfo userInfo = WangcaiApp.GetInstance().GetUserInfo();
        
        ((TextView)m_win.findViewById(R.id.award_value)).setText(Util.FormatMoney(nAward));
        ((TextView)m_win.findViewById(R.id.level)).setText(String.format("LV%d", userInfo.GetCurrentLevel()));
        ((TextView)m_win.findViewById(R.id.level_benefit)).setText(
        		String.format(holderActivity.getString(R.string.new_award_tip_level_benefit), userInfo.GetCurrentLevel()));

        ((TextView)m_win.findViewById(R.id.title)).setText(strAwardName);
 
        View viewGetAward = m_win.findViewById(R.id.get_award_button);
        ViewHelper.SetStateViewBkg(viewGetAward, holderActivity, 
        		R.drawable.redbag_mb_btn_normal, R.drawable.redbag_mb_btn_pressed);
        viewGetAward.setOnClickListener(this);
    	m_win.findViewById(R.id.close_button).setOnClickListener(this);
    	
    	int listGridId[] = {R.id.app_wall_grid1, R.id.app_wall_grid2, R.id.app_wall_grid3, R.id.app_wall_grid4, R.id.app_wall_grid5};
    	
    	int nGridCount = (int)((float)userInfo.GetCurrentExperience() * 5.0f / (float)userInfo.GetNextLevelExperience());
    	if (nGridCount > listGridId.length) {
    		nGridCount = listGridId.length;
    	}
    	for (int i = 0; i < nGridCount; i++) {
    		ViewHelper.SetViewBackground(m_win, listGridId[i], R.drawable.redbag_mb_lv_get);
    	}
     }  

    public void onClick(View v) {
    	int nId = v.getId();
    	if (nId == R.id.close_button) {
    		dismiss();
    	}
    	else if (nId == R.id.get_award_button) {
    		dismiss();
    	}
    }
    
    //private Activity m_ownerActivity;
    private View m_win;
}
