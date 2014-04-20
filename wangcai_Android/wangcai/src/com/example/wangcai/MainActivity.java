package com.example.wangcai;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Button;
import android.os.Build;

public class MainActivity extends Activity implements ItemBase.ItemClickEvent{
	private final static String ItemName_Invite = "InviteItem";
	private final static String ItemName_AppWall = "AppWall";
	private final static String ItemName_InstallWangcai = "InstallWangcai";
	private final static String ItemName_RecordInfo = "RecordInfo";
	private final static String ItemName_Comment = "Comment";
	private final static String ItemName_Share = "Share";
	private final static String ItemName_MyWangcai = "MyWangcai";
	private final static String ItemName_CashExtract = "CashExtract";
	private final static String ItemName_TaskDetail = "TaskDetail";
	private final static String ItemName_ExchageGift = "ExchageGift";
	private final static String ItemName_Options = "Options";
	private final static String ItemName_Help = "Help";
	
	SlidingLayout m_slidingLayout;
	int m_nCurrentLevel = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        InitView();
        
        AtachEvents();
     }

    private void InitView() {
    	m_slidingLayout = (SlidingLayout)this.findViewById(R.id.main_wnd);
 
        ViewGroup mainClient = (ViewGroup)this.findViewById(R.id.main_client);
        Context context = getApplicationContext();
        InsertTaskItem(mainClient, ItemName_Invite, R.drawable.ic_launcher, context.getString(R.string.invite_member_title), context.getString(R.string.invite_member_tip), R.drawable.ic_launcher, false);
        InsertTaskItem(mainClient, ItemName_AppWall, R.drawable.ic_launcher, context.getString(R.string.app_wall_title), context.getString(R.string.app_wall_tip), R.drawable.ic_launcher, false);
        
        String strTitle = String.format(context.getString(R.string.level_title), m_nCurrentLevel);	//旺财升级到LVx
        String strText = String.format(context.getString(R.string.level_tip), 12.2);			//再赚x元,即可升级领红包
        InsertTaskItem(mainClient, ItemName_MyWangcai, R.drawable.ic_launcher, strTitle, strText, R.drawable.ic_launcher, true);
        InsertTaskItem(mainClient, ItemName_InstallWangcai, R.drawable.ic_launcher, context.getString(R.string.install_wangcai_title), context.getString(R.string.install_wangcai_tip), R.drawable.ic_launcher, true);
        InsertTaskItem(mainClient, ItemName_RecordInfo, R.drawable.ic_launcher, context.getString(R.string.record_info_title), context.getString(R.string.record_info_tip), R.drawable.ic_launcher, false);
        InsertTaskItem(mainClient, ItemName_Comment, R.drawable.ic_launcher, context.getString(R.string.comment_wangcai_title), context.getString(R.string.comment_wangcai_tip), R.drawable.ic_launcher, false);
        InsertTaskItem(mainClient, ItemName_Share, R.drawable.ic_launcher, context.getString(R.string.share_title), context.getString(R.string.share_tip), R.drawable.ic_launcher, false);

    	SlidingLayout sidingLayout = (SlidingLayout)this.findViewById(R.id.main_wnd);
        sidingLayout.setScrollEvent(mainClient); 
        
        ViewGroup meunPage = (ViewGroup)this.findViewById(R.id.menu_page);
        InsertMenuItem(meunPage, ItemName_MyWangcai, R.drawable.ic_launcher, context.getString(R.string.my_wangcai));
        InsertMenuItem(meunPage, ItemName_CashExtract, R.drawable.ic_launcher, context.getString(R.string.cash_extract));
        InsertMenuItem(meunPage, ItemName_TaskDetail, R.drawable.ic_launcher, context.getString(R.string.task_detail));
        InsertMenuItem(meunPage, ItemName_ExchageGift, R.drawable.ic_launcher, context.getString(R.string.exchange_gift));
        InsertMenuItem(meunPage, ItemName_Invite, R.drawable.ic_launcher, context.getString(R.string.get_money_by_invite));
        InsertMenuItem(meunPage, ItemName_Options, R.drawable.ic_launcher, context.getString(R.string.options));
        InsertMenuItem(meunPage, ItemName_Help, R.drawable.ic_launcher, context.getString(R.string.help));
    }
    
    //显示菜单
    private void ShowMenu(boolean bShow) {
    	m_slidingLayout.scrollToLeftView();
    }
    //显示要求页面
    private void ShowInviteActivity() {  
    	Intent it = new Intent(MainActivity.this, InviteActivity.class);
    	startActivity(it);
    }
    //显示交易明细
    private void ShowDetailActivity() {
    	ShowWebViewActivity("http://www.biadu.com");
    }
    //显示签到抽奖
    private void ShowLotteryActivity() {
    	Intent it = new Intent(MainActivity.this, LotteryActivity.class);
    	startActivity(it);
    }	
    //显示我的旺财
    private void ShowMyWnagcaiActivity() {
    	Intent it = new Intent(MainActivity.this, MyWangcaiActivity.class);
    	it.putExtra(ActivityParams.nLevel, m_nCurrentLevel);
    	startActivity(it);
    }
    //显示超值兑换
    private void ShowExchageGiftActivity() {
    	ShowWebViewActivity("http://www.google.com");
    }
    //显示提取现金
    private void ShowExtractActivity() {
    	ShowWebViewActivity("http://www.163.com");
    }
    //显示积分墙
    private void ShowAppWall() {
    	AppWallWin appWall = new AppWallWin(this);
    	View viewParent = this.findViewById(R.id.main_client);
    	appWall.showAtLocation(viewParent, Gravity.CENTER, 32, 132);
    }
    //显示
    private void ShowOptionActivity() {
    	Intent it = new Intent(MainActivity.this, OptionsActivity.class);
    	startActivity(it);
    }
    //分享
    private void ShowShareActivity() {
    }
    //客服帮助
    private void ShowHelpActivity() {
    	ShowWebViewActivity("http://www.sina.com.cn");
    }
    //好评旺财
    private void ShowCommentActivity() {
    }
    //填写个人信息
    private void ShowRecordInfoActivity() {
    }
    private void ShowWebViewActivity(String strUrl) {
    	Intent it = new Intent(MainActivity.this, WebviewActivity.class);
    	it.putExtra(ActivityParams.strUrl, strUrl);
    	startActivity(it);
    }
    private void AtachEvents() {
    	//左上角的菜单按钮
    	((Button)this.findViewById(R.id.option_button)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	ShowMenu(true);
            }
        });

    	//右上角兑换按钮
    	((Button)this.findViewById(R.id.exchange_gift_button)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	ShowExchageGiftActivity();
            }
        });

    	//提取现金按钮
    	((Button)this.findViewById(R.id.extract_cash)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	ShowExtractActivity();
            }
        });

    	//签到抽奖按钮
    	((Button)this.findViewById(R.id.sign_in)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	ShowLotteryActivity();
            }
        });
    }


	public void OnItemClicked(String strItemName)
	{
		if (strItemName == ItemName_Invite)	{
			ShowInviteActivity();
		}
		else if (strItemName == ItemName_AppWall) {
			ShowAppWall();
		}
		else if (strItemName == ItemName_RecordInfo) {
			ShowRecordInfoActivity();
		}
		else if (strItemName == ItemName_Comment) {
			ShowCommentActivity();
		}
		else if (strItemName == ItemName_Share) {
			ShowShareActivity();
		}
		else if (strItemName == ItemName_MyWangcai) {
			ShowMyWnagcaiActivity();
		}
		else if (strItemName == ItemName_CashExtract) {
        	ShowExtractActivity();
		}
		else if (strItemName == ItemName_TaskDetail) {
			ShowDetailActivity();
		}
		else if (strItemName == ItemName_ExchageGift) {
        	ShowExchageGiftActivity();
		}
		else if (strItemName == ItemName_Options) {
			ShowOptionActivity();
		}
		else if (strItemName == ItemName_Help) {
			ShowHelpActivity();
		}
	}
    
    private void InsertTaskItem(ViewGroup parentView, String strItemName, int nIconId, String strTitle, String strTip, int nMoneyIconId, Boolean bComplete) {
    	MainItem mainItem = new MainItem(strItemName);
    	View itemView = mainItem.Create(getApplicationContext(), nIconId, strTitle, strTip, nMoneyIconId, bComplete);
    	mainItem.SetClickEventLinstener(this);
    	parentView.addView(itemView);
    }
    
    private void InsertMenuItem(ViewGroup parentView, String strItemName, int nIconId, String strText) {
    	com.example.wangcai.MenuItem menuItem = new com.example.wangcai.MenuItem(strItemName);
    	View itemView = menuItem.Create(getApplicationContext(), nIconId, strText);
    	menuItem.SetClickEventLinstener(this);
    	parentView.addView(itemView);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

}
