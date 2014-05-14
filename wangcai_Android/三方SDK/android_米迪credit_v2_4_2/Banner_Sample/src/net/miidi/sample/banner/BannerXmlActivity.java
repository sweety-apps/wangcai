package net.miidi.sample.banner;


import net.miidi.ad.banner.AdsView;
import net.miidi.ad.banner.IAdViewNotifier;
import android.app.Activity;
import android.os.Bundle;

public class BannerXmlActivity extends Activity  implements IAdViewNotifier{
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		//
		setContentView(R.layout.adviewxml); 
		
		AdsView adView = (AdsView)findViewById(R.id.adView);
		/***
    	 * 设置广告条banner监听事件
    	 * @param notifer
    	 */
        adView.setAdViewListener(this);
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
