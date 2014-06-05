package cn.domob.offer.wall.android;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import cn.domob.data.OErrorInfo;
import cn.domob.data.OManager;
import cn.domob.data.OManager.AddVideoWallListener;
import cn.domob.data.OManager.CacheVideoAdListener;
import cn.domob.data.OManager.ConsumeStatus;

public class DomobOfferWallDemoActivity extends Activity implements
		View.OnClickListener {

	private OManager mDomobOfferWallManager;
	private Context mContext;

	EditText  etEditText;
	TextView tvEditText;
		
	private  String PublisherID = "96ZJ2b8QzehB3wTAwQ";
	boolean isOnline;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.main);

		mContext = this;
		isOnline = true;

		findViewById(R.id.btn_wall_get).setOnClickListener(this);
		findViewById(R.id.btn_wall_use).setOnClickListener(this);
		findViewById(R.id.btn_wall_check).setOnClickListener(this);	
		etEditText =(EditText)findViewById(R.id.btn_wall_use_points);
		tvEditText = (TextView)findViewById(R.id.btn_wall_check_result);	
		findViewById(R.id.btn_wall_cache).setOnClickListener(this);
		findViewById(R.id.btn_wall_video).setOnClickListener(this);
		
		mDomobOfferWallManager = new OManager(mContext,PublisherID);
	}

	@Override
	public void onClick(View v) {
		int id = v.getId();
		switch (id) {
		case R.id.btn_wall_get:
			
			mDomobOfferWallManager.setAddWallListener(new OManager.AddWallListener() {

				@Override
				public void onAddWallFailed(
						OErrorInfo mDomobOfferWallErrorInfo) {

					showToast(mDomobOfferWallErrorInfo.toString());
				}

				@Override
				public void onAddWallClose() {
					//此处可以设置为横屏...
				}

				@Override
				public void onAddWallSucess() {

				}
			});
			mDomobOfferWallManager.loadOfferWall();
			break;
		case R.id.btn_wall_use:
			mDomobOfferWallManager.setConsumeListener(new OManager.ConsumeListener() {

						@Override
						public void onConsumeFailed(
								final OErrorInfo mDomobOfferWallErrorInfo) {
							showToast(mDomobOfferWallErrorInfo.toString());

						}

						@Override
						public void onConsumeSucess(final int point, final int consumed, final ConsumeStatus cs) {
							
							switch (cs) {
							case SUCCEED:
								showToast("消费成功:" + "总积分：" + point + "总消费积分："
										+ consumed);
								break;
							case OUT_OF_POINT:
								showToast("总积分不足，消费失败：" + "总积分：" + point
										+ "总消费积分：" + consumed);
								break;
							case ORDER_REPEAT:
								showToast("订单号重复，消费失败：" + "总积分：" + point
										+ "总消费积分：" + consumed);
								break;

							default:
								showToast("未知错误");
								break;
							}
						}
					});
			if(etEditText.getText().toString().trim()==null||etEditText.getText().toString().trim().equals("")){
				showToast("消费积分不能为空");
			}else{
				mDomobOfferWallManager.consumePoints(Integer.parseInt(etEditText.getText().toString()));
			}
			break;

		case R.id.btn_wall_check:
			mDomobOfferWallManager.setCheckPointsListener(new OManager.CheckPointsListener() {

				@Override
				public void onCheckPointsSucess(final int point,
						final int consumed) {
					showToast("总积分：" + point + "总消费积分：" + consumed);
					showText("总积分：" + point + "总消费积分：" + consumed);
				}

				@Override
				public void onCheckPointsFailed(
						final OErrorInfo mDomobOfferWallErrorInfo) {
					showToast(mDomobOfferWallErrorInfo.toString());
				}
			});
			mDomobOfferWallManager.checkPoints();
			break;
		
		case R.id.btn_wall_cache:
			//缓存广告
			mDomobOfferWallManager.cacheVideoAd();
			break;
		case R.id.btn_wall_video:
			mDomobOfferWallManager.setAddVideoWallListener(new AddVideoWallListener() {
				
				@Override
				public void onAddWallSucess() {
					Log.i("", "onAddWallSucess");
				}
				
				@Override
				public void onAddWallFailed(OErrorInfo mOErrorInfo) {
					Log.i("", "onAddWallFailed");
				}
				
				@Override
				public void onAddWallClose() {
					Log.i("", "onAddWallClose");
					//退出墙后需要再次设置屏幕方向
					((Activity) mContext)
					.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
				}
			});
			mDomobOfferWallManager.presentVideoWall();
			break;
		default:
			break;
		}
	}

	public void showToast(final String content) {
		((Activity) mContext).runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Toast.makeText(mContext, content, Toast.LENGTH_SHORT).show();
			}
		});
	}
	
	
	public void showText(final String content) {
		((Activity) mContext).runOnUiThread(new Runnable() {
			@Override
			public void run() {
				tvEditText.setText(content);
			}
		});
	}
	

    @Override  
    public boolean onKeyDown(int keyCode, KeyEvent event)  
    {  
        if (keyCode == KeyEvent.KEYCODE_BACK )  
        {  
        	finish();
        }  
        return false;            
    }  
    

   @Override
   public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
         if(this.getResources().getConfiguration().orientation ==Configuration.ORIENTATION_LANDSCAPE) {
              // land donothing is ok
         } else if(this.getResources().getConfiguration().orientation ==Configuration.ORIENTATION_PORTRAIT) {
              // port donothing is ok
         }
   } 
}