package com.coolstore.request;

import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.ref.WeakReference;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.KeyStore;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;

import com.coolstore.common.BuildSetting;
import com.coolstore.common.IdGenerator;
import com.coolstore.common.LogUtil;
import com.coolstore.common.SystemInfo;
import com.coolstore.common.Util;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.WangcaiApp.WangcaiAppEvent;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.AsyncTask;

public class RequestManager {
	public static final int sg_nNetworkdError = -1;
	public static final String g_strPost = "POST";
	public static final String g_strGet = "GET";
	
	
	private static RequestManager sg_requestManager = new RequestManager();
	public static RequestManager GetInstance() {
		return sg_requestManager;
	}
	private class RequestRecord {
		RequestRecord(int nRequestId, boolean bOverwrite, Requester requester, IRequestManagerCallback pCallback) {
			m_nRequestId = nRequestId;
			m_pCallback = new WeakReference<IRequestManagerCallback>(pCallback);
			m_requester = requester;
			m_bOverwrite = bOverwrite;
		}
		Requester m_requester;
		int m_nRequestId = 0;
		boolean m_bOverwrite = false;
		WeakReference<IRequestManagerCallback> m_pCallback;
	}
	
	public interface IRequestManagerCallback {
		void OnRequestComplete(int nRequestId, Requester req);
	}
	
	public interface IRequestManagerEvent {
		boolean RequestManagerOnComplete(Requester req, boolean bOverwrite, IRequestManagerCallback pCallback); 
	}
	
