package com.coolstore.wangcai.activity;
import java.util.ArrayList;
import java.util.HashMap;

import cn.jpush.android.api.JPushInterface;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.framework.Platform.ShareParams;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.onekeyshare.ShareContentCustomizeCallback;

import com.coolstore.request.Requester;
import com.coolstore.request.RequesterFactory;
import com.coolstore.request.TaskListInfo;
import com.coolstore.request.RequestManager;
import com.coolstore.request.UserInfo;
import com.coolstore.request.Requesters.Request_GetUserInfo;
import com.coolstore.request.Requesters.Request_Share;
import com.coolstore.wangcai.ConfigCenter;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.common.BuildSetting;
import com.coolstore.common.LogUtil;
import com.coolstore.common.TimerManager;
import com.coolstore.common.Util;
import com.coolstore.common.ViewHelper;
import com.coolstore.wangcai.base.ManagedDialog;
import com.coolstore.wangcai.base.ManagedDialogActivity;
import com.coolstore.wangcai.base.PushReceiver;
import com.coolstore.wangcai.ctrls.ItemBase;
import com.coolstore.wangcai.ctrls.MainItem;
import com.coolstore.wangcai.dialog.HintBindPhoneDialog;
import com.coolstore.wangcai.dialog.HintTaskLevelDialog;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshScrollView;
import com.jeremyfeinstein.slidingmenu.lib.SlidingMenu;
import com.jeremyfeinstein.slidingmenu.lib.SlidingMenu.CanvasTransformer;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Canvas;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;


