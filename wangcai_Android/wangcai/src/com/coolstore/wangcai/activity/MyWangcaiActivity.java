package com.coolstore.wangcai.activity;


import java.lang.ref.WeakReference;

import com.coolstore.common.TimerManager;
import com.coolstore.common.ViewHelper;
import com.coolstore.common.TimerManager.TimerManagerCallback;
import com.coolstore.request.UserInfo;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.WangcaiActivity;
import com.coolstore.wangcai.ctrls.MyWangcaiItem;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.drawable.AnimationDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.ViewStub;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

public class MyWangcaiActivity extends WangcaiActivity {
	private final static int ms_nRunAnimationTaskId = 1818;
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my_wangcai);
        
        int nCurrentLevel = WangcaiApp.GetInstance().GetUserInfo().GetCurrentLevel();
        InitView(nCurrentLevel);
     }


    @SuppressLint("NewApi") private void InitView(int nCurrentLevel) {
    	UserInfo userInfo = WangcaiApp.GetInstance().GetUserInfo();
    	float fPercent = 0.0f;
    	if (userInfo.GetNextLevelExperience() > 0) {
    		fPercent = (float)userInfo.GetCurrentExperience() / (float)userInfo.GetNextLevelExperience();
    	}
    	int nWidth = findViewById(R.id.progress).getWidth();
    	nWidth = (int)((float)nWidth * fPercent);
    	View view = findViewById(R.id.progress_front);
    	view.setRight(view.getLeft() + nWidth);
    	
    	String strText;
    	TextView textView; 
    	textView = (TextView)this.findViewById(R.id.level_value);
    	textView.setText(String.valueOf(nCurrentLevel));
    	
    	textView = (TextView)this.findViewById(R.id.level_benefit);
    	strText = String.format(getString(R.string.level_privilege_tip), nCurrentLevel);
    	textView.setText(strText);
    	
    	ViewGroup parentView = (ViewGroup)this.findViewById(R.id.main_wnd);
    	
    	AddItem(parentView, 3, R.drawable.mywangcai_lv3_logo, getString(R.string.skill3), getString(R.string.lv3_benefit));
    	AddItem(parentView, 5, R.drawable.mywangcai_lv5_logo, getString(R.string.skill5), getString(R.string.lv5_benefit));
    	AddItem(parentView, 10, R.drawable.mywangcai_lv10_logo, getString(R.string.skill10), getString(R.string.lv10_benefit));
    	
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

    	m_handler = new Handler();   
    	m_handler.postDelayed(new Runnable() { 
            public void run() { 
				m_dogAnimationDrawable.stop();
				m_dogAnimationDrawable.start();
				m_handler = null;
            } 
        }, 50);
    }
    
    private void AddItem(ViewGroup parentView, int nLevel, int nIconId, String strLevelName, String strLevelBenefit) {
        Context context = getApplicationContext();
    	MyWangcaiItem item = new MyWangcaiItem();
    	View view = item.Create(this, nLevel, nIconId, strLevelName, strLevelBenefit);
    	parentView.addView(view);
    }


    
    AnimationDrawable m_dogAnimationDrawable; 
    Handler m_handler = null;
}
