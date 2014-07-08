package com.coolstore.wangcai.activity;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;

import com.coolstore.wangcai.R;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.WangcaiActivity;

public class SurveyRuleActivity extends WangcaiActivity{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_suvery_rule);
        
        
        findViewById(R.id.agree_button).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				SurveyRuleActivity.this.finish();
				ActivityHelper.ShowSurveyActivity(SurveyRuleActivity.this, getIntent().getIntExtra(ActivityHelper.sg_strTaskId, 0));
			} 
        });
        findViewById(R.id.disagree_button).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				SurveyRuleActivity.this.finish();
			} 
        });
    }
}
