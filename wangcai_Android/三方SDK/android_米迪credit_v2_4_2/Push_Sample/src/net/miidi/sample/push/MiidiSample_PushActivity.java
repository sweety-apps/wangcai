package net.miidi.sample.push;


import net.miidipush.SDK.SDKConnector;
import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class MiidiSample_PushActivity extends Activity {
	private Button 		btn_1;	
	
	private TextView 	sdkVersionTextView;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    
        // 设置应用的开发者帐号信息，appId和appPassword是在米迪广告平台网站上，注册后会提交应用后，网站提供的信息
        SDKConnector.getInstance(this).setAppId("6", "6666666666666666");
        setContentView(R.layout.main);
        
     // 设置push广告的显示icon
        SDKConnector.getInstance(this).setIconId(R.drawable.ic_launcher);
        
        sdkVersionTextView = (TextView) findViewById(R.id.SdkVersionTextView);
        sdkVersionTextView.setText(SDKConnector.getInstance(this).getVersion());
   
        
        btn_1 = (Button)findViewById(R.id.btn_1);
      
        
        btn_1.setOnClickListener(onClickListener_1);
        
    }
    
    // 推送广告[API方式]
    private OnClickListener onClickListener_1 = new OnClickListener() {
		
		@Override
		public void onClick(View v) 
		{			

			SDKConnector.getInstance(MiidiSample_PushActivity.this).PushByAPI();
		}
	};

	
}