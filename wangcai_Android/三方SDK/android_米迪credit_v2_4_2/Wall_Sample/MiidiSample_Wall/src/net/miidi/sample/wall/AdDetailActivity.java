package net.miidi.sample.wall;



import java.util.List;




import net.miidiwall.SDK.AdDesc;
import net.miidiwall.SDK.AdWall;
import net.miidiwall.SDK.IAdWallRequestAdSourceNotifier;

import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;


import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

public class AdDetailActivity extends Activity implements IAdWallRequestAdSourceNotifier {
	
	//
	final Handler mHandler = new Handler();
	
	
	//

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		//
		AdWall.requestAdSource(this);
		
		
	}
	
	
	/**
     * 显示广告详情
     * @param adInfo 
     */
	public View showAdDetail(final AdDesc adInfo){
    	try {

    		if(adInfo != null){
    		
				View view = View.inflate(this, R.layout.detail, null);
				ImageView icon = (ImageView) view.findViewById(R.id.detail_icon);
				TextView title = (TextView) view.findViewById(R.id.detail_title);
				TextView version = (TextView) view.findViewById(R.id.detail_version);
				TextView filesize = (TextView) view.findViewById(R.id.detail_filesize);
				TextView points = (TextView) view.findViewById(R.id.detail_points);
				Button downButton1 = (Button) view.findViewById(R.id.detail_downButton1);
				TextView content = (TextView) view.findViewById(R.id.detail_content);
				TextView description = (TextView) view.findViewById(R.id.detail_description);
				ImageView image1 = (ImageView) view.findViewById(R.id.detail_image1);
				
				
				icon.setImageBitmap(adInfo.icon);
				icon.setScaleType(ImageView.ScaleType.FIT_CENTER);
				title.setText(adInfo.title);
				version.setText("  "+adInfo.appVersion);
				filesize.setText("  "+String.format("%.2f", adInfo.appSize / (1024.0 * 1024.0))+"M");
				points.setText(adInfo.appAction + "送"+String.valueOf(adInfo.points)+ AdWall.requestCreditTitle());
				content.setText(adInfo.text);
				description.setText(adInfo.description);
				
				new ImagesTaskOnServer(adInfo, image1).execute();
			
				downButton1.setText(adInfo.appAction);
				downButton1.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						
						// 点击广告
						AdWall.requestAdEffect(adInfo.getAdId());
					}
				});
				
				return view;
			

			}else{

			}
    		
;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
    	
    	return null;
    }
	
	/**
	 * 获取广告截图
	 */
	private class ImagesTaskOnServer extends AsyncTask<Void, Void, Boolean> {
		Bitmap bitmap1;
		
		AdDesc adInfo;
		ImageView image1;
		
		public ImagesTaskOnServer(AdDesc adInfo, ImageView image1){
			this.adInfo = adInfo;
			this.image1 = image1;
			
		}
		@Override
		protected Boolean doInBackground(Void... params) {
			boolean returnValue = false;
			
			try {
				bitmap1 = BitmapFactory.decodeStream(
					new DefaultHttpClient().execute(new HttpGet(adInfo.appImageUrls[0])).getEntity().getContent());
				
			} catch (Exception e) {
				e.printStackTrace();
			}

			return returnValue;
		}
		@Override
		protected void onPostExecute(Boolean result) {
			try {
				if (bitmap1 != null ) {
					mHandler.post(new Runnable() {
						@Override
						public void run() {
							try {
								image1.setImageBitmap(bitmap1);
								
							} catch (Exception e) {
								e.printStackTrace();
							}
						}
					});
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public void onFailedGetAdSource(String errMsg) {
		// TODO Auto-generated method stub
		Toast toast = Toast.makeText(getApplicationContext(),
			     "未获取到广告源数据", Toast.LENGTH_LONG);
	    toast.setGravity(Gravity.CENTER, 0, 0);
	    toast.show();
	}


	@Override
	public void onGetAdSource(List adSourceList) {
		// TODO Auto-generated method stub
		if(adSourceList != null && adSourceList.size() > 0){
//			
			AdDesc addesc = (AdDesc)adSourceList.get(0);
			LinearLayout layout=new LinearLayout(this); 
		    layout.setOrientation(LinearLayout.VERTICAL); 
		    
		      
		    //
		    View detailView = showAdDetail(addesc);   
		   
		    layout.addView(detailView); 
		//      
		    setContentView(layout);
		}
		
		else{
			Toast toast = Toast.makeText(getApplicationContext(),
				     "未获取到广告源数据", Toast.LENGTH_LONG);
		    toast.setGravity(Gravity.CENTER, 0, 0);
		    toast.show();
		}
	}

}
