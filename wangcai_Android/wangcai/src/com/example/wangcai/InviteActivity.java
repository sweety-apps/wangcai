package com.example.wangcai;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

public class InviteActivity extends Activity implements TitleCtrl.TitleEvent {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_invite);

        AttachEvents();
        InitView();
     }

    private void InitView() {
    	//��ά��
    	ImageView qrcodeView = (ImageView)this.findViewById(R.id.qrcode);
    	
    	//������
    	TextView inviteCodeView = (TextView)this.findViewById(R.id.invite_code);
    	inviteCodeView.setText("xwesdf");
    	
    	//��������
    	TextView invateUrlView = (TextView)this.findViewById(R.id.invite_url);
    	inviteCodeView.setText("http://invite.getwangcai.com/s34sfsdf");
    }
    
    private void AttachEvents() {
    	TitleCtrl titleCtrl = (TitleCtrl)this.findViewById(R.id.title);
    	titleCtrl.SetEventLinstener(this);
    	
    	final View invitePanel = this.findViewById(R.id.invite_panel);
    	final View inviteCodePanel = this.findViewById(R.id.invite_code_panel);
    	
    	//������Ѱ�ť
    	((Button)this.findViewById(R.id.invite_other)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	invitePanel.setVisibility(View.VISIBLE);
            	inviteCodePanel.setVisibility(View.GONE);
            }
        });

    	//˭�����Ұ�ť
    	((Button)this.findViewById(R.id.the_one_invite_me)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	invitePanel.setVisibility(View.GONE);
            	inviteCodePanel.setVisibility(View.VISIBLE);
            }
        });

    	//���Ƶ������尴ť
    	((Button)this.findViewById(R.id.copy_url_button)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	invitePanel.setVisibility(View.GONE);
            	inviteCodePanel.setVisibility(View.VISIBLE);
            }
        });
    	
    	//����׬�����ť
    	((Button)this.findViewById(R.id.share_button)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	invitePanel.setVisibility(View.GONE);
            	inviteCodePanel.setVisibility(View.VISIBLE);
            }
        });
    	
    	//��ȡ׬xԪ��ť
    	((Button)this.findViewById(R.id.get_reward_button)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	invitePanel.setVisibility(View.GONE);
            	inviteCodePanel.setVisibility(View.VISIBLE);
            }
        });
    }
    
    
	public void OnRequestClose() {
		finish();
	}

    @Override 
    protected void onDestroy() {
    	TitleCtrl titleCtrl = (TitleCtrl)this.findViewById(R.id.title);
    	titleCtrl.SetEventLinstener(null);    	
    }
}
