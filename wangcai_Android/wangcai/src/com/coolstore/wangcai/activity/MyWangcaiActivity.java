package com.coolstore.wangcai.activity;


import com.coolstore.common.ViewHelper;
import com.coolstore.request.UserInfo;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.WangcaiActivity;
import com.coolstore.wangcai.ctrls.MyWangcaiItem;

import android.annotation.SuppressLint;
import android.graphics.drawable.AnimationDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.view.ViewStub;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class MyWangcaiActivity extends WangcaiActivity {	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my_wangcai);
        
        InitView();
     }


    @SuppressLint("NewApi") private void InitView() {
    	final UserInfo userInfo = WangcaiApp.GetInstance().GetUserInfo();

        int nCurrentLevel = userInfo.GetCurrentLevel();

    	float fPercent = 0.0f;
    	if (userInfo.GetNextLevelExperience() > 0) {
    		fPercent = (float)userInfo.GetCurrentExperience() / (float)userInfo.GetNextLevelExperience();
    	}

    	int nWidth = findViewById(R.id.progress).getLayoutParams().width;
    	int nFrontWidth = (int)((float)nWidth * fPercent);
    	
    	View view = findViewById(R.id.progress_front);

    	RelativeLayout.LayoutParams layoutParam = (RelativeLayout.LayoutParams) view.getLayoutParams();  
    	layoutParam.width = nFrontWidth;
    	view.setLayoutParams(layoutParam);
     	
    	String strText;
    	TextView textView; 
    	textView = (TextView)this.findViewById(R.id.level_value);
    	textView.setText(String.valueOf(nCurrentLevel));
    	
    	textView = (TextView)this.findViewById(R.id.level_benefit);
    	strText = String.format(getString(R.string.level_privilege_tip), nCurrentLevel);
    	textView.setText(strText);
    	
    	ViewGroup parentView = (ViewGroup)this.findViewById(R.id.main_wnd);
    	
    	AddItem(parentView, nCurrentLevel < 3, 3, R.drawable.mywangcai_lv3_logo, getString(R.string.skill3), getString(R.string.lv3_benefit));
    	AddItem(parentView, nCurrentLevel < 5, 5, R.drawable.mywangcai_lv5_logo, getString(R.string.skill5), getString(R.string.lv5_benefit));
    	AddItem(parentView, nCurrentLevel < 10, 10, R.drawable.mywangcai_lv10_logo, getString(R.string.skill10), getString(R.string.lv10_benefit));
    	
    	if (!userInfo.HasBindPhone()) {
    		ViewStub stub = (ViewStub) findViewById(R.id.bind_phone_tip);  
    		stub.inflate(); 

    		View bindButton = findViewById(R.id.bind_phone_button);
        	ViewHelper.SetStateViewBkg(bindButton, this, R.drawable.mywangcai_bingdphone_btn, R.drawable.mywangcai_bingdphone_btn_pressed);
        	bindButton.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					ActivityHelper.ShowRegisterActivity(MyWangcaiActivity.this);
				}    		
    		});
    	}    	
    	
    	ImageView image = (ImageView) findViewById(R.id.dog_image);
    	image.setBackgroundResource(R.anim.ani_dog);
    	m_dogAnimationDrawable = (AnimationDrawable)  image.getBackground();    	

    	Handler handler = new Handler();   
    	handler.postDelayed(new Runnable() { 
            public void run() { 
				m_dogAnimationDrawable.stop();
				m_dogAnimationDrawable.start();
            } 
        }, 50);
    }
    
    private void AddItem(ViewGroup parentView, boolean bLock, int nLevel, int nIconId, String strLevelName, String strLevelBenefit) {
    	MyWangcaiItem item = new MyWangcaiItem();
    	View view = item.Create(this, bLock, nLevel, nIconId, strLevelName, strLevelBenefit);
    	LayoutParams param = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);;
    	parentView.addView(view, param);
    }


    
    AnimationDrawable m_dogAnimationDrawable;
}