	void InitSSLContext(Context context) {

		// Load CAs from an InputStream
		// (could be from a resource or ByteArrayInputStream or ...)
		InputStream inputStream = null;
        try {
        	inputStream = context.getAssets().open("wangcai.bks"); 
        	KeyStore  keyStore = KeyStore.getInstance("BKS", "BC"); 
			keyStore.load(inputStream, "pw12306".toCharArray());
			String tmfAlgorithm = TrustManagerFactory.getDefaultAlgorithm();
			TrustManagerFactory tmf = TrustManagerFactory.getInstance(tmfAlgorithm);
			tmf.init(keyStore);
			m_sslContext = SSLContext.getInstance("TLS");
			m_sslContext.init(null, tmf.getTrustManagers(), null);
		}catch(Exception ex) {
		}
		if (inputStream != null) {
			try {
				inputStream.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public void Initialize(InputStream caInput) {
		InitSSLContext(WangcaiApp.GetInstance().GetContext());
	}
	private Map<String, String> GetSessionData() {
		Map<String, String> mapData = new HashMap<String, String>();
		if (!Util.IsEmptyString(m_strDeviceId)) {
			mapData.put("device_id", m_strDeviceId);
		}
		if (!Util.IsEmptyString(m_strSessionId)) {
			mapData.put("session_id", m_strSessionId);
		}
		if (m_nUserId >= 0) {
			mapData.put("userid", String.valueOf(m_nUserId));
		}
		return mapData;
	}
	
	public int SendRequest(Requester req, boolean bOverwrite, IRequestManagerCallback pCallback) {
		//todo   去重
		int nRequestId = IdGenerator.NewId();
		req.SetId(nRequestId);
		RequestRecord pRecord = new RequestRecord(nRequestId, bOverwrite, req, pCallback);
		Map<String, String> mapData = GetSessionData();
		if (!pRecord.m_requester.IsRaw() &&  mapData.size() > 0) {
			req.AddData(mapData);
		}
        new RequestTask().execute(pRecord); 
		return nRequestId;
	}

	private String GetCookie() {
		String strCookie = String.format("p=android_%s_%s; net=%s; app=%s; ver=%s; local_ip=%s", 
				SystemInfo.GetSystemVersion(), 
				SystemInfo.GetPhoneModel(), 
				SystemInfo.GetNetworkType(), 
				BuildSetting.sg_strAppName, 
				SystemInfo.GetVersion(), 
				SystemInfo.GetIp());

		//strCookie = "iPhone 5s_7.0.4; os=android; net=wifi; app=wangcai; ver=2.2; local_ip=10.66.149.88";
		return strCookie;
	}

    private class RequestTask extends AsyncTask<RequestRecord, RequestRecord, RequestRecord> {

		@Override
		protected RequestRecord doInBackground(RequestRecord... params) {
			//todo 会不会有多个?
			RequestRecord reqRecord = params[0];
			DoRequest(reqRecord);
			return reqRecord;
		}
		//background
		private void DoRequest(RequestRecord reqRecord) {
			int nMaxRetryTimes = reqRecord.m_requester.GetMaxRetryTimes();
			while (!SendRequest(reqRecord) && --nMaxRetryTimes > 0) {
			}
		}
		
		@SuppressLint("DefaultLocale") private boolean SendRequest(RequestRecord reqRecord) {
            HttpURLConnection connection = null;
			Requester req = reqRecord.m_requester;
			try {
				req.Initialize();
				
                String strUrl = req.GetUrl();
				URL url = new URL(strUrl);

				if (strUrl.toLowerCase(Locale.US).contains("https://")) {
	                //SSLContext sc = SSLContext.getInstance("TLS"); 
	                //sc.init(null, new TrustManager[]{new HttpsHelper.MyTrustManager()}, new SecureRandom());
	                HttpsURLConnection.setDefaultSSLSocketFactory(m_sslContext.getSocketFactory()); 
	                HttpsURLConnection.setDefaultHostnameVerifier(new HttpsHelper.MyHostnameVerifier());
					connection = (HttpsURLConnection)url.openConnection(); 
				}
				else {
					connection = (HttpURLConnection)url.openConnection(); 
				}

				connection.setConnectTimeout(16 * 1000);
				if (!Util.IsEmptyString(req.GetCookie())) {
                	connection.addRequestProperty("Cookie", req.GetCookie());
                }else if (!req.IsRaw()){
                	connection.addRequestProperty("Cookie", GetCookie());
                }
 
				connection.setRequestMethod(req.GetRequestMethod());
				connection.setDoInput(true);
				
				String strPostData = req.GetPostData();
				if (!Util.IsEmptyString(strPostData) && req.IsPost()) {
					connection.setDoOutput(true);
					DataOutputStream streamWriter = new DataOutputStream(connection.getOutputStream());
					streamWriter.writeBytes(strPostData);
					streamWriter.flush();
					streamWriter.close();
				}
				InputStream inputStream = connection.getInputStream();
				//hook了, 返回
				if (reqRecord.m_requester.HookRequestComplete(inputStream)) {
					return true;
				}
				
				//读数据
 				InputStreamReader streamReader = new InputStreamReader(inputStream);
 				
				StringBuffer stringBuffer = new StringBuffer();
				final int nBufferSize = 1024;
				char[] buffer = new char[nBufferSize];
				while (true) {
					int nReadCount = 0;
					try {
						nReadCount = streamReader.read(buffer, 0, nBufferSize);
					}
					catch(IndexOutOfBoundsException e) {
						nReadCount = -1;
					}
					if (nReadCount <= 0) {
						break;
					}
					stringBuffer.append(buffer, 0, nReadCount);
					if (nReadCount < nBufferSize) {
						break;	//读完了
					}
				}
				
				//交给外面解析
				String strRespData = stringBuffer.toString();
				reqRecord.m_requester.Parse(strRespData);
			}
			catch(Exception ex){
				if (connection != null) {
					try {
						int nRespCode = connection.getResponseCode();
						String strClassName = reqRecord.m_requester.getClass().toString();
						LogUtil.LogWangcai("Request  getResponseCode(%d), Name(%s)", nRespCode, strClassName);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				reqRecord.m_requester.Parse(null);
				return false;
			}
			return true;
		}

        @Override  
	    protected void onPreExecute() {
	    }
        @Override  
        protected void onCancelled() {
        }
        @Override  
        protected void onProgressUpdate(RequestRecord... reqRecord) {  
        }  
        @Override  
        protected void onPostExecute(RequestRecord reqRecord) {
        	if (m_listRequestManagerEvents != null) {
        		for (WeakReference<IRequestManagerEvent> eventHandlerRef : m_listRequestManagerEvents) {
        			IRequestManagerEvent eventHandler = eventHandlerRef.get();
        			if (eventHandler != null) {
        				eventHandler.RequestManagerOnComplete(reqRecord.m_requester, reqRecord.m_bOverwrite, reqRecord.m_pCallback.get());
        			}
        		}
        	}
        	if (reqRecord != null && reqRecord.m_pCallback != null) {
        		IRequestManagerCallback pCallback = reqRecord.m_pCallback.get();
        		if (pCallback != null){
        			pCallback.OnRequestComplete(reqRecord.m_nRequestId, reqRecord.m_requester);
        		}
        	}
        }
    }
    public void AttchEvent(IRequestManagerEvent newEventHandler) {
    	if (m_listRequestManagerEvents == null) {
    		m_listRequestManagerEvents = new ArrayList<WeakReference<IRequestManagerEvent>>();
    	}

		for (WeakReference<IRequestManagerEvent> eventHandlerRef : m_listRequestManagerEvents) {
			IRequestManagerEvent eventHandler = eventHandlerRef.get();
			if (eventHandler == newEventHandler) {
				return;
			}
		}
		m_listRequestManagerEvents.add(new WeakReference<IRequestManagerEvent>(newEventHandler));
    }
    public void DetachEvent(IRequestManagerEvent newEventHandler) {
    	if (m_listRequestManagerEvents == null) {
    		return;
    	}

    	int i = 0;
		for (WeakReference<IRequestManagerEvent> eventHandlerRef : m_listRequestManagerEvents) {
			IRequestManagerEvent eventHandler = eventHandlerRef.get();
			if (eventHandler == newEventHandler) {
				m_listRequestManagerEvents.remove(i);
				break;
			}
			++i;
		}
    }
    
    public String BuildSessoinUrl(String strUrl) {	
		Map<String, String> mapData = GetSessionData();
		if (mapData.size() > 0) {
			String strData = Util.FormatNetworkData(mapData);
			return Util.AddData2Url(strUrl, strData);    	
		}
		else {
			return strUrl;
		}
    }

	public void SetUserId(int nUserId) {
		m_nUserId = nUserId;
	}
	public void SetSessionId(String strSessionId) {
		m_strSessionId = strSessionId;
	}
	public void SetDeviceId(String strDeviceId) {
		m_strDeviceId = strDeviceId;
	}

    private SSLContext m_sslContext;
	private String m_strSessionId;
	private String m_strDeviceId;
	private int m_nUserId = -1;
	private ArrayList<WeakReference<IRequestManagerEvent>> m_listRequestManagerEvents;
}



