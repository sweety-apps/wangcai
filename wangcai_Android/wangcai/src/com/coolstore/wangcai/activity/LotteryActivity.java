package com.coolstore.wangcai.activity;

import java.util.ArrayList;
import java.util.Random;

import com.coolstore.common.BuildSetting;
import com.coolstore.request.RequestManager;
import com.coolstore.request.Requester;
import com.coolstore.request.RequesterFactory;
import com.coolstore.request.Requesters.Request_Lottery;
import com.coolstore.wangcai.ConfigCenter;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.WangcaiActivity;

import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.RelativeLayout;

public class LotteryActivity extends WangcaiActivity implements RequestManager.IRequestManagerCallback{
	final static int sg_nBaseTimerElapse = 70;
	final static int sg_nSlowdownItems = 8;	//剩下多少个item开始减速
	final static int sg_nSlowSpeed = 50;
	
	final static int sg_nFlashTimerElapse = 120;
	final static int sg_nTotalFlashTimes = 8;
	
	final static int sg_nUpdateMsg = 1;
	final static int sg_nMinLoops = 2;
	final static int sg_nMaxLoops = 4;
	
	private class BonusInfo {
		public BonusInfo(int nBonus, int nViewId) {
			m_nViewId = nViewId;
			m_nBonus = nBonus;
		}
		int m_nViewId;
		int m_nBonus;
	}
	private final BonusInfo sg_bonusArray[] = {
			new BonusInfo(50, R.id.icon11),
			new BonusInfo(0, R.id.icon12),
			new BonusInfo(10, R.id.icon13),
			new BonusInfo(0, R.id.icon14),
			new BonusInfo(800, R.id.icon24),
			new BonusInfo(50, R.id.icon34),
			new BonusInfo(10, R.id.icon44),
			new BonusInfo(300, R.id.icon43),
			new BonusInfo(0, R.id.icon42),
			new BonusInfo(50, R.id.icon41),
			new BonusInfo(10, R.id.icon31),
			new BonusInfo(0, R.id.icon21)
	};
	private int GetItemIndex(int nBouns) {
		ArrayList<Integer> listItems = new ArrayList<Integer>();
		
		int nItemCount = sg_bonusArray.length;
		for (int i = 0; i < nItemCount; ++i) {
			BonusInfo bonusInfo = sg_bonusArray[i];
			if (bonusInfo.m_nBonus == nBouns) {
				listItems.add(i);
			}
		}
		if (listItems.isEmpty()) {
			return -1;
		}
		int nRand = new Random().nextInt(listItems.size());
		return listItems.get(nRand);
	}

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lottery);
        
        AttachEvents();
     }
    
    private static final 	int BounsType_None = 0;
    private static final 	int BounsType_10 = 1;
    private static final 	int BounsType_50 = 2;
    private static final 	int BounsType_300 = 3;
    private static final 	int BounsType_800 = 4;
    public int GetBounsFromType(int nType) {
    	int nBouns = 0;
    	switch (nType) {
    	case BounsType_None:
    		nBouns = 0;
    		break;
    	case BounsType_10:
    		nBouns = 10;
    		break;
    	case BounsType_50:
    		nBouns = 50;
    		break;
    	case BounsType_300:
    		nBouns = 300;
    		break;
    	case BounsType_800:
    		nBouns = 800;
    		break;
    	}
    	return nBouns;
    }
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (req instanceof Request_Lottery) {
			if (m_progressDialog != null) {
				m_progressDialog.dismiss();
				m_progressDialog = null;
			}
			//请求抽奖
			int nResult = req.GetResult();
			if (nResult == RequestManager.sg_nNetworkdError) {
				ActivityHelper.ShowToast(this, R.string.hint_request_error);
				return;				
			}
			Request_Lottery lotteryRequester = (Request_Lottery)req;

			ConfigCenter.GetInstance().SetHasSignInToday();

			m_nBonus = GetBounsFromType(lotteryRequester.GetBouns());

			if (BuildSetting.sg_bIsRelease) {
				if (nResult != 0) {
					//已经签到过
					ActivityHelper.ShowToast(this, R.string.hint_duplicate_signin);
					return;
				}
			}

			//余额
			WangcaiApp.GetInstance().ChangeBalance(m_nBonus);

	        int nLoopCount = new Random().nextInt(sg_nMaxLoops - sg_nMinLoops) + sg_nMinLoops;
	       
	        int nIndex = GetItemIndex(m_nBonus);
	        if (nIndex < 0) {
				ActivityHelper.ShowToast(this, "错误");
				return;	        	
	        }
	        m_nTotalAnimationTimes = nLoopCount * sg_bonusArray.length + nIndex;

	        m_imageCover =  (ImageView)findViewById(R.id.select_cover);
	        m_imageBorder = (ImageView)findViewById(R.id.select_border);

	        AdjustInnerFrameLayout();
        	
        	if (m_animationTask != null) {
        		return;
        	}
        	m_animationTask = new AnimationTask();
        	m_animationTask.execute(m_nTotalAnimationTimes); 
        	
		}
	}
	private void AdjustInnerFrameLayout() {
    	RelativeLayout layout = (RelativeLayout)findViewById(R.id.grid_inner_frame);
    	int nWidth = layout.getWidth();

        WindowManager wm = (WindowManager) getSystemService(Context.WINDOW_SERVICE);  
        int nScreenWidth = wm.getDefaultDisplay().getWidth();  
        
    	RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
    	layoutParams.addRule(RelativeLayout.CENTER_VERTICAL);
    	layoutParams.setMargins((nScreenWidth - nWidth) / 2, 0, 0, 0);
    	layout.setLayoutParams(layoutParams);
	}
    private void AttachEvents()
    {
    	//抽奖按钮
    	this.findViewById(R.id.lottery_button).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
    			if (ConfigCenter.GetInstance().HasSignInToday()) {
    					ActivityHelper.ShowToast(LotteryActivity.this, R.string.hint_duplicate_signin);
    					return;
    			}    					
				RequestManager requestManager = RequestManager.GetInstance();
				Request_Lottery request = (Request_Lottery)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_Lottery);
				requestManager.SendRequest(request, true, LotteryActivity.this);
		        m_progressDialog = ActivityHelper.ShowLoadingDialog(LotteryActivity.this);
            }
        });
    	
    	this.findViewById(R.id.return_button).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	finish();
            }
        });
    
    }
    
    private class AnimationTask extends AsyncTask<Integer, Integer, Integer> {

  		@Override
  		protected Integer doInBackground(Integer... params) {
  			int nSwitchIndex = 0;
  			//转圈
  			while (nSwitchIndex < m_nTotalAnimationTimes) {
  			
  				int nSleepMiniSec = sg_nBaseTimerElapse;
  				int nRemainAnimationTimes = m_nTotalAnimationTimes - nSwitchIndex; 
  				if (nRemainAnimationTimes <=  sg_nSlowdownItems) {
  					//快完了就减速, 越接近, 速度越慢
  					nSleepMiniSec += (sg_nSlowdownItems - nRemainAnimationTimes) * sg_nSlowSpeed;
  				}
  				try {
					Thread.sleep(nSleepMiniSec);
				} catch (InterruptedException e) {
				}
  				nSwitchIndex ++;

                publishProgress(nSwitchIndex);
  			}
  			m_bLoopComplete = true;
  			
  			//闪烁
  			int nFlashTimes = 0;
  			while (nFlashTimes < sg_nTotalFlashTimes) {

                publishProgress(nFlashTimes);
				try {
					Thread.sleep(sg_nFlashTimerElapse);
				} catch (InterruptedException e) {
				}
  				nFlashTimes ++;
  			}
  			return 0;
  		}
  		@SuppressLint("NewApi") @Override  
        protected void onProgressUpdate(Integer... nCurrentIndexs) {
			if (m_animationTask == null || m_imageCover == null || m_imageBorder == null) {
				return;
			}
  			int nCurrentIndex= nCurrentIndexs[0];
  			if (m_bLoopComplete) {
  				//转完了, 闪烁下

  	        	if (nCurrentIndex == 0) {
  	  	  	       	m_imageCover.setVisibility(View.GONE);

	  	  	       	BonusInfo bonusInfo = sg_bonusArray[m_nTotalAnimationTimes % sg_bonusArray.length];	 
	  	  	       	ImageView targetImage = (ImageView)findViewById(bonusInfo.m_nViewId);
	
	  	  	        RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams)m_imageBorder.getLayoutParams();
	  	  	        layoutParams.setMargins(targetImage.getLeft() - 12, targetImage.getTop() - 12, 0, 0);
	  	  	        m_imageBorder.setLayoutParams(layoutParams);
  	        		m_imageBorder.setVisibility(View.VISIBLE);
  	        	}
  		       	
  	        	int nImgId = R.drawable.choujiang_border_selected1;
  	        	if (nCurrentIndex % 2 == 0) {
  	        		nImgId = R.drawable.choujiang_border_selected2;
  	        	}
  	        	m_imageBorder.setBackgroundResource(nImgId);
  			}
  			else {
  				//正在转
	          	BonusInfo bonusInfo = sg_bonusArray[nCurrentIndex % sg_bonusArray.length];	        	
	        	ImageView targetImage = (ImageView)findViewById(bonusInfo.m_nViewId);
	        	
	        	m_imageCover.setTop(targetImage.getTop());
	        	m_imageCover.setLeft(targetImage.getLeft());
	        	m_imageCover.setRight(targetImage.getRight());
	        	m_imageCover.setBottom(targetImage.getBottom());
	        	m_imageCover.setVisibility(View.VISIBLE);
  			}
        }  
        @Override  
        protected void onPostExecute(Integer nItemIndex) {
        	//动画完成
        	m_animationTask = null;
	        m_imageCover.setVisibility(View.GONE);
	        m_imageBorder.setVisibility(View.GONE);
	        if (m_nBonus > 0) {
	        	ShowPurseTip(m_nBonus, getString(R.string.new_lottery_award_tip_title));
	        	WangcaiApp.GetInstance().PlaySound();
	        }
	        else {
	        	ActivityHelper.ShowToast(LotteryActivity.this, R.string.lotter_no_award_tip);
	        }
        }
    }

    @Override 
    protected void onDestroy() {
    	if (m_animationTask != null) {
    		m_animationTask.cancel(true);
    		m_animationTask = null;
    	}
		m_imageCover = null;
		m_imageBorder = null;
    	super.onDestroy();
     }
    
    //private boolean m_bTaskRunning = false;
    private int m_nBonus = 0;
    private int m_nTotalAnimationTimes = 0;
    private AnimationTask m_animationTask = null;
    private boolean m_bLoopComplete = false;
    private ImageView m_imageCover = null;
    private ImageView m_imageBorder = null;
    private ProgressDialog m_progressDialog = null;
}




