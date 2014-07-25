package com.coolstore.request;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import com.coolstore.common.Util;


public abstract class Requester {

	private static class RequestInfo {
		RequestInfo(String strUrl, String strCookie) {
			m_strUrl = strUrl;
			m_strBuildedUrl = strUrl;
			m_strCookie = strCookie;
			m_strRequestMethod = RequestManager.g_strGet;
		}
		RequestInfo(String strUrl, String strCookie, Map<String, String> mapData, boolean bPost) {
			m_strUrl = strUrl;
			m_strBuildedUrl = strUrl;
			m_strCookie = strCookie;
			if (bPost) {
				m_strRequestMethod = RequestManager.g_strPost;
			}
			else {
				m_strRequestMethod = RequestManager.g_strGet;
			}
			AddData(mapData);
		}
		public void AddData(Map<String, String> mapData) {
			if (mapData == null || mapData.size() <= 0) {
				return ;
			}
			
			if (m_mapExtractData == null) {
				m_mapExtractData = mapData;
			}
			else {
				Iterator iter = mapData.entrySet().iterator(); 
				while (iter.hasNext()) { 
					Map.Entry entry = (Map.Entry) iter.next(); 
					String strKey = (String)entry.getKey(); 
					String strValue = (String)entry.getValue();
					m_mapExtractData.put(strKey, strValue);
				}  
			}
			if (m_bBuilded) {
				BuildData();
			}
		}
		public void AddData(String strName, String strValue) {
			if (m_mapExtractData == null) {
				m_mapExtractData = new HashMap<String, String>();
			}
		    m_mapExtractData.put(strName, strValue);
		    
			if (m_bBuilded) {
				BuildData();
			}	
		}
		public String GetUrl() {
			if (!m_bBuilded) {
				BuildData();				
			}
			return m_strBuildedUrl;
		}
		public String GetRequestMethod() {
			return m_strRequestMethod;
		}
		public String GetPostData() {
			if (!m_bBuilded) {
				BuildData();				
			}
			return m_strPostData;
		}
		public String GetCookie() {
			return m_strCookie;
		}
		protected boolean IsPost() {
			return !IsGet();
		}
		private boolean IsGet() {
			return RequestManager.g_strGet.equals(m_strRequestMethod);
		}
		public void ResetBuildedData() {
			m_bBuilded = false;
			m_strBuildedUrl = m_strUrl;
			m_strPostData = "";
		}
		private void BuildData() {
			if (m_mapExtractData == null) {
				return;
			}
			String strData = Util.FormatNetworkData(m_mapExtractData);
			if (IsGet()) {
				m_strBuildedUrl = Util.AddData2Url(m_strUrl, strData);
			}
			else {
				m_strPostData = strData;
			}
		}
		//data menber
		private String m_strRequestMethod = "";
		private String m_strUrl = "";
		private String m_strBuildedUrl = "";
		private String m_strCookie = "";
		private String m_strPostData = "";
		private Map<String, String> m_mapExtractData;
		private boolean m_bBuilded = false;
	}
	public void InitPostRequestInfo(String strUrl, String strCookie, Map<String, String> mapData) {
		m_requestInfo = new RequestInfo(strUrl, strCookie, mapData, true);
	}
	public void InitGetRequestInfo(String strUrl, String strCookie, Map<String, String> mapData) {
		m_requestInfo = new RequestInfo(strUrl, strCookie, mapData, false);		
	}
	public void InitGetRequestInfo(String strUrl, String strCookie) {
		m_requestInfo = new RequestInfo(strUrl, strCookie, null, false);		
	}

	public int GetMaxRetryTimes() {
		return m_nMaxRetryTimes;
	}
	public boolean IsRaw() {
		return m_bRaw;
	}
	abstract protected void InitRequestInfo();
	
	
	protected boolean ParseResponse(JSONObject rootObject) {
		return true;
	}
	
	public Requester() {
		InitRequestInfo();
	}
	public void Initialize() {
	}

	public boolean IsPost() {
		return m_requestInfo.IsPost();
	}
	private boolean IsGet() {
		return m_requestInfo.IsGet();
	}
	public void AddData(Map<String, String> mapData) {
		m_requestInfo.AddData(mapData);
	}
	public void AddData(String strName, String strValue) {
		m_requestInfo.AddData(strName, strValue);
	}
	public String GetUrl() {
		return m_requestInfo.GetUrl();
	}
	public String GetRequestMethod() {
		return m_requestInfo.GetRequestMethod();
	}
	public String GetPostData() {
		return m_requestInfo.GetPostData();
	}
	public void ResetBuildedData() {
		m_requestInfo.ResetBuildedData();
	}
	public String GetCookie(){
		return m_requestInfo.GetCookie();
	}
	public boolean HookRequestComplete(InputStream inputStream) {
		return false;
	}
	public boolean Parse(String strResponse) {
		if (strResponse == null) {
			m_nResult = RequestManager.sg_nNetworkdError;
			return false;
		}
		JSONObject rootObject = null;
		try {
			rootObject = new JSONObject(strResponse);
			m_nResult = Util.ReadJsonInt(rootObject, "res");
			m_strMsg = Util.ReadJsonString(rootObject, "msg");
		} catch (JSONException e) {
			return false;
		}
		
		if (!ParseResponse(rootObject)) {
			m_nResult = RequestManager.sg_nNetworkdError;
			return false;
		}
		return true;
	}
	
	public void SetRequestType(RequesterFactory.RequestType enumRequestType) {
		m_enumRequestType = enumRequestType;
	}
	public RequesterFactory.RequestType GetRquestType() {
		return m_enumRequestType;
	}
	public int GetResult() {
		return m_nResult;
	}
	public String GetMsg() {
		return m_strMsg;
	}
	public int GetId() {
		return m_nReqId;
	}
	public void SetId(int nReqId) {
		m_nReqId = nReqId;
	}
	
	protected int m_nMaxRetryTimes = 0;
	protected boolean m_bRaw = false;
	protected int m_nReqId = 0;
	protected int m_nResult = 0;
	protected String m_strMsg;
	protected RequesterFactory.RequestType m_enumRequestType;
	protected RequestInfo m_requestInfo = null;
}
