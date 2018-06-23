package com.kindergarten.kindergarten;

import com.videogo.openapi.EZOpenSDK;
import android.content.Context;
import io.flutter.app.FlutterApplication;
import android.support.multidex.MultiDex;
/**
 * Created by zhangruiyu on 2018/3/20.
 */

public class KGApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        initEzOpen();

    }
    private  void initEzOpen() {
        EZOpenSDK.showSDKLog(true);
        EZOpenSDK.enableP2P(false);
        EZOpenSDK.initLib(this, "b109fdee59b14b19b48927f627814c58", "");
    }
     public void  attachBaseContext(Context base) {
        MultiDex.install(base);
        super.attachBaseContext(base);
    }
}
