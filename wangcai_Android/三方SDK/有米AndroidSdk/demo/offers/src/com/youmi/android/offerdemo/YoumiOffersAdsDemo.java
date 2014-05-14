package com.youmi.android.offerdemo;

import net.youmi.android.AdManager;
import net.youmi.android.offers.OffersAdSize;
import net.youmi.android.offers.OffersBanner;
import net.youmi.android.offers.OffersManager;
import net.youmi.android.offers.PointsChangeNotify;
import net.youmi.android.offers.PointsManager;
import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class YoumiOffersAdsDemo extends Activity implements OnClickListener, PointsChangeNotify{
	
	/**
	 * 积分 Banner
	 */
	private OffersBanner mBanner;
	/**
	 * 积分 Mini Banner
	 */
	private OffersBanner mMiniBanner;
	
	/**
	 * 显示积分余额的控件
	 */
	TextView mTextViewPoints;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_offers);
		
		// demo绑定按钮事件
		findViewById(R.id.showOffersWall).setOnClickListener(this);
		findViewById(R.id.showOffersDialog).setOnClickListener(this);
		findViewById(R.id.showOffersSpot).setOnClickListener(this);
		findViewById(R.id.awardPoints).setOnClickListener(this);
		findViewById(R.id.spendPoints).setOnClickListener(this);
		
		
		// demo显示积分
		mTextViewPoints = (TextView) findViewById(R.id.pointsBalance);
		int pointsBalance = PointsManager.getInstance(this).queryPoints();// 查询积分余额
		mTextViewPoints.setText("积分余额:" + pointsBalance);
		
		// 初始化接口，应用启动的时候调用
		// 参数：appId, appSecret, 调试模式
		AdManager.getInstance(this).init("cfdbdd2786ea88ea ","d8edde7d10dd0073", false);
		
		// (可选)开启用户数据统计服务,默认不开启，传入false值也不开启，只有传入true才会调用
		AdManager.getInstance(this).setUserDataCollect(true);
		
		// 如果使用积分广告，请务必调用积分广告的初始化接口:
		OffersManager.getInstance(this).onAppLaunch();
		
		// (可选)注册积分监听-随时随地获得积分的变动情况
		PointsManager.getInstance(this).registerNotify(this);
		
		// (可选)使用积分Mini Banner-一个新的积分墙入口点，随时随地让用户关注新的积分广告
		mMiniBanner = new OffersBanner(this, OffersAdSize.SIZE_MATCH_SCREENx32);//
		RelativeLayout layoutOffersMiniBanner = (RelativeLayout) findViewById(R.id.OffersMiniBannerLayout);
		layoutOffersMiniBanner.addView(mMiniBanner);

		// (可选)使用积分Banner-一个新的积分墙入口点，随时随地让用户关注新的积分广告
		mBanner = new OffersBanner(this, OffersAdSize.SIZE_MATCH_SCREENx60);
		RelativeLayout layoutOffersBanner = (RelativeLayout) findViewById(R.id.offersBannerLayout);
		layoutOffersBanner.addView(mBanner);
	}
	
	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		// 注销积分监听-如果在onCreate注册了，那这里必须得注销
		PointsManager.getInstance(this).unRegisterNotify(this);
		// 如果使用积分广告，请务必调用积分广告的初始化接口:
		OffersManager.getInstance(this).onAppExit();
	}
	
	@Override
	public void onPointBalanceChange(int pointsBalance) {
		// TODO Auto-generated method stub
		// 积分SDK是在UI线程上回调该函数的，因此可直接操作UI，但切勿进行其他的长时间操作
		mTextViewPoints.setText("积分余额:" + pointsBalance);
	}

	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		switch (arg0.getId()) {
			case R.id.showOffersWall:
				//展示全屏的积分墙界面
				OffersManager.getInstance(this).showOffersWall();
				break;
			case R.id.showOffersDialog:
				//展示对话框的积分墙将界面
				//下面展示三种可选的调用方法:
			    // * 调用方式1.调用showOffersWallDialog显示默认的对话框样式积分墙:
				OffersManager.getInstance(this).showOffersWallDialog(this); 
				
			    // * 调用方式2.传入宽度和高度的像素值(注意：传入的宽高请确保是在竖屏状态下最佳的值，sdk会自动适应屏幕方向):
			    // OffersManager.getInstance(this).showOffersWallDialog(this,300,400); 
				
			    // * 调用方式3.传入宽度和高度占系统屏幕的百分比(注意,值类型为double，请确保大于0并小于1)
			    // OffersManager.getInstance(this).showOffersWallDialog(this,0.9d,0.95d);
				break;
			case R.id.showOffersSpot:
				OffersManager.getInstance(this).showOffersSpot();
				// 自定义插播的出现方式
				// OffersManager.getInstance(this).showOffersSpot(OffersManager.STYLE_SPOT_TOP_DOWN_REVERSE);
				break;
				
			case R.id.awardPoints:
				// demo 奖励10积分
				PointsManager.getInstance(this).awardPoints(10);
				// 注，调用该方法后，积分余额马上变更，可留意onPointBalanceChange是不是被调用了
				break;
			case R.id.spendPoints:
				// demo 消费20积分
				PointsManager.getInstance(this).spendPoints(20);
				// 注，调用该方法后，积分余额马上变更，可留意onPointBalanceChange是不是被调用了
				break;
			default:
				break;
		}
		
	}

}
