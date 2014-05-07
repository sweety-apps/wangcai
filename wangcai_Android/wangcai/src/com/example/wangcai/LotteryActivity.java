package com.example.wangcai;

import java.util.ArrayList;
import java.util.Random;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;

public class LotteryActivity extends ManagedActivity {
	final static int sg_nBaseTimerElapse = 300;
	final static int sg_nSlowdownItems = 10;	//剩下多少个item开始减速
	final static int sg_nSlowSpeed = 80;
	
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
			new BonusInfo(0, R.id.icon34),
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
		int nRand = new Random().nextInt(listItems.size());
		return listItems.get(nRand);
	}

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lottery);
        
        Intent intent = this.getIntent();
        m_nBonus = intent.getIntExtra(ActivityHelper.sg_strBonus, 0);
        int nLoopCount = new Random().nextInt(sg_nMaxLoops - sg_nMinLoops) + sg_nMinLoops;
        m_nTotalAnimationTimes = nLoopCount * sg_bonusArray.length + GetItemIndex(m_nBonus);

        AttachEvents();

     }
    
    private void AttachEvents()
    {
    	this.findViewById(R.id.return_button).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	finish();
            }
        });
    
    	//抽奖按钮
    	this.findViewById(R.id.lottery_button).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	if (m_bTaskRunning) {
            		return ;
            	}
                new AnimistionTask().execute(m_nTotalAnimationTimes); 
      			m_bTaskRunning = true;
            }
        });
    }
    
    private class AnimistionTask extends AsyncTask<Integer, Integer, Integer> {

  		@Override
  		protected Integer doInBackground(Integer... params) {
  			while (m_nCurrentAnimationTimes < m_nTotalAnimationTimes) {
  			
  				int nSleepMiniSec = sg_nBaseTimerElapse;
  				int nRemainAnimationTimes = m_nTotalAnimationTimes - m_nCurrentAnimationTimes; 
  				if (nRemainAnimationTimes <=  sg_nSlowdownItems) {
  					//快完了就减速, 越接近, 速度越慢
  					nSleepMiniSec += (sg_nSlowdownItems - nRemainAnimationTimes) * sg_nSlowSpeed;
  				}
  				try {
					Thread.sleep(nSleepMiniSec);
				} catch (InterruptedException e) {
				}

                publishProgress(0);
  			}
  			return 0;
  		}
        @Override  
        protected void onProgressUpdate(Integer... nCurrentIndex) {
        	m_nCurrentAnimationTimes ++;
        }  
        @Override  
        protected void onPostExecute(Integer nItemIndex) {
        	m_bTaskRunning = false;
        }
    }
    
    private boolean m_bTaskRunning = false;
    private int m_nBonus = 0;
    private int m_nTotalAnimationTimes = 0;
    private int m_nCurrentAnimationTimes = 0;

    /*
    private void StartTimer() {
    	if (m_handler == null) {
	    	m_handler = new Handler(){  
				@Override  
				public void handleMessage(Message msg) {  
					switch (msg.what) {  
						case sg_nUpdateMsg:
							//ontimer
						break;
					}  
				}  
			};
    	}

    	if (m_timerTask == null) {  
    		m_timerTask = new TimerTask() {  
    			@Override  
    			public void run() {
	    			sendMessage(sg_nUpdateMsg);  
    			}
    		}; 
    	}
    }
    private void StopTimer() {
    	if (m_timer != null) {  
    		m_timer.cancel();  
    		m_timer = null;  
		}  
		 
		if (m_timerTask != null) {  
			m_timerTask.cancel();  
			m_timerTask = null;  
		}
	}
    public void sendMessage(int id){  
        if (m_handler != null) {  
            Message message = Message.obtain(m_handler, id);     
            m_handler.sendMessage(message);   
        }  
    } 
    //data member
    private int m_nCurrentItemIndex = 0;
    private Handler m_handler = null;
    private Timer m_timer = null;  
    private TimerTask m_timerTask = null;  
    */
}




