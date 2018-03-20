package com.kindergarten.kindergarten.cameraplay;

import android.app.Activity;
import android.util.Log;

import com.videogo.openapi.EZOpenSDK;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * EzvizPlugin
 */
public class EzvizPlugin implements MethodCallHandler {
    private final PluginRegistry.Registrar registrar;
    private static String TAG = "ezviz";
    private static final String CHANNEL = "ezviz";

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        channel.setMethodCallHandler(new EzvizPlugin(registrar));
    }

    private EzvizPlugin(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        Log.d(TAG, call.arguments.toString());
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
//            call.argument("");

        } else if (call.method.equals("startCameraPlayPage")) {
            Activity activity = registrar.activity();
            if (activity != null){
                EZOpenSDK.getInstance().setAccessToken((String) call.argument("ezToken"));
                PlayActivity.startPlayActivity(activity, (String) call.argument("deviceSerial"),(String) call.argument("verifyCode"),(String) call.argument("cameraNo"));
            }
        } else {
            result.notImplemented();
        }
    }
}
