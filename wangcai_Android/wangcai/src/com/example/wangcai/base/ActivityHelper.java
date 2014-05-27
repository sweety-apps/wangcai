package com.example.wangcai.base;

import com.example.request.Config;
import com.example.wangcai.R;
import com.example.wangcai.activity.ExchageGiftActivity;
import com.example.wangcai.activity.ExtractAliPayActivity;
import com.example.wangcai.activity.ExtractListActivity;
import com.example.wangcai.activity.ExtractPhoneBillActivity;
import com.example.wangcai.activity.ExtractQBiActivity;
import com.example.wangcai.activity.InviteActivity;
import com.example.wangcai.activity.LotteryActivity;
import com.example.wangcai.activity.MyWangcaiActivity;
import com.example.wangcai.activity.OptionsActivity;
import com.example.wangcai.activity.PopupWinAppWall;
import com.example.wangcai.activity.PopupWinLevelUpgrate;
import com.example.wangcai.activity.PopupWinNewAward;
import com.example.wangcai.activity.RegisterActivity;
import com.example.wangcai.activity.RegisterSucceedActivity;
import com.example.wangcai.activity.SurveyActivity;
import com.example.wangcai.activity.WebviewActivity;
import com.example.wangcai.activity.WriteInviteCodeAcitivty;

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
	
    //显示要邀请页面
    public static void ShowInviteActivity(Activity owner) {  
    	Intent it = new Intent(owner, InviteActivity.class);
    	owner.startActivity(it);
    }
    public static void ShowWriteInviteCodeActivity(Activity owner) {
    	Intent it = new Intent(owner, WriteInviteCodeAcitivty.class);
    	owner.startActivity(it);    	
    }
    //显示交易明细
    public static void ShowDetailActivity(Activity owner) {
    	ShowWebViewActivity(owner, null, "http://www.biadu.com");
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
    	Intent it = new Intent(owner, OptionsActivity.class);
    	owner.startActivity(it);
    }
    //分享
    public static void ShowShareActivity(Activity owner) {
    }
    //客服帮助
    public static void ShowHelpActivity(Activity owner) {
    	ShowWebViewActivity(owner, null, "http://www.sina.com.cn");
    }
    //好评旺财
    public static void ShowCommentActivity(Activity owner) {
    }
    //填写个人信息
    public static void ShowSurveyActivity(Activity owner, int nAge, int nSex, String strInterest) {
    	Intent it = new Intent(owner, SurveyActivity.class);
    	it.putExtra(sg_strAge, nAge);
    	it.putExtra(sg_strSex, nSex);
    	it.putExtra(sg_strInterest, strInterest);
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
    public static void ShowWebViewActivity(Activity owner, String strTitle, String strUrl) {
    	Intent it = new Intent(owner, WebviewActivity.class);
    	it.putExtra(sg_strUrl, strUrl);
    	it.putExtra(sg_strTitle, strTitle);
    	owner.startActivity(it);
    }

    public static void ShowAppInstallActivity(Activity owner) {
    	ShowWebViewActivity(owner, null, Config.GetWebServiceUrl() + "132");
    }

    //显示积分墙
    public static PopupWindow ShowAppWall(Activity owner, View viewParent) {
    	PopupWinAppWall appWall = new PopupWinAppWall(owner);
    	appWall.showAtLocation(viewParent, Gravity.CENTER, 0, 0);
    	return appWall;
    }
    public static PopupWindow ShowNewArawdWin(Activity owner, View viewParent, String strAwardName, int nNewAward) {
    	PopupWinNewAward win = new PopupWinNewAward(owner, strAwardName, nNewAward);
    	win.showAtLocation(viewParent, Gravity.CENTER, 0, 0); 
    	return win;
    }
    public static PopupWindow ShowLevelUpgrateWin(Activity owner, View viewParent) {
    	PopupWinLevelUpgrate win = new PopupWinLevelUpgrate(owner);
    	win.showAtLocation(viewParent, Gravity.CENTER, 0, 0);    	
    	return win;
    }
    
	public static void ShowToast(Context context, int nStringId) {
		ShowToast(context, context.getString(nStringId));
	}
	public static void ShowToast(Context context, String strMsg) {
		Toast toast = Toast.makeText(context,
				strMsg, Toast.LENGTH_LONG);
		toast.setGravity(Gravity.CENTER, 0, 0);
		toast.show();
	}
	
	public static ProgressDialog ShowLoadingDialog(Context context) {
		return ProgressDialog.show(context, context.getString(R.string.app_description), context.getString(R.string.loading_text)); 
	}
	public static ProgressDialog ShowLoadingDialog(Context context, String strHintText) {
		return ProgressDialog.show(context, context.getString(R.string.app_description), strHintText); 
	}
}
