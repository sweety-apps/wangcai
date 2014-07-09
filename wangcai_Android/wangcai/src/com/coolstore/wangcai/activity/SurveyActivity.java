package com.coolstore.wangcai.activity;

import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;

import com.coolstore.common.Util;
import com.coolstore.request.RequestManager;
import com.coolstore.request.Requester;
import com.coolstore.request.RequesterFactory;
import com.coolstore.request.SurveyInfo;
import com.coolstore.request.Requesters.Request_Survey;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.ManagedDialog;
import com.coolstore.wangcai.dialog.CommonDialog;

public class SurveyActivity extends WebviewActivity implements RequestManager.IRequestManagerCallback{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        m_nTaskId = this.getIntent().getIntExtra(ActivityHelper.sg_strTaskId, 0);
                
        SurveyInfo info = WangcaiApp.GetInstance().GetSurveyInfo(m_nTaskId);
        if (info == null) {
        	return;
        }
        SetTitle(getString(R.string.survey_title));
        SetUrl(info.m_strUrl);
    }

    @Override
    protected boolean OnNavigate(String strUrl)  {
    	if (super.OnNavigate(strUrl)) {
    		return true;
    	}
	    if (strUrl.contains("/wangcai_js/alert_loading")) {
	    	String strShow = GetUrlKeyValue(strUrl, "show");
	    	if (strShow.equals("1")) {
		    	String strInfo = GetUrlKeyValue(strUrl, "info");
		        m_progressDialog = ActivityHelper.ShowLoadingDialog(this, strInfo);	    		
	    	}
	    	else {
	    		if (m_progressDialog != null) {
	    			m_progressDialog.dismiss();
	    			m_progressDialog = null;
	    		}
	    	}
	    }
	    else if (strUrl.contains("/wangcai_js/commit")) {
	    	ArrayList<Util.StringPair> listParams = ParseUrlParams(strUrl);
	    	if (listParams == null || listParams.isEmpty()) {
	    		return true;
	    	}
	    	JSONObject jsonObject = new JSONObject(); 
	    	for (Util.StringPair res : listParams) {
	    		try {
					jsonObject.put(res.m_strName, res.m_strValue);
				} catch (JSONException e) {
				}
	    	} 
	    	String strSurveyText = jsonObject.toString();

			RequestManager requestManager = RequestManager.GetInstance();
			Request_Survey request = (Request_Survey)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_Survey);
			request.SetSurveyId(m_nTaskId);
			request.SetSurveyData(strSurveyText);
			requestManager.SendRequest(request, true, this);

			m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
			m_progressDialog.show();
	    }
	    else {
	    	return false;
	    }
    	return true;
    }

	@Override
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (m_progressDialog != null) {
			m_progressDialog.dismiss();
			m_progressDialog = null;
		}
		if (req instanceof Request_Survey) {
			if (req.GetResult() != 0) {
				Util.ShowRequestErrorMsg(this, req.GetMsg());
			}
			else {
				WangcaiApp.GetInstance().RequestSurveyInfo();
    			if (m_commitSucceedDialog == null) {
    				m_commitSucceedDialog = new CommonDialog(this);
    				RegisterDialog(m_commitSucceedDialog);
    			}
    			m_commitSucceedDialog.SetInfo(getString(R.string.survey_commit_succeed_title), getString(R.string.survey_commit_succeed_text), 
    					getString(R.string.survey_commit_succeed_button_text), null);
    			m_commitSucceedDialog.Show();	
			}
		}
	}

	public void OnDialogFinish(ManagedDialog dlg, int inClickedViewId) {
		int nDialogId = dlg.GetDialogId();
		if (m_commitSucceedDialog != null && nDialogId == m_commitSucceedDialog.GetDialogId()) {
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				finish();
			}	
		}
	}
    private Util.StringPair ParseKeyValue(String strText) {
    	int nPos = strText.indexOf("=");
    	if (nPos < 0) {
    		return null;
    	}
    	
    	String strName = strText.substring(0, nPos);
    	String strValue = strText.substring(nPos + 1, strText.length());
    	return new Util.StringPair(strName, strValue);
    }
    private ArrayList<Util.StringPair> ParseUrlParams(String strUrl) {
    	ArrayList<Util.StringPair> listParams = new ArrayList<Util.StringPair>();
    	
    	int nBeginPos = strUrl.indexOf("?");
    	if (nBeginPos < 0) {
        	return listParams;
    	}
    	
    	nBeginPos++;
    	while (true) {
    		int nPos = strUrl.indexOf("&", nBeginPos);
    		if (nPos < 0) {
    			String strText = strUrl.substring(nBeginPos, strUrl.length());
    			Util.StringPair res = ParseKeyValue(strText);
    			if (res != null) {
    				listParams.add(res);
    			}
    			break;
    		}
    		
			String strText = strUrl.substring(nBeginPos, nPos);
			Util.StringPair res = ParseKeyValue(strText);
			if (res != null) {
				listParams.add(res);
			}
			nBeginPos = nPos + 1;
    	}
 
    	
    	return listParams;
    }
    
    
    private ProgressDialog m_progressDialog;
    private CommonDialog m_commitSucceedDialog = null;
    private int m_nTaskId = 0;
}
