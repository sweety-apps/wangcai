package com.jpmob.walldemo;


import com.jpmob.sdk.wall.JupengWallConnector;
import com.jpmob.sdk.wall.JupengWallListener;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.app.Activity;
import android.app.AlertDialog;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class MainActivity extends Activity implements JupengWallListener {
	
	private TextView 	scoresTextView;
	private TextView 	sdkVersionTextView;
	
	private String 		scoresText;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		
		// 设置SDK监听
		JupengWallConnector.getInstance(this).setListener(this);
		// 设置SDK帐号
		JupengWallConnector.getInstance(this).startWall("800", "800800800");

		
		scoresTextView = (TextView) findViewById(R.id.ScoresTextView);
         sdkVersionTextView = (TextView) findViewById(R.id.SdkVersionTextView);
         // 获取SDK版本
         sdkVersionTextView.setText(JupengWallConnector.getInstance(this).getSdkVersion()); 
         
         Button button = (Button)findViewById(R.id.btn_wall);
         button.setOnClickListener(onClickListener_wall);
         
         button = (Button)findViewById(R.id.btn_getscores);
         button.setOnClickListener(onClickListener_getScores);
         
         button = (Button)findViewById(R.id.btn_spendscores);
         button.setOnClickListener(onClickListener_spendScores);
         
         button = (Button)findViewById(R.id.btn_awardscores);
         button.setOnClickListener(onClickListener_awardScores);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	 // 积分墙
    private OnClickListener onClickListener_wall = new OnClickListener() {
		
		@Override
		public void onClick(View v) 
		{			

			JupengWallConnector.getInstance(MainActivity.this).showOffers();
				
		}
	};
	
	// 查看积分[异步]
    private OnClickListener onClickListener_getScores = new OnClickListener() {
		
		@Override
		public void onClick(View v) 
		{			
		
			JupengWallConnector.getInstance(MainActivity.this).getTotalMoney();
				
		}
	};
	
	// 消费10个积分[异步]
	private OnClickListener onClickListener_spendScores = new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
						
				JupengWallConnector.getInstance(MainActivity.this).spendMoney(10);
			}
	};
	
	//	增加10个积分[异步]
	private OnClickListener onClickListener_awardScores = new OnClickListener() {
		
		@Override
		public void onClick(View v) 
		{
			
			JupengWallConnector.getInstance(MainActivity.this).giveMoney(10);
		}
	};

	// -------------------- from implements JupengWallListener -------------------------- //

	@Override
	public void dismissAppWall() {
		// TODO Auto-generated method stub
		Log.d("巨朋积分墙","关闭巨朋积分墙的Activity");
	}

	@Override
	public void getTotalMoneyFail() {
		// TODO Auto-generated method stub
		Log.e("巨朋积分墙","查询积分失败!");
	}

	@Override
	public void getTotalMoneySuccess(Integer moneyTotal) {
		// TODO Auto-generated method stub
		scoresText =  "查询积分成功，目前总积分值：" + moneyTotal ;
		mHandler.sendEmptyMessage(1);
	}

	@Override
	public void giveMoneyFail() {
		// TODO Auto-generated method stub
		Log.e("巨朋积分墙","增加积分失败!");
	}

	@Override
	public void giveMoneySuccess(Integer moneyTotal) {
		// TODO Auto-generated method stub
		scoresText = "增加积分成功，目前总积分值:" +  moneyTotal;
		mHandler.sendEmptyMessage(1);
	}

	@Override
	public void monitorMoney(String appName, String appPackageName, Integer moneyTotal) {
		// TODO Auto-generated method stub
		Log.d("巨朋积分墙","积分发生更改,目前积分值：" + moneyTotal);
	}

	@Override
	public void showAppWall() {
		// TODO Auto-generated method stub
		Log.d("巨朋积分墙","开启积分墙");
	}

	@Override
	public void spendMoneyFail() {
		// TODO Auto-generated method stub
		Log.e("巨朋积分墙","减少积分失败!");
	}

	@Override
	public void spendMoneySuccess(Integer moneyTotal) {
		// TODO Auto-generated method stub
		scoresText = "减少积分成功，目前总积分值:" +  moneyTotal;
		mHandler.sendEmptyMessage(1);
	}

	
	// -----------------//
	Handler mHandler = new Handler()
	{

		@Override
		public void handleMessage(Message msg) {
			// TODO Auto-generated method stub
			switch(msg.what)
			{
			case 1: // 获取到积分值,通知监听者
				scoresTextView.setText(scoresText);
				showMessageBox("巨朋积分墙",scoresText);
				break;
				
			default:
				break;
					
			}
		}
	};

	private void showMessageBox(String title, String msg) {
		try {

			new AlertDialog.Builder(this).setTitle(title).setMessage(msg)
					.create().show();

		} catch (Exception e) {
			// TODO: handle exception
		}
	}

}
