package com.kindergarten.kindergarten;

import android.os.Bundle;

import com.kindergarten.kindergarten.cameraplay.EzvizPlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
//    EZOpenSDK.getInstance().setAccessToken(classroomEntity.data.addition.data)
    EzvizPlugin.registerWith(this.registrarFor("com.kindergarten.kindergarten.cameraplay.EzvizPlugin"));
  }
}
