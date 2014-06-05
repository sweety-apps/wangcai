package com.punchbox.cocoaddemo;

import com.punchbox.ads.AdRequest;
import com.punchbox.ads.OfferWallAd;
import com.punchbox.exception.PBException;

import android.app.Activity;
import android.app.AlertDialog;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.Toast;

public class OfferWallActivity extends Activity{

    OfferWallAd ad;
    String placementID = "替换成您的广告位ID";//没有可以为空
    
    Handler handler = new Handler();
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);

      setContentView(R.layout.activity_offerwall);
      
      //构建OfferWallAd实例
      ad = new OfferWallAd(this);
      //加载广告
      ad.loadAd(new AdRequest());
    }
    
    //在xml布局文件中配置的按钮触发此函数
    public void offerWall(View v){
        //先判断广告是否加载完成，只有加载完成后才能显示
        try {
            ad.showFloatView(this, 1.0, placementID);
        } catch (PBException e) {
            //当设置的scale不在范围内，或者isReady()属性为false
            e.printStackTrace();
        }
    }
    //查询积分
    public void query(View v){
        double points = ad.queryPoints();
        showDialog(points);
    }
    
    private void showDialog(double points){
        if(points == 0){
            Toast.makeText(getApplicationContext(), "目前还没有积分可返回", Toast.LENGTH_SHORT).show();
            return;
        }
        if(this.isFinishing()){
            return;
        }
        
        final String tip = "可领取金币:" + points + ";\n" ;
        
        handler.post(new Runnable() {
            
            @Override
            public void run() {
                AlertDialog dialog = new AlertDialog.Builder(OfferWallActivity.this)
                .setMessage(tip)
                .setTitle("提示")
                .setPositiveButton("OK", null)
                .create();
                dialog.show();
            }
        });
        
    }
}
