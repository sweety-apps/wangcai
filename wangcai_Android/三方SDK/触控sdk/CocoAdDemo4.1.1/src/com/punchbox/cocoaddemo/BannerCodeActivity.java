package com.punchbox.cocoaddemo;
import android.app.Activity;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

import com.punchbox.ads.AdRequest;
import com.punchbox.ads.AdView;
import com.punchbox.exception.PBException;
import com.punchbox.listener.AdListener;

public class BannerCodeActivity extends Activity implements AdListener{
  private AdView adView;
  private String placementID = "abcd";//替换您的广告位ID，没有就传空

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_banner_code);

    // 创建 adView, 如果不传入placementID，可以用另一个构造函数AdView(context)
    adView = new AdView(this, placementID);

    // 查找 LinearLayout，假设其已获得
    // 属性 android:id="@+id/mainLayout"
    LinearLayout layout = (LinearLayout)findViewById(R.id.mainLayout);
    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
    params.gravity = Gravity.RIGHT;
    // 在其中添加 adView
//    layout.addView(adView);
    addContentView(adView, params);
    // 启动一般性请求并在其中加载广告
    adView.loadAd(new AdRequest());
  }
  
  @Override
  public void onDestroy() {
    adView.destroy();
    super.onDestroy();
  }
  
  

    @Override
    public void onReceiveAd() {
        // 对于固定广告在收到广告后回调，对于有预加载的弹出和精品推荐广告，仅仅是在预加载成功后回调，但不一定会展示
        
    }
    
    @Override
    public void onFailedToReceiveAd(PBException ex) {
        // 在请求广告失败后回调
        
    }
    
    @Override
    public void onPresentScreen() {
        // 展示广告时回调 
        
    }
    
    @Override
    public void onDismissScreen() {
      //广告移除时回调
        
    }
}
