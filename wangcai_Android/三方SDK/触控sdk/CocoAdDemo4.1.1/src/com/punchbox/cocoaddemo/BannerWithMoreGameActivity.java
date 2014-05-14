package com.punchbox.cocoaddemo;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.punchbox.ads.*;
import com.punchbox.exception.PBException;
import com.punchbox.listener.AdListener;

public class BannerWithMoreGameActivity extends Activity implements AdListener {
	private AdView adView;
	private MoreGameAd moregame;
	private String placementID = "abcd";// 替换您的广告位ID，没有就传空

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_banner_with_moregame);

		// 创建 adView, 如果不传入placementID，可以用另一个构造函数AdView(context)
		adView = new AdView(this, placementID);
		// 查找 LinearLayout，假设其已获得
		// 属性 android:id="@+id/mainLayout"
		LinearLayout layout = (LinearLayout) findViewById(R.id.mainLayout);

		// 在其中添加 adView
		layout.addView(adView);

		// 启动一般性请求并在其中加载广告
		adView.loadAd(new AdRequest());

		moregame = new MoreGameAd(this);
		moregame.setAdListener(this);
		moregame.loadAd(new AdRequest());
	}

	@Override
	public void onDestroy() {
		if (adView != null) {
			adView.destroy();
		}
		super.onDestroy();
	}

	public void showMoreGame(View v) {
		try {
			moregame.showFloatView(this, 0.9, "test");
		} catch (PBException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void onReceiveAd() {
		Toast.makeText(getApplicationContext(), "onReceivedAd",
				Toast.LENGTH_SHORT).show();
	}

	@Override
	public void onFailedToReceiveAd(PBException ex) {
		Toast.makeText(getApplicationContext(), "onFailedToReceiveAd",
				Toast.LENGTH_SHORT).show();
	}

	@Override
	public void onPresentScreen() {
		// 在弹出展示时移除banner广告，以免弹出展示时，banner还一直在后面无效请求
		if (adView != null) {
			adView.destroy();
			adView = null;
		}
	}

	@Override
	public void onDismissScreen() {
		// 在弹出移除时，重新请求banner
		LinearLayout layout = (LinearLayout) findViewById(R.id.mainLayout);
		layout.removeAllViews();
		adView = new AdView(this);
		adView.loadAd(new AdRequest());
		layout.addView(adView);
	}
}
