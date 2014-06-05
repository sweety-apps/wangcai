package com.punchbox.cocoaddemo;

import com.punchbox.ads.MoreGameButton;
import com.punchbox.exception.PBException;

import android.app.Activity;
import android.os.Bundle;
import android.widget.LinearLayout;

public class MoreGameButtonActivity extends Activity {

    
    @Override
    public void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      //通过布局方式自动生成精品推荐按钮
      setContentView(R.layout.activity_moregamebutton);
      
      //通过代码方式创建精品推荐
      LinearLayout layout = (LinearLayout)findViewById(R.id.buttonContainer);
      try {
          MoreGameButton button = new MoreGameButton(this, "test");
          layout.addView(button);
      } catch (PBException e) {
            e.printStackTrace();
      }
          
     }
}
