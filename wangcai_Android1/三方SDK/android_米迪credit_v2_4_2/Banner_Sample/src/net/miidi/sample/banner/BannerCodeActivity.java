package net.miidi.sample.banner;




import net.miidi.ad.banner.AdsView;
import net.miidi.ad.banner.IAdViewNotifier;
import android.app.Activity;
import android.os.Bundle;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;

public class BannerCodeActivity extends Activity implements IAdViewNotifier{

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		LinearLayout layout=new LinearLayout(this); 
	    layout.setOrientation(LinearLayout.VERTICAL); 
	    
	      
	    //
	    AdsView adView = new AdsView(this);   
	    /***
    	 * 设置广告条banner监听事件
    	 * @param notifer
    	 */
        adView.setAdViewListener(this);
	    
	    LayoutParams params = new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT);
	    layout.addView(adView, params); 
	//      
	    setContentView(layout);
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
