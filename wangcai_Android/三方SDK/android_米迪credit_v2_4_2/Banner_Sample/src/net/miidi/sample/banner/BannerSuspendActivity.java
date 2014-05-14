package net.miidi.sample.banner;


import net.miidi.ad.banner.AdsView;
import net.miidi.ad.banner.IAdViewNotifier;
import android.app.Activity;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.FrameLayout;
import android.widget.LinearLayout;

public class BannerSuspendActivity extends Activity  implements IAdViewNotifier{

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		//
		LinearLayout layout=new LinearLayout(this); 
	    layout.setOrientation(LinearLayout.VERTICAL); 
		setContentView(layout); 
		
		
		////////////
		AdsView adView = new AdsView(this); 
		/***
    	 * 设置广告条banner监听事件
    	 * @param notifer
    	 */
        adView.setAdViewListener(this);
        
		
		FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.FILL_PARENT, FrameLayout.LayoutParams.WRAP_CONTENT);
		
		//
		params.bottomMargin=0;
		params.gravity=Gravity.BOTTOM; 
		
		//
		addContentView(adView, params); 
		
		//
		
	}
	
	/***
	 * 点击广告事件通知
	 * @param view
	 */
	@Override
	public void onClickedAdCb(AdsView adview) {
		// TODO Auto-generated method stub
		
	}

	/***
	 * 广告引擎请求广告失败，通知监听者
	 * @param errDesc 错误描述
	 */
	@Override
	public void onFailedAdCb(String errDesc) {
		// TODO Auto-generated method stub
		
	}

	/***
	 * 切换广告通知
	 * @param view
	 */
	@Override
	public void onSwitchAdCb(AdsView adview) {
		// TODO Auto-generated method stub
		
	}
}