public class MainActivity extends ManagedDialogActivity implements ItemBase.ItemClickEvent, 
																				OnClickListener, 
																				RequestManager.IRequestManagerCallback,
																				TimerManager.TimerManagerCallback{

	private final static int sg_nUpdateBalanceElapse = 60; 
	
    private final static int sg_ItemIdBase = 1818;
    private final static int sg_MyWangcai = sg_ItemIdBase + 0;
    private final static int sg_CashExtract = sg_ItemIdBase + 1;
    private final static int sg_TaskDetail = sg_ItemIdBase + 2;
    private final static int sg_ExchageGift = sg_ItemIdBase + 3;
    private final static int sg_Invite = sg_ItemIdBase + 4;
    private final static int sg_Options = sg_ItemIdBase + 5;
    private final static int sg_Help = sg_ItemIdBase +  6;
    
    public final static String sg_nIntentType = "nIntentType";
    public final static int sg_nIntentType_NewPurseNotification = 1;
    

	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
 
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    	
        InitView();

        registerMessageReceiver();
        
		JPushInterface.init(getApplicationContext());
     }
    
    private void InitTaskList(TaskListInfo taskListInfo) {
        ViewGroup taskListContainer = (ViewGroup)this.findViewById(R.id.tasks_list_container);

        m_listCompleteTasks.clear();
        int nTaskCount = taskListInfo.GetTaskCount();
        for (int i = 0; i < nTaskCount; ++i) {
        	TaskListInfo.TaskInfo taskInfo = taskListInfo.GetTaskInfo(i);
        	if (!ShouldAddTask(taskInfo)) {
        		continue;
        	}
        	if (TaskListInfo.IsComplete(taskInfo)) {
        		m_listCompleteTasks.add(taskInfo);
        		continue;
        	}
        	
        	InsertTaskItem(taskListContainer, taskInfo);
        } 
        if (m_bShowCompleteTask) {
	        for (TaskListInfo.TaskInfo taskInfo : m_listCompleteTasks) {
	        	InsertTaskItem(taskListContainer, taskInfo);
	        }
        }
    }
    private void InitMemuList() {
        Context context = getApplicationContext();
        ViewGroup meunPage = (ViewGroup)this.findViewById(R.id.menu_page);
        InsertMenuItem(meunPage, String.valueOf(sg_MyWangcai), R.drawable.menu_icon_wodewangcai, context.getString(R.string.my_wangcai));
        InsertMenuItem(meunPage, String.valueOf(sg_CashExtract), R.drawable.menu_icon_tixian, context.getString(R.string.cash_extract));
        InsertMenuItem(meunPage, String.valueOf(sg_TaskDetail), R.drawable.menu_icon_jiaoyimingxi, context.getString(R.string.task_detail));
        InsertMenuItem(meunPage, String.valueOf(sg_ExchageGift), R.drawable.menu_icon_chaozhiduihua, context.getString(R.string.exchange_gift));
        InsertMenuItem(meunPage, String.valueOf(sg_Invite), R.drawable.menu_icon_tuhaobang, context.getString(R.string.get_money_by_invite));
        InsertMenuItem(meunPage, String.valueOf(sg_Options), R.drawable.menu_icon_setting, context.getString(R.string.options));
        InsertMenuItem(meunPage, String.valueOf(sg_Help), R.drawable.menu_icon_help, context.getString(R.string.help));    	
    }
    private void CheckHasSignin() {
        if (!ConfigCenter.GetInstance().HasSignInToday()) {
        	findViewById(R.id.lottery_dot_image).setVisibility(View.VISIBLE);
        }
    }
    CanvasTransformer mTransformer = new CanvasTransformer() {
    	@Override
    	public void transformCanvas(Canvas canvas, float percentOpen) {
    	float scale = (float) (percentOpen*0.25 + 0.75);
    	canvas.scale(scale, scale, canvas.getWidth()/2, canvas.getHeight()/2);
    	}
    };
    private void InitView() {
    	//m_slidingLayout = (SlidingLayout)this.findViewById(R.id.main_wnd);
    	m_slidingMenu = new SlidingMenu(this);//ֱ��new��������getSlidingMenu
    	m_slidingMenu.setMode(SlidingMenu.LEFT);
    	m_slidingMenu.setTouchModeAbove(SlidingMenu.TOUCHMODE_FULLSCREEN);
    	//menu.setShadowDrawable(R.drawable.shadow);
    	//menu.setShadowWidthRes(400);
    	//menu.setBehindOffsetRes(200);
    	m_slidingMenu.setBehindWidth(getResources().getDimensionPixelSize(R.dimen.main_menu_width));//����SlidingMenu�˵��Ŀ���
    	m_slidingMenu.setFadeDegree(0.35f);
    	m_slidingMenu.attachToActivity(this, SlidingMenu.SLIDING_CONTENT);//�������
    	m_slidingMenu.setMenu(R.layout.ctrl_main_menu);//������ͨ��layout����
    	m_slidingMenu.setBehindCanvasTransformer(mTransformer);
    	
    	
        //ViewGroup mainClient = (ViewGroup)this.findViewById(R.id.main_client);
        //m_slidingLayout.setScrollEvent(mainClient); 

        InitMemuList();
        
        CheckHasSignin();
        
    	//���ϽǵĲ˵���ť
    	View viewButton = this.findViewById(R.id.option_button);
    	ViewHelper.SetStateViewBkg(viewButton, this, R.drawable.main_menu1, R.drawable.main_menu2, 0);
    	viewButton.setOnClickListener(this);
    	
    	//���ϽǶһ���ť
    	this.findViewById(R.id.exchange_gift_button).setOnClickListener(this);
       	
    	m_pullRefreshScrollView = (PullToRefreshScrollView) findViewById(R.id.scroll_wnd);
    	m_pullRefreshScrollView.setOnRefreshListener(new PullToRefreshScrollView.OnRefreshListener<ScrollView>() {
			@Override
			public void onRefresh(PullToRefreshBase<ScrollView> refreshView) {
				WangcaiApp.GetInstance().Login();
			}
    	});

    	Handler handler = new Handler();   
    	handler.postDelayed(new Runnable() { 
            public void run() { 
            	m_pullRefreshScrollView.scrollTo(0, 0);
            } 
        }, 10);
    	
    	//��ȡ�ֽ�ť
    	this.findViewById(R.id.extract_cash).setOnClickListener(this);
    	
    	//ǩ���齱��ť
    	this.findViewById(R.id.sign_in).setOnClickListener(this);
   
    	//�鿴���쵽�ĺ��
    	this.findViewById(R.id.show_complete_task).setOnClickListener(this);
    	
    	if (ConfigCenter.GetInstance().HasClickMenu()) {
    		this.findViewById(R.id.menu_dot_image).setVisibility(View.GONE);
    	}
    	
    	UpdateUI();
    }
    
    private void UpdateUI() {
        WangcaiApp app = WangcaiApp.GetInstance();
        
        UserInfo userInfo = app.GetUserInfo();

        //���
        SetBalance(userInfo.GetBalance());
        
        //���컹��׬
        TaskListInfo taskListInfo = app.GetTaskListInfo();
        int nRemainMoney = taskListInfo.GetRemainMoneyToday();
        TextView remainMoneyTextView = (TextView)this.findViewById(R.id.remain_taks_balance);
        remainMoneyTextView.setText(String.valueOf((float)nRemainMoney / 100.0f));
        
        //�����б�
        InitTaskList(taskListInfo);
    }

    private final static int sg_listNumberResId[] = {R.drawable.yue_0, R.drawable.yue_1, R.drawable.yue_2, R.drawable.yue_3, 
        	R.drawable.yue_4, R.drawable.yue_5, R.drawable.yue_6, R.drawable.yue_7, R.drawable.yue_8, R.drawable.yue_9};
    private final static int sg_viewIdResId[] = {R.id.money_dot2, R.id.money_dot1, R.id.money_4, R.id.money_3, R.id.money_2, R.id.money_1};
    private final static int nViewCount = sg_viewIdResId.length;
    private void SetBalance(int nBalance) {
 
        for (int i = 0; i < nViewCount && nBalance > 0; i++, nBalance /= 10) {
        	int nValue = nBalance % 10;
        	ImageView view = (ImageView)this.findViewById(sg_viewIdResId[i]);
        	view.setBackgroundResource(sg_listNumberResId[nValue]);
        	view.setVisibility(View.VISIBLE);
    	}
    }
    
    //��ʾ�˵�
    private void ShowMenu(boolean bShow) {
    	if (bShow) {
    		m_slidingMenu.showMenu();
    		//m_slidingLayout.scrollToLeftView();
    	}
    	else {
    		m_slidingMenu.showContent();
    	}
    }
 
    //�Ի��򷵻�
	public void OnDialogFinish(ManagedDialog dlg, int inClickedViewId) {
		int nDialogId = dlg.GetDialogId();
		if (m_bindPhoneDialog != null && nDialogId == m_bindPhoneDialog.GetDialogId()) {
			//���ֻ�
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				ActivityHelper.ShowRegisterActivity(this);
			}
		}
		else if (m_hintTaskLevelDialog != null && nDialogId == m_hintTaskLevelDialog.GetDialogId()) {
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				ActivityHelper.ShowMyWnagcaiActivity(this);
			}			
		}
	}
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (req instanceof Request_GetUserInfo) {
			//������ǰ�ĵ����ʾ�
			Request_GetUserInfo getUserReq = (Request_GetUserInfo)req;
			int nResult = getUserReq.GetResult();
			LogUtil.LogUserInfo("Request_GetUserInfo Complete Result(%d)", nResult);

			int nAge = 0;
			int nSex = 0;
			String strInterest = "";
			if (nResult == 0) {
				nAge = getUserReq.GetAge();
				nSex = getUserReq.GetSex();
				strInterest = getUserReq.GetInterest();
			}
			ActivityHelper.ShowSurveyActivity(this, nAge, nSex, strInterest);
		}
		else if (req instanceof Request_Share) {
			int nResult = req.GetResult();
			LogUtil.LogUserInfo("Request_Share Complete Result(%d)", nResult);
			if (nResult == 0) {
				Request_Share detailReq = (Request_Share)req;
				int nIncome = detailReq.GetIncome();
				
				WangcaiApp app = WangcaiApp.GetInstance();
				app.Login();
				
				//��ʾ�����ʾ
				super.ShowPurseTip(nIncome, getString(R.string.new_invite_award_tip_title));
				
				//�������
				app.ChangeBalance(nIncome);
			}
			else {
				String strMsg = req.GetMsg();
				Util.ShowRequestErrorMsg(this, strMsg);
			}
		}
	}
	public void onClick(View v) {
		int nId = v.getId();
		switch (nId) {
			case R.id.option_button:
		    	if (!ConfigCenter.GetInstance().HasClickMenu()) {
		    		this.findViewById(R.id.menu_dot_image).setVisibility(View.GONE);
		    		ConfigCenter.GetInstance().SetHasClickMenu(true);		    	
		    	}
		    	
				ShowMenu(!m_slidingMenu.isMenuShowing());
				return ;		//ע��:ֱ�ӷ���
			case R.id.exchange_gift_button:
				//��ֵ�һ�
				ActivityHelper.ShowExchageGiftActivity(this);
				break;
			case R.id.extract_cash:
				//��ȡ�ֽ�
				ActivityHelper.ShowExtractActivity(this);
				break;
			case R.id.sign_in:
				//ǩ��
				
				if (BuildSetting.sg_bIsRelease) {
					//�����Ƿ�ǩ������
					if (ConfigCenter.GetInstance().HasSignInToday()) {
						ActivityHelper.ShowToast(this, R.string.hint_duplicate_signin);
						break ;
					}
				}
				ActivityHelper.ShowLotteryActivity(this);
				m_bNeedCheckSignin = true;
				break ;
			case R.id.show_complete_task:
				//�鿴���쵽�ĺ��
				this.findViewById(R.id.show_complete_task).setVisibility(View.GONE);
				for (TaskListInfo.TaskInfo taskInfo:m_listCompleteTasks){
			        ViewGroup taskListContainer = (ViewGroup)this.findViewById(R.id.tasks_list_container);
		        	InsertTaskItem(taskListContainer, taskInfo);
				}
				m_bShowCompleteTask = true;
				break;
		}

		ShowMenu(false);
	}

	public void OnItemClicked(String strItemName)
	{
		int nTaskType = Integer.parseInt(strItemName);
	
		if (BuildSetting.sg_bIsRelease) {
			WangcaiApp app = WangcaiApp.GetInstance();
			TaskListInfo.TaskInfo taskInfo = app.GetTaskListInfo().GetTaskInfoByType(nTaskType);
			if (taskInfo != null) {
				//�жϵȼ��Ƿ�ﵽ����Ҫ��
				int nCurrentLevel = app.GetUserInfo().GetCurrentLevel();
				if (nCurrentLevel < taskInfo.m_nLevel) {

					if (m_hintTaskLevelDialog == null) {
						m_hintTaskLevelDialog = new HintTaskLevelDialog(this, nCurrentLevel);
						RegisterDialog(m_hintTaskLevelDialog);
					}
					m_hintTaskLevelDialog.Show();
			
					//ActivityHelper.ShowToast(this, String.format(getString(R.string.task_level_limit_hint), taskInfo.m_nLevel));
					return ;
				}
			}
		}

		switch (nTaskType) {
		case TaskListInfo.TaskTypeInviteFriends:
			//��д������
			if (!WangcaiApp.GetInstance().GetUserInfo().HasBindPhone()) {
				if (m_bindPhoneDialog == null) {
					m_bindPhoneDialog = new HintBindPhoneDialog(this);
					RegisterDialog(m_bindPhoneDialog);
				}
				m_bindPhoneDialog.Show();
			}
			else {
				ActivityHelper.ShowWriteInviteCodeActivity(this);
			}
			break;
		case TaskListInfo.TaskTypeOfferWall:
			//����ǽ
			//ActivityHelper.ShowExtractSucceed(this, "xxsdf", "234324U234LKJLSDF23423423423fsgfsSFS234234");
			//ActivityHelper.ShowRegisterActivity(this);
			
			ActivityHelper.ShowAppWall(this, findViewById(R.id.main_wnd));
			//PopupWinLevelUpgrate appWall = new PopupWinLevelUpgrate(this, 4, 200);
	    	//appWall.showAtLocation(findViewById(R.id.main_wnd), Gravity.CENTER, 0, 0);
			break;
		case TaskListInfo.TaskTypeUserInfo:
			//��д������Ϣ
			RequestManager requestManager = RequestManager.GetInstance();
			Request_GetUserInfo request = (Request_GetUserInfo)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_GetUserInfo);
			requestManager.SendRequest(request, true, this);			
			break;
		case TaskListInfo.TaskTypeShare:
			//����
			UserInfo userInfo = WangcaiApp.GetInstance().GetUserInfo();
			if (!userInfo.HasBindPhone()) {
				if (!WangcaiApp.GetInstance().GetUserInfo().HasBindPhone()) {
					if (m_bindPhoneDialog == null) {
						m_bindPhoneDialog = new HintBindPhoneDialog(this);
						RegisterDialog(m_bindPhoneDialog);
					}
					m_bindPhoneDialog.Show();
					return;
				}
			}
			final String strInviteCode = userInfo.GetInviteCode();
			final String strInviteUrl = userInfo.GetInviteTaskUrl();
			
			OnekeyShare oks = new OnekeyShare();
			oks.setNotification(R.drawable.ic_launcher, getString(R.string.app_description));
			oks.setTitle(getString(R.string.share_title));
			oks.setUrl(strInviteUrl);
			oks.setSilent(false);
			oks.setSite(getString(R.string.app_name));
			oks.setSiteUrl(strInviteUrl);
			oks.setTitleUrl(strInviteUrl);

			String strImagePath = Util.GetMainLogoPath(this);
			if (!Util.IsEmptyString(strImagePath)) {
				oks.setImagePath(strImagePath);
				oks.setFilePath(strImagePath);
			}
			final String strShareIncome = Util.FormatMoney(userInfo.GetTotalIncome());
			String strText = String.format(getString(R.string.share_content),  strShareIncome, strInviteCode, strInviteUrl);
			oks.setText(strText);

			oks.setShareContentCustomizeCallback(new ShareContentCustomizeCallback() {
				public void onShare(Platform platform, ShareParams paramsToShare) {
					if ("QZone".equals(platform.getName())) {
						//String text = platform.getContext().getString(R.string.share_content_short);
						//String strQZoneNewText = platform.getContext().getString(R.string.qzone_share_content);
						String strNewText = String.format(getString(R.string.qzone_share_content),  
																		strShareIncome, strInviteCode);
						paramsToShare.setText(strNewText);
					}
				}
			});
			oks.setCallback(new PlatformActionListener(){
				@Override
				public void onComplete(Platform palt, int nAction, HashMap<String, Object> res) {
					LogUtil.LogUserInfo("ShareComplete, reuqest purse");

					RequestManager requestManager = RequestManager.GetInstance();
					Request_Share request = (Request_Share)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_Share);
					requestManager.SendRequest(request, true, MainActivity.this);			
				}			
				@Override
				public void onError(Platform plat, int action, Throwable t) {
					LogUtil.LogUserInfo("Share Fail");
				}			
				@Override
				public void onCancel(Platform plat, int action) {
					LogUtil.LogUserInfo("Share Cancel");
				}
			});

			oks.show(this.getApplicationContext());			
		
			break;
		case TaskListInfo.TaskTypeUpgrade:
		case sg_MyWangcai:
			//�ҵ�����
			ActivityHelper.ShowMyWnagcaiActivity(this);
			break;
		case sg_Invite:
			//��д������
			if (!WangcaiApp.GetInstance().GetUserInfo().HasBindPhone()) {
				if (m_bindPhoneDialog == null) {
					m_bindPhoneDialog = new HintBindPhoneDialog(this);
					RegisterDialog(m_bindPhoneDialog);
				}
				m_bindPhoneDialog.Show();
			}
			else {
				ActivityHelper.ShowInviteActivity(this);
			}

			break;
		case sg_CashExtract:
			//��ȡ�ֽ�
			ActivityHelper.ShowExtractActivity(this);	
			break;
		case sg_TaskDetail:
			//��������
			ActivityHelper.ShowDetailActivity(this);
			break;
		case sg_ExchageGift:
			//��ֵ�һ�
			ActivityHelper.ShowExchageGiftActivity(this);
			break;
		case sg_Options:
			//����
			ActivityHelper.ShowOptionActivity(this);
			break;
		case sg_Help:
			//�ͷ�����
			ActivityHelper.ShowHelpActivity(this);
			break;
		}

		ShowMenu(false);
	}
    

	public void OnTimer(int nId, int nHitTimes) {
		if (nId == m_nUpdateBalanceTimerId) {
			int nCurrentShowBalance = 0;
			if (m_nNewBalance > m_nCurrentBalance) {
				nCurrentShowBalance = m_nCurrentBalance + nHitTimes;
			}
			else {
				nCurrentShowBalance = m_nCurrentBalance - nHitTimes;				
			}
			SetBalance(nCurrentShowBalance);
			if (nCurrentShowBalance == m_nNewBalance) {
				StopBalanceUpdateTimer();
			}
		}
	}

	private void AnimaUpdateBalance() {
		if (m_nUpdateBalanceTimerId != 0) {
			return;
		}
		m_nUpdateBalanceTimerId = TimerManager.GetInstance().StartTimer(sg_nUpdateBalanceElapse, this);
	}
	private void StopBalanceUpdateTimer() {
		if (m_nUpdateBalanceTimerId != 0) {
			TimerManager.GetInstance().StopTimer(m_nUpdateBalanceTimerId);
			m_nUpdateBalanceTimerId = 0;
		}
	}
	

	protected void onResume() {
		if (m_nUpdateBalanceTimerId == 0 && m_nCurrentBalance != 0 && m_nNewBalance != 0) {
			AnimaUpdateBalance();
		}

		this.CheckHasSignin();
	
        if (m_bNeedCheckSignin) {
        	m_bNeedCheckSignin = false;
        	CheckHasSignin();
        }
		super.onResume();
	}
	public void OnBalanceUpdate(int nCurrentBalance, int nNewBalance) {
		if (nCurrentBalance == nNewBalance) {
			return;
		}
		if (m_nNewBalance >= nCurrentBalance) {
			m_nNewBalance = nNewBalance;
		}
		else {
			m_nCurrentBalance = nCurrentBalance;
			m_nNewBalance = nNewBalance;
		}
		if (IsVisible()) {
			AnimaUpdateBalance();
		}
		super.OnBalanceUpdate(nCurrentBalance, nNewBalance);
	}
	private int m_nCurrentBalance = 0;
	private int m_nNewBalance = 0;
	
	private void RefreshTaskList() {
    	ViewGroup viewTaskList = (ViewGroup)findViewById(R.id.tasks_list_container);
    	viewTaskList.removeAllViews();
    	
    	UpdateUI();
	}
	
    public void OnLoginComplete(int nResult, String strMsg) {
    	m_pullRefreshScrollView.onRefreshComplete();
    	RefreshTaskList();
    	super.OnLoginComplete(nResult, strMsg);		
    }
    
    public void OnUserInfoUpdate() {
    	RefreshTaskList();
    	super.OnUserInfoUpdate();		
    }
 
    private void InsertMenuItem(ViewGroup parentView, String strItemName, int nIconId, String strText) {
    	com.coolstore.wangcai.ctrls.MenuItem menuItem = new com.coolstore.wangcai.ctrls.MenuItem(strItemName);
    	View itemView = menuItem.Create(getApplicationContext(), nIconId, strText);
    	menuItem.SetClickEventLinstener(this);
    	parentView.addView(itemView);
    }
 
    private boolean ShouldAddTask(TaskListInfo.TaskInfo taskInfo) {
   	 boolean bAdd = false;
   	switch (taskInfo.m_nTaskType) {
	    	case TaskListInfo.TypeInstallWangcai:
	    	//case TaskListInfo.TaskTypeUserInfo:  �Ȳ�Ҫ�ʾ�����
	    	case TaskListInfo.TaskTypeInviteFriends:
	    	case TaskListInfo.TaskTypeOfferWall:
	    	//case TaskListInfo.TaskTypeCommetWangcai:	û�к�������
	    	case TaskListInfo.TaskTypeUpgrade:
	    	case TaskListInfo.TaskTypeShare:
	    		bAdd = true;
	    		break;
   	}
   	return bAdd;
   }
   private int GetItemIcon(TaskListInfo.TaskInfo taskInfo) {
   	int nIconId = R.drawable.package_icon_many;
   	switch (taskInfo.m_nTaskType) {
   	case TaskListInfo.TypeInstallWangcai:
   		nIconId = R.drawable.main_about_wangcai_cell_icon;
   		break;
   	case TaskListInfo.TaskTypeUserInfo:
   		nIconId = R.drawable.main_person_info_icon;
   		break;
   	case TaskListInfo.TaskTypeInviteFriends:
   		nIconId = R.drawable.main_qrcode_cell_icon;
   		break;
   	case TaskListInfo.TaskTypeOfferWall:
   		nIconId = R.drawable.main_tiyanzhongxin_cell_icon;
   		break;
   	case TaskListInfo.TaskTypeUpgrade:
   		nIconId = R.drawable.main_upgrade;
   		break;
   	case TaskListInfo.TaskTypeShare:
   		nIconId = R.drawable.main_share_cell_icon;
   		break;
   	case TaskListInfo.TaskTypeCommetWangcai:
   		nIconId = R.drawable.main_rate_app_cell_icon;
   		break;
   	}
   	return nIconId;
   }
   private int GetMoneyIconId(TaskListInfo.TaskInfo taskInfo) {
   	int nIconId = R.drawable.package_icon_many;
   	switch (taskInfo.m_nMoney) {
   	case 10:
   		nIconId = R.drawable.package_icon_1mao;
   		break;
   	case 50:
   		nIconId = R.drawable.package_icon_1mao;
   		break;
   	case 100:
   		nIconId = R.drawable.package_icon_1;
   		break;
   	case 200:
   		nIconId = R.drawable.package_icon_2;
   		break;
   	case 300:
   		nIconId = R.drawable.package_icon_3;
   		break;
   	case 800:
   		nIconId = R.drawable.package_icon_8;
   		break;
   	}
   	return nIconId;
   }
   private void InsertTaskItem(ViewGroup parentView, String strItemName, int nIconId, String strTitle, String strTip, int nMoneyIconId, Boolean bComplete) {
		MainItem mainItem = new MainItem(strItemName);
		View itemView = mainItem.Create(getApplicationContext(), nIconId, strTitle, strTip, nMoneyIconId, bComplete);
		mainItem.SetClickEventLinstener(this);
		parentView.addView(itemView);
   }
   private void InsertTaskItem(ViewGroup mainClient, TaskListInfo.TaskInfo taskInfo) {
   		InsertTaskItem(mainClient, String.valueOf(taskInfo.m_nTaskType), GetItemIcon(taskInfo), 
   		taskInfo.m_strTitle, taskInfo.m_strDescription, GetMoneyIconId(taskInfo), TaskListInfo.IsComplete(taskInfo));
   }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
    	ShowMenu(true);
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
    @Override 
    protected void onDestroy() {
    	ShareSDK.stopSDK(this);
    	
    	LogUtil.LogWangcai("###############   MainActivity OnDestroy    ###############");
  
		unregisterReceiver(m_messageReceiver);

    	super.onDestroy();
    }


	public void registerMessageReceiver() {
		m_messageReceiver = new MessageReceiver();
		IntentFilter filter = new IntentFilter();
		filter.setPriority(IntentFilter.SYSTEM_HIGH_PRIORITY);
		filter.addAction(PushReceiver.PushMessageReceiveAction);
		registerReceiver(m_messageReceiver, filter);
	}

	public class MessageReceiver extends BroadcastReceiver {
		@Override
		public void onReceive(Context context, Intent intent) {
            LogUtil.LogPush("MainActivity  receive broadcast(%s)", intent.getAction());
			if (PushReceiver.PushMessageReceiveAction.equals(intent.getAction())) {
              int nPushType = intent.getIntExtra(PushReceiver.sg_nPushType, PushReceiver.nPushType_Custom);
              int nMessageType =  intent.getIntExtra(PushReceiver.sg_nPushMessageType, PushReceiver.nMessageType_NewAward);
              String strTitle = intent.getStringExtra(PushReceiver.sg_strPushTitle);
              String strText = intent.getStringExtra(PushReceiver.sg_strPushText);  
              LogUtil.LogPush("MainActivity  receive push message broadcast(%d)(%s)(%s)", nMessageType, strTitle, strText);
              if (PushReceiver.nMessageType_NewAward == nMessageType) {
            	  WangcaiApp.GetInstance().QueryChanges();
              }
			}
		}
	}	
	@Override
    protected void onNewIntent(Intent intent) {
    	CheckHasSignin();
 
		int nIntentType =  intent.getIntExtra(sg_nIntentType, 0);
		LogUtil.LogPush("MainActivity  onNewIntent Type(%d)", nIntentType);
		if (nIntentType == sg_nIntentType_NewPurseNotification) {
			WangcaiApp.GetInstance().QueryChanges();
		}
    }
	
	private MessageReceiver m_messageReceiver = null;
    private SlidingMenu m_slidingMenu;
    private boolean m_bNeedCheckSignin = false;
    private HintTaskLevelDialog m_hintTaskLevelDialog;
    private HintBindPhoneDialog m_bindPhoneDialog;
    private ArrayList<TaskListInfo.TaskInfo> m_listCompleteTasks = new ArrayList<TaskListInfo.TaskInfo>();
    private int m_nUpdateBalanceTimerId = 0;
    private PullToRefreshScrollView m_pullRefreshScrollView = null;
    private boolean m_bShowCompleteTask = false;
}