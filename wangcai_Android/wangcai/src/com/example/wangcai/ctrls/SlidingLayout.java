package com.example.wangcai.ctrls;


import android.content.Context;
import android.os.AsyncTask;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.VelocityTracker;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.WindowManager;
import android.widget.RelativeLayout;


public class SlidingLayout extends RelativeLayout implements android.view.View.OnTouchListener {  
    public static final int SNAP_VELOCITY = 200;  		//������ʾ��������಼��ʱ����ָ������Ҫ�ﵽ���ٶȡ� 
  
    public static final int DO_NOTHING = 0;		//����״̬��һ�֣���ʾδ�����κλ����� 
  
    public static final int SHOW_LEFT_VIEW = 1;		//����״̬��һ�֣���ʾ���ڻ������˵��� 
    public static final int SHOW_RIGHT_VIEW = 2;	 //����״̬��һ�֣���ʾ���ڻ����Ҳ�˵���  
    public static final int HIDE_LEFT_VIEW = 3;	//����״̬��һ�֣���ʾ�����������˵���      
    public static final int HIDE_RIGHT_VIEW = 4;		//����״̬��һ�֣���ʾ���������Ҳ�˵��� 
  
    private int m_slideState;		//��¼��ǰ�Ļ���״̬
    
    private int m_screenWidth;  //��Ļ���ֵ��
  
    private int m_touchSlop;  //�ڱ��ж�Ϊ����֮ǰ�û���ָ�����ƶ������ֵ��
  
    private float m_xDown;  //��¼��ָ����ʱ�ĺ����ꡣ
    private float m_yDown;  //��¼��ָ����ʱ�������ꡣ
    private float m_xMove;  //��¼��ָ�ƶ�ʱ�ĺ����ꡣ
    private float m_yMove;  //��¼��ָ�ƶ�ʱ�������ꡣ
  
    private float m_xUp;  //��¼�ֻ�̧��ʱ�ĺ����ꡣ
    
    private boolean m_isLeftViewVisible;  //���˵���ǰ����ʾ�������ء�ֻ����ȫ��ʾ������ʱ�Ż���Ĵ�ֵ�����������д�ֵ��Ч��
    private boolean m_isRightViewVisible;  //�Ҳ�˵���ǰ����ʾ�������ء�ֻ����ȫ��ʾ������ʱ�Ż���Ĵ�ֵ�����������д�ֵ��Ч��
   
    private boolean m_isSliding;  //�Ƿ����ڻ�����
  
    private View m_leftViewLayout;  //���˵����ֶ���
    private View m_rightViewLayout;  //�Ҳ�˵����ֶ���
  
    private View m_contentLayout;  //���ݲ��ֶ���
   
    private View m_mBindView;  //���ڼ��������¼���View��
    
    private MarginLayoutParams m_leftViewLayoutParams;  //���˵����ֵĲ�����
    private MarginLayoutParams m_rightViewLayoutParams;  //�Ҳ�˵����ֵĲ�����
    private RelativeLayout.LayoutParams m_contentLayoutParams;  //���ݲ��ֵĲ�����

    private VelocityTracker m_mVelocityTracker;  //���ڼ�����ָ�������ٶȡ�
  
    
    //��дBidirSlidingLayout�Ĺ��캯�������л�ȡ����Ļ�Ŀ�Ⱥ�touchSlop��ֵ�� 
      
