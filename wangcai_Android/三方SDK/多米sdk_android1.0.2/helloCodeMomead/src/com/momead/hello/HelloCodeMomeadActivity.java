package com.momead.hello;
import com.momead.sdk.MomeadLayout;

import android.app.Activity;
import android.os.Bundle;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

public class HelloCodeMomeadActivity extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
      //初始化cmadLayout
      MomeadLayout momeadLayout = new MomeadLayout(this);
      //获取由于装载广告的layout
      RelativeLayout adlayout = (RelativeLayout)findViewById(R.id.adLayout);
      //设置装载广告layout的相关属性
      RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(LayoutParams.FILL_PARENT ,LayoutParams.WRAP_CONTENT );
      //ALIGN_TOP为顶部广告,ALIGN_PARENT_BOTTOM为底部广告
      lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM); 
      adlayout.addView(momeadLayout,lp);        
      adlayout.invalidate();//刷新屏幕
    }
}