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
      //��ʼ��cmadLayout
      MomeadLayout momeadLayout = new MomeadLayout(this);
      //��ȡ����װ�ع���layout
      RelativeLayout adlayout = (RelativeLayout)findViewById(R.id.adLayout);
      //����װ�ع��layout���������
      RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(LayoutParams.FILL_PARENT ,LayoutParams.WRAP_CONTENT );
      //ALIGN_TOPΪ�������,ALIGN_PARENT_BOTTOMΪ�ײ����
      lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM); 
      adlayout.addView(momeadLayout,lp);        
      adlayout.invalidate();//ˢ����Ļ
    }
}