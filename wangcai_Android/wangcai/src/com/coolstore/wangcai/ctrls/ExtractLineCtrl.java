package com.coolstore.wangcai.ctrls;

import com.coolstore.wangcai.R;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.TextView;

public class ExtractLineCtrl extends FrameLayout {

    public ExtractLineCtrl(Context context) {
        super(context);
        DoInit(context);
     }
    public ExtractLineCtrl(Context context, AttributeSet attrs) {  
        this(context, attrs, 0);
    }  
    public ExtractLineCtrl(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        DoInit(context);  

        TypedArray typeArray = context.getTheme().obtainStyledAttributes(attrs, R.styleable.ExtractLineCtrl, 0, 0);
        int nIndexCount = typeArray.getIndexCount();  
        for (int i = 0; i < nIndexCount; i++) {  
            int attr = typeArray.getIndex(i);  
            switch (attr) {  
	            case R.styleable.ExtractLineCtrl_lebalText:
	            	String strLebalText = typeArray.getString(attr);
	            	TextView titleText = (TextView)this.findViewById(R.id.lebal);
	            	titleText.setText(strLebalText);
	            	break;
	            case R.styleable.ExtractLineCtrl_editHintText:
	            	String strEditHintText = typeArray.getString(attr);
	            	EditText edit = (EditText)this.findViewById(R.id.edit);
	            	edit.setHint(strEditHintText);
	            	break;
            }
        }
    } 
    public EditText GetEditCtrl() {
    	return (EditText)this.findViewById(R.id.edit);
    }
    private void DoInit(Context context) {
        LayoutInflater inflater=(LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        inflater.inflate(R.layout.ctrl_extract_item_line, this);
    }
    public String GetEditText() {
    	EditText edit = (EditText)this.findViewById(R.id.edit);
    	return edit.getText().toString();
    }
    public void SetText(String strLabelText, String strHintText) {
    	TextView titleText = (TextView)this.findViewById(R.id.lebal);
    	titleText.setText(strLabelText);

    	EditText edit = (EditText)this.findViewById(R.id.edit);
    	edit.setHint(strHintText);
    }
}
