package com.imopan.mpwallsample;

import com.imopan.mpwall.IWallNotifier;
import com.imopan.mpwall.MopanWallManager;


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

public class MainActivity extends Activity implements IWallNotifier {
	
	private TextView 	scoresTextView;
	private TextView 	sdkVersionTextView;
	
	private String 		scoresText;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		// 设置磨盘SDK监听
		MopanWallManager.getInstance(this).setListener(this);
		// 设置磨盘SDK帐号
		MopanWallManager.getInstance(this).startMopanWall("10000", "0123456789");
		
		scoresTextView = (TextView) findViewById(R.id.ScoresTextView);
         sdkVersionTextView = (TextView) findViewById(R.id.SdkVersionTextView);
         // 获取SDK版本
         sdkVersionTextView.setText(MopanWallManager.getInstance(this).getSdkVersion()); 
         
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

			MopanWallManager.getInstance(MainActivity.this).showAppWall();
				
		}
	};
	
	// 查看积分[异步]
    private OnClickListener onClickListener_getScores = new OnClickListener() {
		
		@Override
		public void onClick(View v) 
		{			
		
			MopanWallManager.getInstance(MainActivity.this).getScores();
				
		}
	};
	
	// 消费10个积分[异步]
	private OnClickListener onClickListener_spendScores = new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
						
				MopanWallManager.getInstance(MainActivity.this).spendScores(10);
			}
	};
	
	//	增加10个积分[异步]
	private OnClickListener onClickListener_awardScores = new OnClickListener() {
		
		@Override
		public void onClick(View v) 
		{
			
			MopanWallManager.getInstance(MainActivity.this).awardScores(10);
		}
	};

	// -------------------- from implements IWallNotifier -------------------------- //
	@Override
	public void onDismissApps() {
		// TODO Auto-generated method stub
		Log.d("磨盘积分墙","关闭积分墙");
	}

	@Override
	public void onEarnScores(String appName, String appPackageName, Integer scoreTotal) {
		// TODO Auto-generated method stub
		Log.d("磨盘积分墙","积分发生更改,目前积分值：" + scoreTotal);
	}

	@Override
	public void onFailAwardScores() {
		// TODO Auto-generated method stub
		Log.e("磨盘积分墙","增加积分失败!");
	}

	@Override
	public void onFailGetScores() {
		// TODO Auto-generated method stub
		Log.e("磨盘积分墙","查询积分失败!");
	}

	@Override
	public void onFailSpendScores() {
		// TODO Auto-generated method stub
		Log.e("磨盘积分墙","减少积分失败!");
	}

	@Override
	public void onShowApps() {
		// TODO Auto-generated method stub
		Log.d("磨盘积分墙","开启积分墙");
	}

	@Override
	public void onSuccessAwardScores(Integer scoreTotal) {
		// TODO Auto-generated method stub
		scoresText = "增加积分成功，目前总积分值:" +  scoreTotal;
		mHandler.sendEmptyMessage(1);
	}

	@Override
	public void onSuccessGetScores(Integer scoreTotal) {
		// TODO Auto-generated method stub
		scoresText =  "查询积分成功，目前总积分值：" + scoreTotal ;
		mHandler.sendEmptyMessage(1);
		
	}

	@Override
	public void onSuccessSpendScores(Integer scoreTotal) {
		// TODO Auto-generated method stub
		scoresText = "减少积分成功，目前总积分值:" +  scoreTotal;
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
				showMessageBox("磨盘积分墙",scoresText);
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
