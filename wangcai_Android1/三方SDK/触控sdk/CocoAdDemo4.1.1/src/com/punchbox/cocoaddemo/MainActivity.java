
package com.punchbox.cocoaddemo;


import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.View;

public class MainActivity extends Activity {
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
    }

    public void bannerCode(View v){
        Intent intent = new Intent();
        intent.setClass(getApplicationContext(), BannerCodeActivity.class);
        startActivity(intent);
    }

    public void bannerXML(View v){
        Intent intent = new Intent();
        intent.setClass(getApplicationContext(), BannerXMLActivity.class);
        startActivity(intent);
    }
    
    public void interstitialAd(View v){
        Intent intent = new Intent();
        intent.setClass(getApplicationContext(), InterstitialAdActivity.class);
        startActivity(intent);
    }
    
    public void moregame(View v){
        Intent intent = new Intent();
        intent.setClass(getApplicationContext(), MoreGameActivity.class);
        startActivity(intent);
    }
    
    public void moregameButton(View v){
        Intent intent = new Intent();
        intent.setClass(getApplicationContext(), MoreGameButtonActivity.class);
        startActivity(intent);
    }
    
    public void bannerwithmoregame(View v){
        Intent intent = new Intent();
        intent.setClass(getApplicationContext(), BannerWithMoreGameActivity.class);
        startActivity(intent);
    }
    
    public void offerwall(View v){
        Intent intent = new Intent();
        intent.setClass(getApplicationContext(), OfferWallActivity.class);
        startActivity(intent);
    }
    
    public void offerwallButton(View v){
        Intent intent = new Intent();
        intent.setClass(getApplicationContext(), OfferWallButtonActivity.class);
        startActivity(intent);
    }
}
