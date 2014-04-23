package com.example.wangcai;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

import org.json.JSONTokener;

import android.os.AsyncTask;
import android.util.Log;

public class RequestManager {
	static final String g_strPost = "POST";
	static final String g_strGet = "GET";
	
	public class RequestInfo {
		int m_nRequestId;
		String m_strRequestMethod = "GET";
		String m_strUrl;
		String m_strCookie;
		String m_strPostData;
		IRequestManagerCallback m_pCallback;
	}
	private class RepsonseInfo {
		int m_nRequestId;
		int m_nResult;
		IRequestManagerCallback m_pCallback;
		Map<String, String> m_mapRespData;
	}
	
	public interface IRequestManagerCallback {
		void OnRequestComplete(int nRequestId, int nResult, Map<String, String> mapRespData);
	}
	
	
	int PostRequest(RequestInfo requestInfo, IRequestManagerCallback pCallback) {
		return 1;
	}

    private class RequestTask extends AsyncTask<RequestInfo, RepsonseInfo, RepsonseInfo> {

		@Override
		protected RepsonseInfo doInBackground(RequestInfo... params) {
			RepsonseInfo respInfo = DoRequest(params[0]);
			return respInfo;
		}
		//background
		private RepsonseInfo DoRequest(RequestInfo requestInfo) {
			RepsonseInfo respInfo = new RepsonseInfo();
			try {
				URL url = new URL(requestInfo.m_strUrl);
				HttpURLConnection connection = (HttpURLConnection)url.openConnection();
				connection.setRequestMethod(requestInfo.m_strRequestMethod);
				connection.setDoInput(true);
				
				String strPostData = requestInfo.m_strPostData;
				if (strPostData != null && requestInfo.m_strRequestMethod.equals(g_strPost)) {
					connection.setDoOutput(true);
					DataOutputStream streamWriter = new DataOutputStream(connection.getOutputStream());
					streamWriter.writeBytes(strPostData);
					streamWriter.flush();
					streamWriter.close();
				}
				InputStreamReader streamReader = new InputStreamReader(connection.getInputStream());
				BufferedReader bufferedReader = new BufferedReader(streamReader);
				
				StringBuffer stringBuffer = new StringBuffer();
				final int nBufferSize = 1024;
				char[] buffer = new char[nBufferSize];
				int nOffset = 0;
				while (true) {
					int nReadCount = 0;
					try {
						streamReader.read(buffer, nOffset, nBufferSize);
					}
					catch(IndexOutOfBoundsException e) {
						nReadCount = -1;
					}
					if (nReadCount == -1) {
						break;
					}
					stringBuffer.append(buffer, 0, nReadCount);
					nOffset += nReadCount;
				}
				String strJsonValue = stringBuffer.toString();
				JSONTokener jsonParser = new JSONTokener(strJsonValue);  
			}
			catch(Exception ex){
				respInfo.m_nResult = 0;
			}
			return respInfo;
		}

        @Override  
	    protected void onPreExecute() {
	    }
        @Override  
        protected void onCancelled() {
        }
        @Override  
        protected void onProgressUpdate(RepsonseInfo... response) {  
        }  
        @Override  
        protected void onPostExecute(RepsonseInfo response) {
        }
    }

    private class IdGenerator {
    	public int NewId() {
    		return ++m_id;
    	}
    	private int m_id = 0;
    }
}
