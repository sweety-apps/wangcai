package com.punchbox.cocoaddemo;

import com.punchbox.ads.AdRequest;
import com.punchbox.ads.InterstitialAd;
import com.punchbox.exception.PBException;
import com.punchbox.listener.AdListener;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

public class InterstitialAdActivity extends Activity implements AdListener{

    InterstitialAd ad;
    String placementID = "替换成您的广告位ID";//没有可以传空
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);

      setContentView(R.layout.activity_interstitial);
      
      //构建MoreGameAd实例
      ad = new InterstitialAd(this);
      //设置监听，本类继承了AdListener
      ad.setAdListener(this);
      
    //加载广告
      ad.loadAd(new AdRequest());
    }
    
    
    //通过xml布局文件中配置的按钮触发
    public void interstitialAd(View v){
        //先判断广告是否加载完成，只有加载完成后才能显示
        try {
            ad.showFloatView(this, 0.9, placementID);
        } catch (PBException e) {
            //当设置的scale不在范围内，或者isReady()属性为false
            e.printStackTrace();
        }
    }

    
    //以下监听回调
    @Override
    public void onReceiveAd() {
     // 对于固定广告在收到广告后回调，对于有预加载的弹出和精品推荐广告，仅仅是在预加载成功后回调，但不一定会展示
        Toast.makeText(getApplicationContext(), "onReceivedAd", Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onFailedToReceiveAd(PBException ex) {
        // 在请求广告失败后回调
        Toast.makeText(getApplicationContext(), ex.getErrorCode() + ex.getErrorMsg(), Toast.LENGTH_SHORT).show();
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
