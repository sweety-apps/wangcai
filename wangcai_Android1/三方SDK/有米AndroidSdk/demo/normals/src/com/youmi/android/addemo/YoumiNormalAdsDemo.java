package com.youmi.android.addemo;

import net.youmi.android.AdManager;
import net.youmi.android.banner.AdSize;
import net.youmi.android.banner.AdView;
import net.youmi.android.banner.AdViewListener;
import net.youmi.android.smart.SmartBannerManager;
import net.youmi.android.spot.SpotDialogListener;
import net.youmi.android.spot.SpotManager;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.FrameLayout;

public class YoumiNormalAdsDemo extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_ad);
		
		// 初始化接口，应用启动的时候调用
		// 参数：appId, appSecret, 调试模式
		AdManager.getInstance(this).init("85aa56a59eac8b3d","a14006f66f58d5d7", false);
		
		// 广告条接口调用（适用于应用）        
        // 将广告条adView添加到需要展示的layout控件中
//        LinearLayout adLayout = (LinearLayout) findViewById(R.id.adLayout);
//        AdView adView = new AdView(this, AdSize.FIT_SCREEN);
//        adLayout.addView(adView);

        //广告条接口调用（适用于游戏）
        
	        //实例化LayoutParams(重要)
	        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(
	        		FrameLayout.LayoutParams.FILL_PARENT,
	        		FrameLayout.LayoutParams.WRAP_CONTENT);     
	        //设置广告条的悬浮位置
	        layoutParams.gravity = Gravity.BOTTOM | Gravity.RIGHT; // 这里示例为右下角  
	        //实例化广告条
	        AdView adView = new AdView(this, AdSize.FIT_SCREEN);
	        //调用Activity的addContentView函数
	        this.addContentView(adView, layoutParams);
        
        // 监听广告条接口
        adView.setAdListener(new AdViewListener() {
            
            @Override
            public void onSwitchedAd(AdView arg0) {
                Log.i("YoumiAdDemo", "广告条切换");
            }
            
            @Override
            public void onReceivedAd(AdView arg0) {
                Log.i("YoumiAdDemo", "请求广告成功");
                
            }
            
            @Override
            public void onFailedToReceivedAd(AdView arg0) {
                Log.i("YoumiAdDemo", "请求广告失败");
            }
        });
        
		
		
        // 插播接口调用
        // 开发者可以到开发者后台设置展示频率，需要到开发者后台设置页面（详细信息->业务信息->无积分广告业务->高级设置）
        // 自4.03版本增加云控制是否开启防误点功能，需要到开发者后台设置页面（详细信息->业务信息->无积分广告业务->高级设置）

        // 加载插播资源
        SpotManager.getInstance(this).loadSpotAds();
		// 设置展示超时时间，加载超时则不展示广告，默认0，代表不设置超时时间
        SpotManager.getInstance(this).setSpotTimeout(5000);//设置5秒
		Button spotBtn = (Button) findViewById(R.id.showSpot);
        spotBtn.setOnClickListener(new OnClickListener() {            
            @Override
            public void onClick(View v) {

            	// 展示插播广告，可以不调用loadSpot独立使用
            	SpotManager.getInstance(YoumiNormalAdsDemo.this).showSpotAds(YoumiNormalAdsDemo.this, new SpotDialogListener() {
                    @Override
                    public void onShowSuccess() {
                        Log.i("YoumiAdDemo", "展示成功");
                    }

                    @Override
                    public void onShowFailed() {
                        Log.i("YoumiAdDemo", "展示失败");
                    }

                });                ////
               
            	// 可以根据需要设置Theme，如下调用，如果无特殊需求，直接调用上方的接口即可
                // SpotManager.getInstance(YoumiAdDemo.this).showSpotAds(YoumiAdDemo.this, android.R.style.Theme_Translucent_NoTitleBar);
                ////
            }
        });
        
        
        
        // SmartBanner初始化接口,在应用开启的时候调用一次即可
        SmartBannerManager.init(this);
        // 调用展示飘窗
        SmartBannerManager.show(YoumiNormalAdsDemo.this);
        Button smartBannerBtn = (Button) findViewById(R.id.showSmartBanner);
        smartBannerBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
            	// 调用展示飘窗
            	SmartBannerManager.show(YoumiNormalAdsDemo.this);
            }
        });
        
        
        Button diyBtn = (Button) findViewById(R.id.diy);
        diyBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent();
                intent.setClass(YoumiNormalAdsDemo.this, DiyDemo.class);
                startActivity(intent);
            }
        });
	}

}
