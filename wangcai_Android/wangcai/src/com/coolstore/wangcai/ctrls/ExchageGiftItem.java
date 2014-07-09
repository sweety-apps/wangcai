package com.coolstore.wangcai.ctrls;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.lang.ref.WeakReference;

import com.coolstore.request.RequestManager;
import com.coolstore.request.Requester;
import com.coolstore.request.RequesterFactory;
import com.coolstore.request.Requesters.Request_DownloadFile;
import com.coolstore.wangcai.R;
import com.coolstore.common.Util;
import com.coolstore.common.ViewHelper;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;

public class ExchageGiftItem extends ItemBase implements OnClickListener, RequestManager.IRequestManagerCallback{
	public interface ExchageItemEvent{
		void OnDoExchage(String strItemName);
	}
	public ExchageGiftItem(String strItemName) {
		super(strItemName);
	}

	public void SetItemEventLinstener(ExchageItemEvent eventLinstener) {
		m_itemEventLinstener = new WeakReference<ExchageItemEvent>(eventLinstener);
	}

	public ViewGroup Create(Context context, String strIconUrl, String strName, int nPrice, int nRemainCount) {
		m_context = context;
		m_strIconUrl = strIconUrl;
		m_strSaveName = Util.GetMd5(strIconUrl) + ".png";
		super.CreateView(context, R.layout.ctrl_exchage_gift_item);
		InitView(context, strName, nPrice, nRemainCount);
		
		if (!SetExchangeLogo()) {
			Request_DownloadFile req = (Request_DownloadFile)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_DownloadFile);
			req.SetContext(context);
			req.SetUrl(m_strIconUrl);
			req.SetSaveName(m_strSaveName);
			RequestManager.GetInstance().SendRequest(req, false, this);
		}
		return m_viewRoot;
	}

	public void onClick(View v) {
		int nId = v.getId();
		if (nId == R.id.recharge_button) {
			if (m_itemEventLinstener != null) {
				ExchageItemEvent eventListener = m_itemEventLinstener.get();
				if (eventListener != null) {
					eventListener.OnDoExchage(m_strItemName);
				}
			}
		}
	}
		
	private void InitView(Context context, String strName, int nPrice, int nRemainCount) {
		//ViewHelper.SetIconId(m_viewRoot, R.id.type_icon, nIconId);

		ViewHelper.SetTextStr(m_viewRoot, R.id.type_name, strName);

		String strText = String.format(context.getString(R.string.gift_price_count), Util.FormatMoney(nPrice), nRemainCount);
		ViewHelper.SetTextStr(m_viewRoot, R.id.extract_price, strText);

		m_viewRoot.findViewById(R.id.recharge_button).setOnClickListener(this);
	}
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (req instanceof Request_DownloadFile) {
			int nResult = req.GetResult();
			if (nResult == 0) {				
				//InputStream stream = downloadReq.GetInputStream();
				SetExchangeLogo();
			}
		}
	}

	private boolean SetExchangeLogo() {
		FileInputStream fstream;
		try {
			fstream = m_context.openFileInput(m_strSaveName);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		Bitmap bitmap = BitmapFactory.decodeStream(fstream);
		if (bitmap != null) {
			ImageView imageView = (ImageView)m_viewRoot.findViewById(R.id.type_icon);
			imageView.setImageBitmap(bitmap);
		}
		return true;
	}

	private Context m_context;
	private String m_strSaveName;
	private WeakReference<ExchageItemEvent> m_itemEventLinstener = null;
	private String m_strIconUrl = null;
}


