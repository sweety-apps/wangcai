package com.coolstore.request;

import java.io.InputStream;
import java.util.Map;
import java.util.Map.Entry;

import org.json.JSONException;
import org.json.JSONObject;

import com.coolstore.common.Util;


public class Requester {

	public static class RequestInfo {
		RequestInfo(String strUrl, String strCookie) {
			m_strUrl = strUrl;
			m_strCookie = strCookie;
			m_strRequestMethod = RequestManager.g_strGet;
		}
		RequestInfo(String strUrl, String strCookie, Map<String, String> mapData, boolean bPost) {
			m_strUrl = strUrl;
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
			String strData = Util.FormatNetworkData(mapData);
			if (m_strRequestMethod.equals(RequestManager.g_strGet)) {
				m_strUrl = Util.AddData2Url(m_strUrl, strData);
			}
			else {
				m_strPostData = Util.CombineNetworkData(m_strPostData, strData);
			}
		}
		//data menber
		String m_strRequestMethod = "";
		String m_strUrl = "";
		String m_strCookie = "";
		String m_strPostData = "";
	}
	public static RequestInfo NewPostRequestInfo(String strUrl, String strCookie, Map<String, String> mapData) {
		return new RequestInfo(strUrl, strCookie, mapData, true);
	}
	public static RequestInfo NewGetRequestInfo(String strUrl, String strCookie, Map<String, String> mapData) {
		return new RequestInfo(strUrl, strCookie, mapData, false);		
	}
	public static RequestInfo NewGetRequestInfo(String strUrl, String strCookie) {
		return new RequestInfo(strUrl, strCookie, null, false);		
	}


	public boolean IsRaw() {
		return m_bRaw;
	}
	public RequestInfo GetRequestInfo() {
		return m_requestInfo;
	}
	protected boolean ParseResponse(JSONObject rootObject) {
		return true;
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
	protected boolean m_bRaw = false;
	protected int m_nReqId = 0;
	protected int m_nResult = 0;
	protected String m_strMsg;
	protected RequesterFactory.RequestType m_enumRequestType;
	protected RequestInfo m_requestInfo = null;
}
