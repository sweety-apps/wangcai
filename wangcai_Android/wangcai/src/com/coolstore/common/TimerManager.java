package com.coolstore.common;

import java.lang.ref.WeakReference;
import java.util.Timer;
import java.util.TimerTask;

import android.os.Handler;
import android.os.Message;
import android.util.SparseArray;

public class TimerManager {
	private final static int sg_TimerMsg = 1818;
	public interface TimerManagerCallback {
		void OnTimer(int nId, int nHitTimes);
	}
	
	private static TimerManager sg_obj = null;
	public static TimerManager GetInstance() {
		if (sg_obj == null) {
			sg_obj = new TimerManager();
		}
		return sg_obj;
	}


    private static class TimerHandler extends Handler {
    	TimerHandler(int nId, TimerManagerCallback callback) {
    		m_nId = nId;
    		m_callback = new WeakReference<TimerManagerCallback>(callback);
    	}
		@Override  
		public void handleMessage(Message msg) {  
			if (msg.what == sg_TimerMsg) {
				TimerManagerCallback callback = m_callback.get();
				if (callback == null) {
					TimerManager.GetInstance().StopTimer(m_nId);
					return;
				}
				++m_nHitTimes;
				callback.OnTimer(m_nId, m_nHitTimes);
			}  
		} 
		private int m_nHitTimes = 0;
		private int m_nId;
		private WeakReference<TimerManagerCallback> m_callback;
    }
	private static class TimerRecord {
		TimerRecord(int nId, TimerManagerCallback callback) {
			m_handler = new TimerHandler(nId, callback);
			m_timerTask = new TimerTask(){  
    			@Override  
    			public void run() {
	    			sendMessage(sg_TimerMsg);  
    			}
    		}; 
		}
	    public void sendMessage(int id){  
	        if (m_handler != null) {  
	            Message message = Message.obtain(m_handler, id);     
	            m_handler.sendMessage(message);   
	        }  
	    } 
		public TimerTask m_timerTask = null;  
	    public Handler m_handler = null;
	}
	
	public int StartTimer(int nElapse, TimerManagerCallback callback) {
		return StartTimer(nElapse, 0, callback);
	}
	public int StartTimer(int nElapse, int nDelay, TimerManagerCallback callback) {
		if (nElapse <= 0) {
			return -1;
		}
		int nId = IdGenerator.NewId();
		TimerRecord record = new TimerRecord(nId, callback);
		GetTimer().schedule(record.m_timerTask, nDelay, nElapse);
		
		m_mapTimers.put(nId, record);
		return nId;
	}
	public boolean StopTimer(int nId) {
		TimerRecord record = m_mapTimers.get(nId);
		if (record == null) {
			return false;
		}

		record.m_timerTask.cancel();
		m_mapTimers.remove(nId);
		return true;
	}
	
	
	private Timer GetTimer() {
		if (m_timer == null) {
			m_timer = new Timer();
		}
		return m_timer;
	}
	

	
	private SparseArray<TimerRecord> m_mapTimers = new SparseArray<TimerRecord>();
    private Timer m_timer = null;		
}


