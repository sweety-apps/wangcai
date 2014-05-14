package com.punchbox.cocoaddemo;

import com.punchbox.ads.OfferWallButton;
import com.punchbox.exception.PBException;
import com.punchbox.listener.PointsChangeListener;

import android.app.Activity;
import android.app.AlertDialog;
import android.os.Bundle;
import android.os.Handler;
import android.widget.LinearLayout;

public class OfferWallButtonActivity extends Activity {

    Handler handler = new Handler();
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      //通过布局方式自动生成积分墙按钮
      setContentView(R.layout.activity_offerwallbutton);
      
      //通过代码方式创建精品推荐
      LinearLayout layout = (LinearLayout)findViewById(R.id.buttonContainer);
      try {
          OfferWallButton button = new OfferWallButton(this, "test");
          //设置监听，sdk会在每次展现积分墙的时候查询是否有积分返回。如果有，则回调下面的onPointsChanged
          button.setPointsChangeListener(new PointsChangeListener() {
            
            @Override
            public void onPointsChanged(double points) {
                showDialog(points);
            }
        });
        
        layout.addView(button);
      } catch (PBException e) {
            e.printStackTrace();
      }
          
     }
    
    private void showDialog(double points){
        if(points == 0){
            return;
        }
        
        if(this.isFinishing()){
            return;
        }
        
        
        final String tip = "可领取金币:" + points + ";\n";
       
        handler.post(new Runnable() {
            
            @Override
            public void run() {
                AlertDialog dialog = new AlertDialog.Builder(OfferWallButtonActivity.this)
                .setMessage(tip)
                .setTitle("提示")
                .setPositiveButton("OK", null)
                .create();
                dialog.show();
            }
        });
        
    }
}