    public SlidingLayout(Context context, AttributeSet attrs) {  
        super(context, attrs);
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);  
        m_screenWidth = wm.getDefaultDisplay().getWidth();  
        m_touchSlop = ViewConfiguration.get(context).getScaledTouchSlop();  
    }  
  
    
    //�󶨼��������¼���View�� 
    public void setScrollEvent(View bindView) {  
        m_mBindView = bindView;  
        m_mBindView.setOnTouchListener(this);  
    }  
      
    //��������������˵����棬�����ٶ��趨Ϊ-30. 
    public void scrollToLeftView() {  
        new LeftViewScrollTask().execute(-30);  
    }  
  
    
    //������������Ҳ�˵����棬�����ٶ��趨Ϊ-30. 
    public void scrollToRightView() {
    	if (m_rightViewLayout != null && m_rightViewLayoutParams != null) {
    		new RightViewScrollTask().execute(-30);  
    	}
    }  
    
    //����������˵����������ݽ��棬�����ٶ��趨Ϊ30. 
    public void scrollToContentFromLeftView() {  
    		new LeftViewScrollTask().execute(30);
    }  
  
    
    //��������Ҳ�˵����������ݽ��棬�����ٶ��趨Ϊ30. 
    public void scrollToContentFromRightView() {  
    	if (m_rightViewLayout != null && m_rightViewLayoutParams != null) {
    		new RightViewScrollTask().execute(30);
    	}
    }  
  
    
    //���˵��Ƿ���ȫ��ʾ���������������д�ֵ��Ч�� 
    //@return ���˵���ȫ��ʾ����true�����򷵻�false��
    public boolean isLeftLayoutVisible() {  
        return m_isLeftViewVisible;  
    }  
  
    
    //�Ҳ�˵��Ƿ���ȫ��ʾ���������������д�ֵ��Ч�� 
    //@return �Ҳ�˵���ȫ��ʾ����true�����򷵻�false�� 
    public boolean isRightLayoutVisible() {  
        return m_isRightViewVisible;  
    }  
    
    //��onLayout�������趨���˵����Ҳ�˵����Լ����ݲ��ֵĲ����� 
    @Override  
    protected void onLayout(boolean changed, int l, int t, int r, int b) {  
        super.onLayout(changed, l, t, r, b);  
        if (changed) {  
            // ��ȡ���˵����ֶ���  
            m_leftViewLayout = getChildAt(0);  
            m_leftViewLayoutParams = (MarginLayoutParams) m_leftViewLayout.getLayoutParams();  
            
			// ��ȡ���ݲ��ֶ���  
            m_contentLayout = getChildAt(1);  
            m_contentLayoutParams = (RelativeLayout.LayoutParams) m_contentLayout.getLayoutParams();  
            m_contentLayoutParams.width = m_screenWidth;  
            m_contentLayout.setLayoutParams(m_contentLayoutParams);  

            // ��ȡ�Ҳ�˵����ֶ���  
            m_rightViewLayout = getChildAt(2);
			if (m_rightViewLayout != null) {
				m_rightViewLayoutParams = (MarginLayoutParams) m_rightViewLayout.getLayoutParams();  
			}
        }
    }  
  
    public boolean onTouch(View v, MotionEvent event) {  
        createVelocityTracker(event);  
        int nAction = event.getAction();
        switch (nAction) {  
        case MotionEvent.ACTION_DOWN:  
            // ��ָ����ʱ����¼����ʱ������  
            m_xDown = event.getRawX();  
            m_yDown = event.getRawY();  
            // ������״̬��ʼ��ΪDO_NOTHING  
            m_slideState = DO_NOTHING;  
            break;  
        case MotionEvent.ACTION_MOVE:  
            m_xMove = event.getRawX();  
            m_yMove = event.getRawY();  
            // ��ָ�ƶ�ʱ���ԱȰ���ʱ�����꣬������ƶ��ľ��롣  
            int moveDistanceX = (int) (m_xMove - m_xDown);  
            int moveDistanceY = (int) (m_yMove - m_yDown);  
            // ��鵱ǰ�Ļ���״̬  
            checkSlideState(moveDistanceX, moveDistanceY);  
            // ���ݵ�ǰ����״̬�������ƫ�����ݲ���  
            switch (m_slideState) {  
            case SHOW_LEFT_VIEW:  
                m_contentLayoutParams.rightMargin = -moveDistanceX;  
                checkLeftViewBorder();  
                m_contentLayout.setLayoutParams(m_contentLayoutParams);  
                break;  
            case HIDE_LEFT_VIEW:  
                m_contentLayoutParams.rightMargin = -m_leftViewLayoutParams.width - moveDistanceX;  
                checkLeftViewBorder();  
                m_contentLayout.setLayoutParams(m_contentLayoutParams);  
            case SHOW_RIGHT_VIEW:  
                m_contentLayoutParams.leftMargin = moveDistanceX;  
                checkRightViewBorder();  
                m_contentLayout.setLayoutParams(m_contentLayoutParams);  
                break;  
            case HIDE_RIGHT_VIEW:  
				if (m_rightViewLayoutParams != null) {
	                m_contentLayoutParams.leftMargin = -m_rightViewLayoutParams.width + moveDistanceX;  
				}
				checkRightViewBorder();  
                m_contentLayout.setLayoutParams(m_contentLayoutParams);  
            default:  
                break;  
            }  
            break;  
        case MotionEvent.ACTION_UP:  
            m_xUp = event.getRawX();  
            int upDistanceX = (int) (m_xUp - m_xDown);  
            if (m_isSliding) {  
                // ��ָ̧��ʱ�������жϵ�ǰ���Ƶ���ͼ  
                switch (m_slideState) {  
	                case SHOW_LEFT_VIEW:  
	                    if (shouldScrollToLeftView()) {  
	                        scrollToLeftView();  
	                    } else {  
	                        scrollToContentFromLeftView();  
	                    }  
	                    break;  
	                case HIDE_LEFT_VIEW:  
	                    if (shouldScrollToContentFromLeftView()) {  
	                        scrollToContentFromLeftView();  
	                    } else {  
	                        scrollToLeftView();  
	                    }  
	                    break;  
	                case SHOW_RIGHT_VIEW:  
	                    if (shouldScrollToRightView()) {  
	                        scrollToRightView();  
	                    } else {  
	                        scrollToContentFromRightView();  
	                    }  
	                    break;  
	                case HIDE_RIGHT_VIEW:  
	                    if (shouldScrollToContentFromRightView()) {  
	                        scrollToContentFromRightView();  
	                    } else {  
	                        scrollToRightView();  
	                    }  
	                    break;  
	                default:  
	                    break;  
                }  
            } else if (upDistanceX < m_touchSlop && m_isLeftViewVisible) {  
                // �����˵���ʾʱ������û����һ�����ݲ��֣���ֱ�ӹ��������ݽ���  
                scrollToContentFromLeftView();  
            } else if (upDistanceX < m_touchSlop && m_isRightViewVisible) {  
                // ���Ҳ�˵���ʾʱ������û����һ�����ݲ��֣���ֱ�ӹ��������ݽ���  
                scrollToContentFromRightView();  
            }  
            recycleVelocityTracker();  
            break;  
        }  
        /*
        if (v.isEnabled()) {  
            if (m_isSliding) {  
                // ���ڻ���ʱ�ÿؼ��ò�������  
                unFocusBindView();  
                return true;  
            }  
            if (m_isLeftViewVisible || m_isRightViewVisible) {  
                // �������Ҳ಼����ʾʱ�����󶨿ؼ����¼����ε�  
                return true;  
            }  
            return false;  
        }  
		*/       
        return true;  
    }  
  
    
    //������ָ�ƶ��ľ��룬�жϵ�ǰ�û��Ļ�����ͼ��Ȼ���slideState��ֵ����Ӧ�Ļ���״ֵ̬�� 
    private void checkSlideState(int moveDistanceX, int moveDistanceY) {  
        if (m_isLeftViewVisible) {  
            if (!m_isSliding && Math.abs(moveDistanceX) >= m_touchSlop && moveDistanceX < 0) {  
                m_isSliding = true;  
                m_slideState = HIDE_LEFT_VIEW;  
            }  
        } else if (m_isRightViewVisible) {  
            if (!m_isSliding && Math.abs(moveDistanceX) >= m_touchSlop && moveDistanceX > 0) {  
                m_isSliding = true;  
                m_slideState = HIDE_RIGHT_VIEW;  
            }  
        } else {  
            if (!m_isSliding && Math.abs(moveDistanceX) >= m_touchSlop && 
            		moveDistanceX > 0 && 
            		Math.abs(moveDistanceY) < m_touchSlop) {  
                m_isSliding = true;  
                m_slideState = SHOW_LEFT_VIEW;  
                m_contentLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT, 0);  
                m_contentLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);  
                m_contentLayout.setLayoutParams(m_contentLayoutParams);  
                // ����û���Ҫ�������˵��������˵���ʾ���Ҳ�˵�����  
                m_leftViewLayout.setVisibility(View.VISIBLE);  
				if (m_rightViewLayout != null) {
			       m_rightViewLayout.setVisibility(View.GONE);  
				}
            } else if (!m_isSliding && Math.abs(moveDistanceX) >= m_touchSlop && 
            		moveDistanceX < 0 && 
            		Math.abs(moveDistanceY) < m_touchSlop) {  
                m_isSliding = true;  
                m_slideState = SHOW_RIGHT_VIEW;  
                m_contentLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT, 0);  
                m_contentLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);  
                m_contentLayout.setLayoutParams(m_contentLayoutParams);  
                // ����û���Ҫ�����Ҳ�˵������Ҳ�˵���ʾ�����˵�����
				if (m_rightViewLayout != null) {
	                m_rightViewLayout.setVisibility(View.VISIBLE);
				}
				m_leftViewLayout.setVisibility(View.GONE);  
            }  
        }  
    }  
  
    
    //�ڻ��������м�����˵��ı߽�ֵ����ֹ�󶨲��ֻ�����Ļ�� 
      
    private void checkLeftViewBorder() {  
        if (m_contentLayoutParams.rightMargin > 0) {  
            m_contentLayoutParams.rightMargin = 0;  
        } else if (m_contentLayoutParams.rightMargin < -m_leftViewLayoutParams.width) {  
            m_contentLayoutParams.rightMargin = -m_leftViewLayoutParams.width;  
        }  
    }  
  
    
    //�ڻ��������м���Ҳ�˵��ı߽�ֵ����ֹ�󶨲��ֻ�����Ļ�� 
      
    private void checkRightViewBorder() {  
		int nRightViewRight = 0;
		if (m_rightViewLayoutParams != null) {
			nRightViewRight = m_rightViewLayoutParams.width;
		}
        if (m_contentLayoutParams.leftMargin > 0) {  
            m_contentLayoutParams.leftMargin = 0;  
        } else if (m_contentLayoutParams.leftMargin < -nRightViewRight) {  
            m_contentLayoutParams.leftMargin = -nRightViewRight;  
        }  
    }  
  
    
    //�ж��Ƿ�Ӧ�ù��������˵�չʾ�����������ָ�ƶ�����������˵���ȵ�1/2��������ָ�ƶ��ٶȴ���SNAP_VELOCITY�� 
    //����ΪӦ�ù��������˵�չʾ������
    private boolean shouldScrollToLeftView() {  
        return m_xUp - m_xDown > m_leftViewLayoutParams.width / 2 || getScrollVelocity() > SNAP_VELOCITY;  
    }  
  
    //�ж��Ƿ�Ӧ�ù������Ҳ�˵�չʾ�����������ָ�ƶ���������Ҳ�˵���ȵ�1/2��������ָ�ƶ��ٶȴ���SNAP_VELOCITY�� 
    //����ΪӦ�ù������Ҳ�˵�չʾ������ 
    private boolean shouldScrollToRightView() {
		 if (m_rightViewLayoutParams == null) {
			 return false;
		 }
        return m_xDown - m_xUp > m_rightViewLayoutParams.width / 2 || getScrollVelocity() > SNAP_VELOCITY;  
    }  
  
    
    //�ж��Ƿ�Ӧ�ô����˵����������ݲ��֣������ָ�ƶ�����������˵���ȵ�1/2��������ָ�ƶ��ٶȴ���SNAP_VELOCITY�� 
    //����ΪӦ�ô����˵����������ݲ��֡� 
    private boolean shouldScrollToContentFromLeftView() {  
        return m_xDown - m_xUp > m_leftViewLayoutParams.width / 2 || getScrollVelocity() > SNAP_VELOCITY;  
    }  
  
    
    //�ж��Ƿ�Ӧ�ô��Ҳ�˵����������ݲ��֣������ָ�ƶ���������Ҳ�˵���ȵ�1/2��������ָ�ƶ��ٶȴ���SNAP_VELOCITY�� 
    //����ΪӦ�ô��Ҳ�˵����������ݲ��֡� 
    private boolean shouldScrollToContentFromRightView() {  
		 if (m_rightViewLayoutParams == null) {
			 return false;
		 }
        return m_xUp - m_xDown > m_rightViewLayoutParams.width / 2 || getScrollVelocity() > SNAP_VELOCITY;  
    }  
   
    //����VelocityTracker���󣬲��������¼����뵽VelocityTracker���С�
    private void createVelocityTracker(MotionEvent event) {  
        if (m_mVelocityTracker == null) {  
            m_mVelocityTracker = VelocityTracker.obtain();  
        }  
        m_mVelocityTracker.addMovement(event);  
    }  
  
    //��ȡ��ָ�ڰ󶨲����ϵĻ����ٶȡ� 
    private int getScrollVelocity() {  
        m_mVelocityTracker.computeCurrentVelocity(1000);  
        int velocity = (int) m_mVelocityTracker.getXVelocity();  
        return Math.abs(velocity);  
    }  
   
    //����VelocityTracker����
    private void recycleVelocityTracker() {  
        m_mVelocityTracker.recycle();  
        m_mVelocityTracker = null;  
    }  
  
    
    //ʹ�ÿ��Ի�ý���Ŀؼ��ڻ�����ʱ��ʧȥ���㡣
    private void unFocusBindView() {  
        if (m_mBindView != null) {  
            m_mBindView.setPressed(false);  
            m_mBindView.setFocusable(false);  
            m_mBindView.setFocusableInTouchMode(false);  
        }  
    }  
  
    class LeftViewScrollTask extends AsyncTask<Integer, Integer, Integer> {
        @Override  
        protected Integer doInBackground(Integer... speed) {  
            int rightMargin = m_contentLayoutParams.rightMargin;  
            int nLayoutWidth = m_leftViewLayoutParams.width;
            // ���ݴ�����ٶ����������棬����������߽�ֵʱ������ѭ����  
            while (true) {  
                rightMargin = rightMargin + speed[0];
                if (rightMargin < -nLayoutWidth) {  
                    rightMargin = -nLayoutWidth;  
                    break;  
                }  
                if (rightMargin > 0) {  
                    rightMargin = 0;  
                    break;  
                }  
                Log.i("doInBackground",  String.format("rightMargin(%d)", rightMargin));
                publishProgress(rightMargin);  
                sleep(15);  
            }  
            if (speed[0] > 0) {  
                m_isLeftViewVisible = false;  
            } else {  
                m_isLeftViewVisible = true;  
            }  
            m_isSliding = false;  
            Log.i("doInBackground",  String.format("TaskEnd: rightMargin(%d)", rightMargin));
            return rightMargin;  
        }  
  
        @Override  
        protected void onProgressUpdate(Integer... rightMargin) {  
            m_contentLayoutParams.rightMargin = rightMargin[0];  
            Log.i("onProgressUpdate",  String.format("TaskEnd: rightMargin(%d)", rightMargin[0]));
            m_contentLayout.setLayoutParams(m_contentLayoutParams);  
            unFocusBindView();  
        }  
  
        @Override  
        protected void onPostExecute(Integer rightMargin) {  
            m_contentLayoutParams.rightMargin = rightMargin;  
            Log.i("onPostExecute",  String.format("TaskEnd: rightMargin(%d)", rightMargin));
            m_contentLayout.setLayoutParams(m_contentLayoutParams);  
        }  
    }  
  
    class RightViewScrollTask extends AsyncTask<Integer, Integer, Integer> {  
  
        @Override  
        protected Integer doInBackground(Integer... speed) {  
            int leftMargin = m_contentLayoutParams.leftMargin;  
            // ���ݴ�����ٶ����������棬����������߽�ֵʱ������ѭ����  
            while (true) {  
                leftMargin = leftMargin + speed[0];  
                if (leftMargin < -m_rightViewLayoutParams.width) {  
                    leftMargin = -m_rightViewLayoutParams.width;  
                    break;  
                }  
                if (leftMargin > 0) {  
                    leftMargin = 0;  
                    break;  
                }  
                publishProgress(leftMargin);    
                sleep(15);  
            }  
            if (speed[0] > 0) {  
                m_isRightViewVisible = false;  
            } else {  
                m_isRightViewVisible = true;  
            }  
            m_isSliding = false;  
            return leftMargin;  
        }  
  
        @Override  
        protected void onProgressUpdate(Integer... leftMargin) {  
            m_contentLayoutParams.leftMargin = leftMargin[0];  
            m_contentLayout.setLayoutParams(m_contentLayoutParams);  
            unFocusBindView();  
        }  
  
        @Override  
        protected void onPostExecute(Integer leftMargin) {  
            m_contentLayoutParams.leftMargin = leftMargin;  
            m_contentLayout.setLayoutParams(m_contentLayoutParams);  
        }  
    }  
 
    private void sleep(long millis) {  
        try {  
            Thread.sleep(millis);  
        } catch (InterruptedException e) {  
            e.printStackTrace();  
        }  
    }  
}  