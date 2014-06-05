package net.miidi.sample.wall;

import java.util.List;

import net.miidiwall.SDK.AdWall;
import net.miidiwall.SDK.AppSignInCell;



import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;

public class AppSignInActivity extends Activity {

	private List<AppSignInCell> mAppList;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mAppList = AdWall.requestAppSignInList();
		
		if(mAppList != null && mAppList.size() > 0)
		{
		
			LinearLayout layout=new LinearLayout(this); 
		    layout.setOrientation(LinearLayout.VERTICAL); 
		    
		      
		    //
		    View listView = createListView();   
		   
		    layout.addView(listView); 
		//      
		    setContentView(layout);
		}
		else{
			Toast toast = Toast.makeText(getApplicationContext(),
				     "需要签到的数据为空", Toast.LENGTH_LONG);
				   toast.setGravity(Gravity.CENTER, 0, 0);
				   toast.show();
			finish();
		}
	}
	
	/**
     * 新建适配后的ListView
     * @return ListView实例
     */
    private View createListView(){
    	ListView listView = new ListView(this);
    	
    	if(mAppList != null && mAppList.size() > 0){
	    	listView.setAdapter(new CustomAdapter(this, mAppList));
	    	listView.setOnItemClickListener(new OnItemClickListener() {
				@Override
				public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
					// 点击,启动签到服务
					AdWall.requestAppSignInEffect(mAppList.get(position).getAdId());
				}
			});
	    	return listView;
    	}else{
    		return null;
    	}
    	
    }
    
    /**
     * 用于数据源广告列表的Adapter
     */
    private class CustomAdapter extends BaseAdapter{
    	Context context;
    	List<AppSignInCell> list;
    	public CustomAdapter(Context context, List<AppSignInCell> list){
    		this.context = context;
    		this.list = list;
    	}
    	
		@Override
		public int getCount() {
			return list.size();
		}

		@Override
		public Object getItem(int position) {
			return list.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			RelativeLayout r_layout;
        	ImageView app_icon;
        	TextView app_name;
        	RelativeLayout.LayoutParams rlp = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
        	
        	AppSignInCell appCell = list.get(position);
    		r_layout = new RelativeLayout(context);
    		app_icon = new ImageView(context);
    		app_icon.setId(1);
    		app_name = new TextView(context);
    		
    		app_icon.setLayoutParams(new LayoutParams(75,75));
    		app_icon.setScaleType(ImageView.ScaleType.FIT_CENTER);
    		
    		rlp.addRule(RelativeLayout.RIGHT_OF, app_icon.getId());
    		rlp.addRule(RelativeLayout.CENTER_VERTICAL);
            app_icon.setImageDrawable(new BitmapDrawable(appCell.icon));  
            app_icon.setPadding(5, 5, 5, 5);
            
            app_name.setText(appCell.title );
            app_name.setTextSize(18);
            app_name.setTextColor(Color.WHITE);
            app_name.setPadding(10, 0, 0, 0);
            
            TextView content = new TextView(context);
            content.setText(appCell.text);
            content.setPadding(10, 0, 0, 0);
            
            LinearLayout layout  = new LinearLayout(context);
            layout.setOrientation(LinearLayout.VERTICAL);
            
            layout.addView(app_name);
            layout.addView(content);
            
            r_layout.addView(app_icon);
            r_layout.addView(layout, rlp);
            
        	convertView = r_layout;
        	convertView.setTag(r_layout);
            return r_layout;
		}
    }

}
