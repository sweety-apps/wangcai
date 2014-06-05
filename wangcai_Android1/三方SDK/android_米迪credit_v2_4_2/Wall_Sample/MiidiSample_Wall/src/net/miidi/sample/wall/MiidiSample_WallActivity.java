package net.miidi.sample.wall;




import net.miidiwall.SDK.AdWall;
import net.miidiwall.SDK.IAdWallAwardPointsNotifier;
import net.miidiwall.SDK.IAdWallGetPointsNotifier;
import net.miidiwall.SDK.IAdWallShowAppsNotifier;
import net.miidiwall.SDK.IAdWallSpendPointsNotifier;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;


public class MiidiSample_WallActivity extends Activity 
	implements   IAdWallShowAppsNotifier 
			   , IAdWallGetPointsNotifier
			   , IAdWallAwardPointsNotifier
			   , IAdWallSpendPointsNotifier
			   
	{
	private Button 		btn_1, btn_2, btn_3 , btn_4, btn_5,btn_6,btn_7,btn_8;	
	private TextView 	pointsTextView;
	private TextView 	sdkVersionTextView;
	
	private String 		pointsText;
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        AdWall.init(this, "6", "6666666666666666");
        setContentView(R.layout.main);
        
        pointsTextView = (TextView) findViewById(R.id.PointsTextView);
        sdkVersionTextView = (TextView) findViewById(R.id.SdkVersionTextView);
        sdkVersionTextView.setText(AdWall.getSdkVersion());
   
        
        btn_1 = (Button)findViewById(R.id.btn_1);
        btn_2 = (Button)findViewById(R.id.btn_2);
        btn_3 = (Button)findViewById(R.id.btn_3);
        btn_4 = (Button)findViewById(R.id.btn_4);
        btn_5 = (Button)findViewById(R.id.btn_5);
        btn_6 = (Button)findViewById(R.id.btn_6);
        btn_7 = (Button)findViewById(R.id.btn_7);
        btn_8 = (Button)findViewById(R.id.btn_8);

       
         
        btn_1.setOnClickListener(onClickListener_1);
        btn_2.setOnClickListener(onClickListener_2);
        btn_3.setOnClickListener(onClickListener_3);
        btn_4.setOnClickListener(onClickListener_4);
        btn_5.setOnClickListener(onClickListener_5);
        btn_6.setOnClickListener(onClickListener_6);
        btn_7.setOnClickListener(onClickListener_7);
        btn_8.setOnClickListener(onClickListener_8);

        
        
    }
    
 // 广告墙[下载应用，赚积分]
    private OnClickListener onClickListener_1 = new OnClickListener() {
		
		@Override
		public void onClick(View v) 
		{			

			AdWall.showAppOffers(MiidiSample_WallActivity.this);
				
		}
	};
	
	 // 无积分的推荐墙
    private OnClickListener onClickListener_2 = new OnClickListener() {
		
		@Override
		public void onClick(View v) 
		{			

			AdWall.showAppOffersNoScore(MiidiSample_WallActivity.this);
				
		}
	};

	// 查看积分[异步]
    private OnClickListener onClickListener_3 = new OnClickListener() {
		
		@Override
		public void onClick(View v) 
		{			
			AdWall.getPoints(MiidiSample_WallActivity.this);
				
		}
	};
	
	
	// 消费20个积分[异步]
	private OnClickListener onClickListener_4 = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			int amount = 20 ;
			AdWall.spendPoints(amount,MiidiSample_WallActivity.this);			
					
		}
	};
			
	
	
	//	增加20个积分[异步]
	private OnClickListener onClickListener_5 = new OnClickListener() {
		
		@Override
		public void onClick(View v) 
		{
			int amount = 20 ;
			AdWall.awardPoints(amount,MiidiSample_WallActivity.this);
		}
	};
	
	
	// 广告列表数据源[异步]
		private OnClickListener onClickListener_6 = new OnClickListener() {
				
				@Override
				public void onClick(View v) 
				{					

						try{
			    			Intent intent=new Intent(MiidiSample_WallActivity.this,AdListActivity.class);
			    			
			    			startActivity(intent);

		    			}catch (Exception e) {
							// TODO: handle exception
		    				e.printStackTrace();

						}

				}
		};
		

		// 单条广告数据源[异步]
		private OnClickListener onClickListener_7 = new OnClickListener() {
			
			@Override
			public void onClick(View v) 
			{
				

					try{
		    			Intent intent=new Intent(MiidiSample_WallActivity.this,AdDetailActivity.class);
		    			
		    			startActivity(intent);

	    			}catch (Exception e) {
						// TODO: handle exception
	    				e.printStackTrace();

					}

			}
		};
		
	

			// 应用签到服务
			private OnClickListener onClickListener_8 = new OnClickListener() {
				
				@Override
				public void onClick(View v) 
				{
					try{
		    			Intent intent=new Intent(MiidiSample_WallActivity.this,AppSignInActivity.class);
		    			
		    			startActivity(intent);

	    			}catch (Exception e) {
						// TODO: handle exception
	    				e.printStackTrace();

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

	// -------------- from IAdWallSpendPointsNotifier --------------------// 
		@Override
		public void onSpendPoints(String currencyName, Integer pointTotal) {
			// TODO Auto-generated method stub
			pointsText = currencyName + ":" +  pointTotal;
			mHandler.sendEmptyMessage(1);
		}

		@Override
		public void onFailSpendPoints() {
			// TODO Auto-generated method stub
			Log.e("AdWall","消费积分失败!");
			
		}
		
		// ---------------IAdWallSpendPointsNotifier  end -----------------//

		// -------------- from IAdWallAwardPointsNotifier --------------------// 
		@Override
		public void onAwardPoints(String currencyName, Integer pointTotal) {
			// TODO Auto-generated method stub
			pointsText = currencyName + ":" +  pointTotal;
			mHandler.sendEmptyMessage(1);
		}

		@Override
		public void onFailAwardPoints() {
			// TODO Auto-generated method stub
			Log.e("AdWall","增加积分失败!");
			
		}
		// --------------- IAdWallAwardPointsNotifier end ------------------//

		// -------------- from IAdWallGetPointsNotifier --------------------// 
		@Override
		public void onReceivePoints(String currencyName, Integer pointTotal) {
			// TODO Auto-generated method stub
			pointsText = currencyName + ":" +  pointTotal;
			mHandler.sendEmptyMessage(1);
		}

		@Override
		public void onFailReceivePoints() {
			// TODO Auto-generated method stub
			Log.e("AdWall","查询积分失败!");
			
		}
		// --------------- IAdWallGetPointsNotifier end --------------------//

		// -------------- from IAdWallShowAppsNotifier --------------------// 
		@Override
		public void onShowApps() {
			// TODO Auto-generated method stub
			Log.d("AdWall","开始显示积分墙的Activity");
		}

		@Override
		public void onDismissApps() {
			// TODO Auto-generated method stub
			Log.d("AdWall","关闭积分墙的Activity");
		}
		// --------------- IAdWallShowAppsNotifier end --------------------//
		
		
		
		
		Handler mHandler = new Handler()
		{

			@Override
			public void handleMessage(Message msg) {
				// TODO Auto-generated method stub
				switch(msg.what)
				{
				case 1: // 获取到积分值,通知监听者
					pointsTextView.setText(pointsText);
					showMessageBox("success",pointsText);
					break;
					
				
					
			
				default:
					break;
						
				}
			}

		};
		
		
		
		
}