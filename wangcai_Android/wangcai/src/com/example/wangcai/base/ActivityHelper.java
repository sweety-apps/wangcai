package com.example.wangcai.base;

import com.example.wangcai.R;
import com.example.wangcai.activity.ExchageGiftActivity;
import com.example.wangcai.activity.ExtractMoneyActivity;
import com.example.wangcai.activity.InviteActivity;
import com.example.wangcai.activity.LotteryActivity;
import com.example.wangcai.activity.MyWangcaiActivity;
import com.example.wangcai.activity.OptionsActivity;
import com.example.wangcai.activity.RegisterActivity;
import com.example.wangcai.activity.RegisterSucceedActivity;
import com.example.wangcai.activity.SurveyActivity;
import com.example.wangcai.activity.WebviewActivity;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.view.Gravity;
import android.widget.Toast;

public class ActivityHelper {
	public final static String sg_strBonus = "Bonuse";
	public final static String sg_strBindDeviceCount = "BindDeviceCount";
	public final static String sg_strAge = "Age";
	public final static String sg_strSex = "Sex";
	public final static String sg_strInterest = "Interest";
	
    //��ʾҪ����ҳ��
    public static void ShowInviteActivity(Activity owner) {  
    	Intent it = new Intent(owner, InviteActivity.class);
    	owner.startActivity(it);
    }
    //��ʾ������ϸ
    public static void ShowDetailActivity(Activity owner) {
    	ShowWebViewActivity(owner, "http://www.biadu.com");
    }
    //��ʾǩ���齱
    public static void ShowLotteryActivity(Activity owner, int nBonus) {
    	Intent it = new Intent(owner, LotteryActivity.class);
    	it.putExtra(sg_strBonus, nBonus);
    	owner.startActivity(it);
    }	
    //��ʾ�ҵ�����
    public static void ShowMyWnagcaiActivity(Activity owner) {
    	Intent it = new Intent(owner, MyWangcaiActivity.class);
    	owner.startActivity(it);
    }
    //��ʾ��ֵ�һ�
    public static void ShowExchageGiftActivity(Activity owner) {
    	Intent it = new Intent(owner, ExchageGiftActivity.class);
    	owner.startActivity(it);
    }
    //��ʾ��ȡ�ֽ�
    public static void ShowExtractActivity(Activity owner) {
    	Intent it = new Intent(owner, ExtractMoneyActivity.class);
    	owner.startActivity(it);
    }
    //��ʾ
    public static void ShowOptionActivity(Activity owner) {
    	Intent it = new Intent(owner, OptionsActivity.class);
    	owner.startActivity(it);
    }
    //����
    public static void ShowShareActivity(Activity owner) {
    }
    //�ͷ�����
    public static void ShowHelpActivity(Activity owner) {
    	ShowWebViewActivity(owner, "http://www.sina.com.cn");
    }
    //��������
    public static void ShowCommentActivity(Activity owner) {
    }
    //��д������Ϣ
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
    public static void ShowRegisterSucceedActivity(Activity owner, int nBindDeviceCount) {
    	Intent it = new Intent(owner, RegisterSucceedActivity.class);
    	it.putExtra(sg_strBindDeviceCount, nBindDeviceCount);
    	owner.startActivity(it);
    }
    public static void ShowWebViewActivity(Activity owner, String strUrl) {
    	Intent it = new Intent(owner, WebviewActivity.class);
    	it.putExtra(strUrl, strUrl);
    	owner.startActivity(it);
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
