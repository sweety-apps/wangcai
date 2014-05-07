package com.example.wangcai;

import com.example.request.RequestManager;
import com.example.request.Request_UpdateUserInfo;
import com.example.request.Requester;
import com.example.request.RequesterFactory;
import com.example.request.Util;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.RadioGroup;

public class SurveyActivity extends ManagedActivity implements RequestManager.IRequestManagerCallback, OnClickListener{

	class InterestInfo {
		InterestInfo(int nViewId, String strName) {
			m_nViewId = nViewId;
			m_strName = strName;
		}
		int m_nViewId;
		String m_strName;
	}

    //@"leisure_game",@"level_up",@"discount",@"friends",@"trevel",@"compete_game",@"physic_ex",@"beauty", nil] retain];
	InterestInfo listInterestInfo[] = {
			new InterestInfo(R.id.userinfo_relaxation_game, "leisure_game"),
			new InterestInfo(R.id.userinfo_rpg_game, "level_up"),
			new InterestInfo(R.id.userinfo_ebuy, "discount"),
			new InterestInfo(R.id.userinfo_social_contact, "friends"),
			new InterestInfo(R.id.userinfo_travel	, "trevel"),
			new InterestInfo(R.id.userinfo_competitive_game, "compete_game"),
			new InterestInfo(R.id.userinfo_sport, "physic_ex"),
			new InterestInfo(R.id.userinfo_beautify, "beauty"),
		};
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_survey);        

        InitView();
        
        
     }
    
    private void InitView() {
    	this.findViewById(R.id.confirm_button).setOnClickListener(this);
    	
    	Intent it = getIntent();
    	int nAge = it.getIntExtra(ActivityHelper.sg_strAge, 0);
    	int nSex = it.getIntExtra(ActivityHelper.sg_strSex, 0);
    	String strInterest = it.getStringExtra(ActivityHelper.sg_strInterest);
    	
    }
    

	public void OnRequestComplete(int nRequestId, Requester req) {
		if (req instanceof Request_UpdateUserInfo) {
		}
	}

	@Override
	public void onClick(View v) {
		int nId = v.getId();
		if (nId == R.id.confirm_button) {
			//Ã·Ωª
			RadioGroup group =  (RadioGroup)this.findViewById(R.id.sex_group);
			int nCheckViewId = group.getCheckedRadioButtonId();
			int nSex = 1;
			if (nCheckViewId == R.id.male_button) {
				nSex = 1;
			}
			else if (nCheckViewId == R.id.female_button) {
				nSex = 2;
			}
			else {
	    		ActivityHelper.ShowToast(this, R.string.hint_select_sex);
	    		return;				
			}
			
			EditText ageEdit = (EditText)this.findViewById(R.id.age_edit);
			String strAge = ageEdit.getText().toString();
			int nAge = 0;
			try {
				nAge = Integer.valueOf(strAge);
				if (Util.IsEmptyString(strAge) || nAge <= 0 || nAge > 99) {
		    		ActivityHelper.ShowToast(this, R.string.hint_select_sex);
		    		return;					
				}
			}catch (Exception e) {
	    		ActivityHelper.ShowToast(this, R.string.hint_select_sex);
	    		return;				
			}

			StringBuffer stringBuffer = new StringBuffer();
	    	for (InterestInfo info: listInterestInfo) {
	    		CheckBox button = (CheckBox)this.findViewById(info.m_nViewId);
	    		if (button.isChecked()) {
	    			if (stringBuffer.length() > 0) {
	    				stringBuffer.append("|");
	    			}
	    			stringBuffer.append(info.m_strName);
	    		}
	    	}
	    	if (stringBuffer.length() <= 0) {
	    		ActivityHelper.ShowToast(this, R.string.hint_select_interest);
	    		return;
	    	}
	    	
			RequestManager requestManager = RequestManager.GetInstance();
			Request_UpdateUserInfo updateInfoReq = (Request_UpdateUserInfo)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_UpdateUserInfo);
			updateInfoReq.SetAge(m_nAge);
			updateInfoReq.SetSex(nSex);
			updateInfoReq.SetInterest(stringBuffer.toString());
			requestManager.SendRequest(updateInfoReq, true, this);
		}
	}

    private int m_nAge;
    private int m_nSex;
    private String m_strInterest;
}
