package com.coolstore.wangcai.activity;

import java.util.ArrayList;

import com.coolstore.request.SurveyInfo;
import com.coolstore.common.Util;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.ManagedDialog;
import com.coolstore.wangcai.base.ManagedDialogActivity;
import com.coolstore.common.BuildSetting;
import com.coolstore.wangcai.ctrls.ItemBase;
import com.coolstore.wangcai.ctrls.MainItem;
import com.coolstore.wangcai.dialog.HintTaskLevelDialog;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

public class SurveyListActivity extends ManagedDialogActivity implements ItemBase.ItemClickEvent{



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_suvery_list);        
        
        RequestList();
     }

    private void RequestList() {
    	WangcaiApp app = WangcaiApp.GetInstance();
    	m_listSurveyInfo = app.GetSurveyInfo();
    	if (m_listSurveyInfo != null) {
    		//m_nCurrentDataVersion = app.GetSurveyListVersion();
			UpdateItemList();
    	}
    	else {
    		app.RequestSurveyInfo();
			m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
			m_progressDialog.show();
    	}
    }


	@Override
	public void OnSurveyRequestComplete(int nVersion, int nResult, String strMsg) {	
		if (m_progressDialog != null) {
			m_progressDialog.dismiss();
			m_progressDialog = null;
		}
		if (nResult != 0) {
			Util.ShowRequestErrorMsg(this, strMsg);
		}
		else {
			m_listSurveyInfo = WangcaiApp.GetInstance().GetSurveyInfo();
			//m_nCurrentDataVersion = nVersion;

			UpdateItemList();
		}	
	}

    private void UpdateItemList() {
    	ViewGroup itemFrame = (ViewGroup)findViewById(R.id.item_frame);
    	itemFrame.removeAllViews();
    	
    	ArrayList<SurveyInfo> listCompleteTask = new ArrayList<SurveyInfo>();
    	//先放未完成任务
    	for (SurveyInfo info : m_listSurveyInfo) {
    		if (info.IsComplete()) {
    			listCompleteTask.add(info);
    		}
    		else {
    			CreateItem(itemFrame, info);
    		}
    	}
    	//添加完成任务
    	for (SurveyInfo info : listCompleteTask) {
			CreateItem(itemFrame, info);    		
    	}
    }
    
    private MainItem CreateItem(ViewGroup parentView, SurveyInfo info) {
    	Resources res = this.getResources();
    	LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(
    			ViewGroup.LayoutParams.MATCH_PARENT, res.getDimensionPixelSize(R.dimen.main_item_height));
		MainItem mainItem = new MainItem(String.valueOf(info.m_nId));
		View itemView = mainItem.Create(this, 
															R.drawable.quest_icon, 
															info.m_strTitle, 
															info.m_strIntroduction,
															info.m_nMoney, 
															info.IsComplete());
		mainItem.SetClickEventLinstener(this);
		parentView.addView(itemView, layoutParams);
		return mainItem;
    }

	public void OnDialogFinish(ManagedDialog dlg, int inClickedViewId) {
		int nDialogId = dlg.GetDialogId();
		if (m_hintTaskLevelDialog != null && nDialogId == m_hintTaskLevelDialog.GetDialogId()) {
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				ActivityHelper.ShowMyWnagcaiActivity(this);
			}	
		}
	}

	@Override
	public void OnItemClicked(String strItemName) {
		// TODO Auto-generated method stub
		int nId = Integer.valueOf(strItemName);
    	for (SurveyInfo info : m_listSurveyInfo) {
    		if (info.m_nId == nId) {
    			//检查任务等级
    			if (info.IsComplete()) {
    				break;
    			}
    			if (BuildSetting.sg_bIsRelease) {
	    			if (info.m_nLevel > WangcaiApp.GetInstance().GetUserInfo().GetCurrentLevel()){
						m_hintTaskLevelDialog = new HintTaskLevelDialog(this, info.m_nLevel);
						RegisterDialog(m_hintTaskLevelDialog);
						m_hintTaskLevelDialog.Show();
		    			break;
	    			}
    			}
    			//打开任务详情页
    			ActivityHelper.ShowSurveyRuleActivity(this, info.m_nId);
    			break;
    		}
    	}
	}
	


    private HintTaskLevelDialog m_hintTaskLevelDialog = null;
	private ArrayList<SurveyInfo> m_listSurveyInfo = null;
    private ProgressDialog m_progressDialog = null;
    //private int m_nCurrentDataVersion = 0;
}
