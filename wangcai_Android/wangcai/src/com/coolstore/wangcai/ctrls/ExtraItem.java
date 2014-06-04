package com.coolstore.wangcai.ctrls;

import java.lang.ref.WeakReference;

import com.coolstore.wangcai.R;
import com.coolstore.common.ViewHelper;

import android.content.Context;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;

public class ExtraItem extends ItemBase implements OnClickListener
{
	public interface ExtractItemEvent{
		void OnDoExtract(String strItemName);
	}
	public ExtraItem(String strItemName) {
		super(strItemName);
	}

	public void SetItemEventLinstener(ExtractItemEvent eventLinstener) {
		m_itemEventLinstener = new WeakReference<ExtractItemEvent>(eventLinstener);
	}

	public ViewGroup Create(Context context, int nIconId, String strName) {
		super.CreateView(context, R.layout.ctrl_extract_item);
		InitView(nIconId, strName);
		return m_viewRoot;
	}

	
	public void onClick(View v) {
		int nId = v.getId();
		if (nId == R.id.recharge_button) {
			if (m_itemEventLinstener != null) {
				ExtractItemEvent eventListener = m_itemEventLinstener.get();
				if (eventListener != null) {
					eventListener.OnDoExtract(m_strItemName);
				}
			}
		}
	}
	
	
	private void InitView(int nIconId, String strName) {
		ViewHelper.SetIconId(m_viewRoot, R.id.type_icon, nIconId);
		ViewHelper.SetTextStr(m_viewRoot, R.id.type_name, strName);

		m_viewRoot.findViewById(R.id.recharge_button).setOnClickListener(this);
	}

	WeakReference<ExtractItemEvent> m_itemEventLinstener = null;
}


