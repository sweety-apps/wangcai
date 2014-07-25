package com.coolstore.wangcai.base;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.RequestManager;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.activity.ExchageGiftActivity;
import com.coolstore.wangcai.activity.ExtractAliPayActivity;
import com.coolstore.wangcai.activity.ExtractListActivity;
import com.coolstore.wangcai.activity.ExtractPhoneBillActivity;
import com.coolstore.wangcai.activity.ExtractQBiActivity;
import com.coolstore.wangcai.activity.ExtractSucceedActivity;
import com.coolstore.wangcai.activity.InviteActivity;
import com.coolstore.wangcai.activity.LotteryActivity;
import com.coolstore.wangcai.activity.MyWangcaiActivity;
import com.coolstore.wangcai.activity.PopupWinOfferWall;
import com.coolstore.wangcai.activity.PopupWinLevelUpgrate;
import com.coolstore.wangcai.activity.PopupWinNewAward;
import com.coolstore.wangcai.activity.RegisterActivity;
import com.coolstore.wangcai.activity.RegisterSucceedActivity;
import com.coolstore.wangcai.activity.SettingActivity;
import com.coolstore.wangcai.activity.SurveyActivity;
import com.coolstore.wangcai.activity.SurveyListActivity;
import com.coolstore.wangcai.activity.SurveyRuleActivity;
import com.coolstore.wangcai.activity.WebviewActivity;
import com.coolstore.wangcai.activity.WriteInviteCodeAcitivty;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.view.Gravity;
import android.view.View;
import android.widget.PopupWindow;
import android.widget.Toast;

public class ActivityHelper {
	public final static String sg_strBindDeviceCount = "BindDeviceCount";
	public final static String sg_strAge = "Age";
	public final static String sg_strSex = "Sex";
	public final static String sg_strUrl = "URL";
	public final static String sg_strTitle = "Title";
	public final static String sg_strInterest = "Interest";
	public final static String sg_strOrderId = "OrderId";
	public final static String sg_strTaskId = "TaskID";
	
    //显示要邀请页面
    public static void ShowInviteActivity(Activity owner) {  
    	Intent it = new Intent(owner, InviteActivity.class);
    	owner.startActivity(it);
    }
    public static void ShowWriteInviteCodeActivity(Activity owner) {
    	Intent it = new Intent(owner, WriteInviteCodeAcitivty.class);
    	owner.startActivity(it);    	
    }

    public static void ShowAppInstallActivity(Activity owner) {
    	String strUrl = RequestManager.GetInstance().BuildSessoinUrl(Config.GetOfferWallRuleUrl());
    	ShowWebViewActivity(owner, "重要提示", strUrl);
    }

    
    //显示交易明细
    public static void ShowDetailActivity(Activity owner) {
    	String strUrl = RequestManager.GetInstance().BuildSessoinUrl(Config.GetTransactionDetailUrl());
    	strUrl += ("&timestamp=" + String.valueOf(System.currentTimeMillis()));
    	ShowWebViewActivity(owner, "交易明细", strUrl);
    }
    //显示签到抽奖
    public static void ShowLotteryActivity(Activity owner) {
    	Intent it = new Intent(owner, LotteryActivity.class);
    	owner.startActivity(it);
    }	
    //显示我的旺财
    public static void ShowMyWnagcaiActivity(Activity owner) {
    	Intent it = new Intent(owner, MyWangcaiActivity.class);
    	owner.startActivity(it);
    }
    //显示超值兑换
    public static void ShowExchageGiftActivity(Activity owner) {
    	Intent it = new Intent(owner, ExchageGiftActivity.class);
    	owner.startActivity(it);
    }
    //显示提取现金
    public static void ShowExtractActivity(Activity owner) {
    	Intent it = new Intent(owner, ExtractListActivity.class);
    	owner.startActivity(it);
    }
    //显示
    public static void ShowOptionActivity(Activity owner) {
    	Intent it = new Intent(owner, SettingActivity.class);
    	owner.startActivity(it);
    }
    //分享
    public static void ShowShareActivity(Activity owner) {
    }
    //客服帮助
    public static void ShowHelpActivity(Activity owner) {
    	String strUrl = RequestManager.GetInstance().BuildSessoinUrl(Config.GetHelpUrl());
    	ShowWebViewActivity(owner, owner.getString(R.string.help_actiity_title), strUrl);
    }
    //好评旺财
    public static void ShowCommentActivity(Activity owner) {
    }
    //问卷调查列表
    public static void ShowSurveyListActivity(Activity owner) {
    	Intent it = new Intent(owner, SurveyListActivity.class);
    	owner.startActivity(it);
    }
    public static void ShowSurveyRuleActivity(Activity owner, int nTaskId) {
    	Intent it = new Intent(owner, SurveyRuleActivity.class);
    	it.putExtra(sg_strTaskId, nTaskId);
    	owner.startActivity(it);    	
    }
    //问卷调查页面
    public static void ShowSurveyActivity(Activity owner, int nTaskId) {
    	Intent it = new Intent(owner, SurveyActivity.class);
    	it.putExtra(sg_strTaskId, nTaskId);
    	owner.startActivity(it);
    }
    //
    public static void ShowRegisterActivity(Activity owner) {
    	Intent it = new Intent(owner, RegisterActivity.class);
    	owner.startActivity(it);
    }
    public static void ShowExtractQBiActivtiy(Activity owner) {
    	Intent it = new Intent(owner, ExtractQBiActivity.class);
    	owner.startActivity(it);    	
    }
    public static void ShowExtractPhoneBillActivity(Activity owner) {
    	Intent it = new Intent(owner, ExtractPhoneBillActivity.class);
    	owner.startActivity(it);    	
    }
    public static void ShowExtractAliPayActivtiy(Activity owner) {
    	Intent it = new Intent(owner, ExtractAliPayActivity.class);
    	owner.startActivity(it);    	
    }
    public static void ShowRegisterSucceedActivity(Activity owner, int nBindDeviceCount) {
    	Intent it = new Intent(owner, RegisterSucceedActivity.class);
    	it.putExtra(sg_strBindDeviceCount, nBindDeviceCount);
    	owner.startActivity(it);
    }
    public static void ShowWebViewActivity(Context context, String strTitle, String strUrl) {
    	Intent it = new Intent(context, WebviewActivity.class);
    	it.putExtra(sg_strUrl, strUrl);
    	it.putExtra(sg_strTitle, strTitle);
    	context.startActivity(it);
    }
    public static void ShowSessionWebViewActivity(Activity owner, String strTitle, String strUrl) {
    	strUrl = RequestManager.GetInstance().BuildSessoinUrl(strUrl);
    	Intent it = new Intent(owner, WebviewActivity.class);
    	it.putExtra(sg_strUrl, strUrl);
    	it.putExtra(sg_strTitle, strTitle);
    	owner.startActivity(it);
    }

