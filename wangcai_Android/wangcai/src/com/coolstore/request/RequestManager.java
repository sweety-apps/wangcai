package com.coolstore.request;

import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;














import com.coolstore.common.BuildSetting;
import com.coolstore.common.IdGenerator;
import com.coolstore.common.LogUtil;
import com.coolstore.common.SystemInfo;
import com.coolstore.common.Util;

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
		RequestRecord(int nRequestId, Requester requester, IRequestManagerCallback pCallback) {
			m_nRequestId = nRequestId;
			m_pCallback = pCallback;
			m_requester = requester;
		}
		Requester m_requester;
		int m_nRequestId = 0;
		IRequestManagerCallback m_pCallback;
	}
	
	public interface IRequestManagerCallback {
		void OnRequestComplete(int nRequestId, Requester req);
	}
	
	
	public void Initialize(InputStream caInput) {
		// Load CAs from an InputStream
		// (could be from a resource or ByteArrayInputStream or ...)
		/*
		try {
			CertificateFactory cf = CertificateFactory.getInstance("X.509");
			// From https://www.washington.edu/itconnect/security/ca/load-der.crt
			java.security.cert.Certificate ca = null;
			try {
			    ca = cf.generateCertificate(caInput);
			} catch(Exception ex) {
				String strMsg = ex.toString();
				String strTemp  = strMsg + "xxxx";
			    return ;
			}
			finally {
			    caInput.close();
			}
	
			// Create a KeyStore containing our trusted CAs
			String keyStoreType = KeyStore.getDefaultType();
			KeyStore keyStore = KeyStore.getInstance(keyStoreType);
			keyStore.load(null, null);
			keyStore.setCertificateEntry("ca", ca);
	
			// Create a TrustManager that trusts the CAs in our KeyStore
			String tmfAlgorithm = TrustManagerFactory.getDefaultAlgorithm();
			TrustManagerFactory tmf = TrustManagerFactory.getInstance(tmfAlgorithm);
			tmf.init(keyStore);
	
			// Create an SSLContext that uses our TrustManager
			m_sslContext = SSLContext.getInstance("TLS");
			m_sslContext.init(null, tmf.getTrustManagers(), null);
		}catch(Exception ex) {
			String strMsg = ex.toString();
			String strTemp  = strMsg + "xxxx";
		}
		*/
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
		//todo   ȥ��
		int nRequestId = IdGenerator.NewId();
		req.SetId(nRequestId);
		RequestRecord pRecord = new RequestRecord(nRequestId, req, pCallback);
		Map<String, String> mapData = GetSessionData();
		if (!pRecord.m_requester.IsRaw() &&  mapData.size() > 0) {
			pRecord.m_requester.GetRequestInfo().AddData(mapData);
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
				BuildSetting.sg_strVersion, 
				SystemInfo.GetIp());

		//strCookie = "iPhone 5s_7.0.4; os=android; net=wifi; app=wangcai; ver=2.2; local_ip=10.66.149.88";
		return strCookie;
	}

    private class RequestTask extends AsyncTask<RequestRecord, RequestRecord, RequestRecord> {

		@Override
		protected RequestRecord doInBackground(RequestRecord... params) {
			//todo �᲻���ж��?
			RequestRecord reqRecord = DoRequest(params[0]);
			return reqRecord;
		}
		//background
		private RequestRecord DoRequest(RequestRecord reqRecord) {
            HttpURLConnection connection = null;
			try {
				Requester req = reqRecord.m_requester;
				Requester.RequestInfo requestInfo = req.GetRequestInfo();
                String strUrl = requestInfo.m_strUrl;
				URL url = new URL(strUrl);

				if (strUrl.toLowerCase().contains("https://")) {
	                SSLContext sc = SSLContext.getInstance("TLS"); 
	                sc.init(null, new TrustManager[]{new HttpsHelper.MyTrustManager()}, new SecureRandom());
	                HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory()); 
	                HttpsURLConnection.setDefaultHostnameVerifier(new HttpsHelper.MyHostnameVerifier());
					connection = (HttpsURLConnection)url.openConnection(); 
				}
				else {
					connection = (HttpURLConnection)url.openConnection(); 
				}

				connection.setConnectTimeout(10 * 1000);
				if (!Util.IsEmptyString(requestInfo.m_strCookie)) {
                	connection.addRequestProperty("Cookie", requestInfo.m_strCookie);
                }else if (!req.IsRaw()){//todo
                	connection.addRequestProperty("Cookie", GetCookie());
                }
 
				connection.setRequestMethod(requestInfo.m_strRequestMethod);
				connection.setDoInput(true);
				
				String strPostData = requestInfo.m_strPostData;
				if (!Util.IsEmptyString(strPostData) && requestInfo.m_strRequestMethod.equals(g_strPost)) {
					connection.setDoOutput(true);
					DataOutputStream streamWriter = new DataOutputStream(connection.getOutputStream());
					streamWriter.writeBytes(strPostData);
					streamWriter.flush();
					streamWriter.close();
				}
				InputStream inputStream = connection.getInputStream();
				//hook��, ����
				if (reqRecord.m_requester.HookRequestComplete(inputStream)) {
					return reqRecord;
				}
				
				//������
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
						break;	//������
					}
				}
				
				//�����������
				String strRespData = stringBuffer.toString();
				reqRecord.m_requester.Parse(strRespData);
			}
			catch(Exception ex){
				if (connection != null) {
					try {
						int nRespCode = connection.getResponseCode();
						String strClassName = reqRecord.m_requester.getClass().toString();
						LogUtil.LogWangcai("Request  getResponseCode(%d), Name(%s)", nRespCode, strClassName);
						int i = 0;
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				reqRecord.m_requester.Parse(null);
			}
			return reqRecord;
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
        	if (reqRecord != null && reqRecord.m_pCallback != null) {
        		reqRecord.m_pCallback.OnRequestComplete(reqRecord.m_nRequestId, reqRecord.m_requester);
        	}
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
}