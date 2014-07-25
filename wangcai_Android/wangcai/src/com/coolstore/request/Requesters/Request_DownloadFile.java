package com.coolstore.request.Requesters;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;



import android.content.Context;

import com.coolstore.request.Requester;

public class Request_DownloadFile extends Requester{

	public Request_DownloadFile() {
		m_bRaw = true;
		m_nMaxRetryTimes = 2;
	}
	
    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
    	super.InitGetRequestInfo(m_strUrl, "", mapRequestInfo);
	}

    @Override
	public boolean HookRequestComplete(InputStream inputStream) {
    	try {
    		inputStream.mark(0x7FFFFFFF);
    		m_inputStream = inputStream;
			FileOutputStream fstream = m_context.openFileOutput(m_strSaveName, Context.MODE_PRIVATE);

    		final int nBufferSize = 4096;
    		byte[] bufData = new byte[nBufferSize];
			while (true) {
				int nReadCount = inputStream.read(bufData, 0, nBufferSize);
				if (nReadCount <= 0) {
					break;
				}
				fstream.write(bufData, 0, nReadCount);
				
			}
			fstream.close();
			inputStream.reset();
		} catch (FileNotFoundException e) {
		}
    	catch (IOException e) {
    	}
		return true;
	}
    public void SetUrl(String strUrl) { 
    	m_strUrl = strUrl;
    }
    public void SetSaveName(String strSaveName) {
    	m_strSaveName = strSaveName;
    }
    public void SetContext(Context context) {
    	m_context = context;
    }
    public InputStream GetInputStream() {
    	return m_inputStream;
    }
    
    private Context m_context;
    private String m_strUrl;
    private String m_strSaveName;
    private InputStream m_inputStream = null;
}

