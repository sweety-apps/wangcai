package net.miidi.sample.banner;

import net.miidi.ad.banner.AdBannerManager;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

public class MiidiSample_BannerActivity extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        AdBannerManager.init(this, "6", "6666666666666666");
        setContentView(bannerSampleLayoutView());  
    }
    
    
    private View bannerSampleLayoutView()
    {
    	LinearLayout adkLayout=new LinearLayout(this);
    	adkLayout.setOrientation(LinearLayout.VERTICAL);     	
    	
    	////////////////////////////////////////////////////////////
    	//xml布局方式
    	////////////////////////////////////////////////////////////
    	Button xmlBtn=new Button(this);
    	xmlBtn.setText(R.string.label_xmllayout);
    	xmlBtn.setOnClickListener(new Button.OnClickListener()
    	{
    		@Override
    		public void onClick(View v) {
    			// TODO Auto-generated method stub
    			
    			try{
	    			Intent intent=new Intent(MiidiSample_BannerActivity.this,BannerXmlActivity.class);
	    			
	    			startActivity(intent);
    			}catch (Exception e) {
					// TODO: handle exception
    				e.printStackTrace();

				}
    		}
    	});	    	
    	adkLayout.addView(xmlBtn);
    	
    	///////////////////////////////////////////////////////
    	//代码布局方式 
    	///////////////////////////////////////////////////////
    	Button codeBtn=new Button(this);
    	codeBtn.setText(R.string.label_codelayout);
    	codeBtn.setOnClickListener(new Button.OnClickListener(){
    		@Override
    		public void onClick(View v) {
    			// TODO Auto-generated method stub
    			try{
	    			Intent intent=new Intent(MiidiSample_BannerActivity.this,BannerCodeActivity.class);
	    			startActivity(intent);
    			}
    			catch (Exception e) 
    			{
					// TODO: handle exception
    				e.printStackTrace();
				}   		
    			
    		}
    	});
    	adkLayout.addView(codeBtn);
    	
    	//////////////////////////////////////////////////
    	// 悬浮布局
    	//////////////////////////////////////////////////
    	Button suspendBtn=new Button(this);
    	suspendBtn.setText(R.string.label_suspendlayout);
    	suspendBtn.setOnClickListener(new Button.OnClickListener()
    	{
    		@Override
    		public void onClick(View v) 
    		{
    			// TODO Auto-generated method stub
    			try{
	    			Intent intent=new Intent(MiidiSample_BannerActivity.this,BannerSuspendActivity.class);
	    			startActivity(intent);
    			}catch (Exception e) {
					// TODO: handle exception
    				e.printStackTrace();
				}
    		}
    	});
    	adkLayout.addView(suspendBtn); 
    	
    	
    	
    	//////////////////////////////////////////////////
    	// 显示sdk版本
    	//////////////////////////////////////////////////
    	TextView versionTextView = new TextView(this);
    	versionTextView.setText("Miidi SDK Version: " + AdBannerManager.getSdkVersion());
    	adkLayout.addView( versionTextView); 
    	//
    	return adkLayout;
    }
}