    public static void ShowExtractSucceed(Activity owner, String strTitle, String strOrderNumber) {
    	Intent it = new Intent(owner, ExtractSucceedActivity.class);
    	it.putExtra(sg_strTitle, strTitle);
    	it.putExtra(sg_strOrderId, strOrderNumber);
    	owner.startActivity(it);    	
    }

    public static void ShowOrderDetailActivity(Activity owner, String strOrderId) {
    	String strUrl = String.format("%s?ordernum=%s", Config.GetOrderDetailUrl(), strOrderId);
    	ActivityHelper.ShowSessionWebViewActivity(owner, "订单详情", strUrl);
    }

    //显示积分墙
    public static PopupWindow ShowOfferWall(Activity owner, View viewParent) {
    	PopupWinOfferWall win = new PopupWinOfferWall(owner);
    	win.showAtLocation(viewParent, Gravity.FILL, 0, 0); 
    	return win;
    }
 
    public static PopupWindow ShowNewArawdWin(Activity owner, View viewParent, String strAwardName, int nNewAward) {
    	PopupWinNewAward win = new PopupWinNewAward(owner, strAwardName, nNewAward);
    	win.showAtLocation(viewParent, Gravity.FILL, 0, 0); 
    	return win;
    }
 
    public static PopupWindow ShowLevelUpgrateWin(Activity owner, View viewParent, int nLevel, int nLevelChange) {
    	PopupWinLevelUpgrate win = new PopupWinLevelUpgrate(owner, nLevel, nLevelChange);
    	win.showAtLocation(viewParent, Gravity.FILL, 0, 0);    	
    	return win;
    }
    
	public static void ShowToast(Context context, int nStringId) {
		ShowToast(context, context.getString(nStringId));
	}
	public static void ShowToast(Context context, String strMsg) {
		Toast toast = Toast.makeText(context,
				strMsg, Toast.LENGTH_LONG);
		toast.setGravity(Gravity.CENTER, 0, 0);
		toast.setDuration(1000);
		toast.show();
	}
	
	public static ProgressDialog ShowLoadingDialog(Context context) {
		return ProgressDialog.show(context, context.getString(R.string.app_description), context.getString(R.string.loading_text)); 
	}
	public static ProgressDialog ShowLoadingDialog(Context context, String strHintText) {
		if (Util.IsEmptyString(strHintText)) {
			strHintText = context.getString(R.string.loading_text);
		}
		return ProgressDialog.show(context, context.getString(R.string.app_description), strHintText); 
	}
}
