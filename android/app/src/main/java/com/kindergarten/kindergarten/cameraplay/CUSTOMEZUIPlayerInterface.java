package com.kindergarten.kindergarten.cameraplay;

import android.view.View;

import com.ezvizuikit.open.EZUIPlayer;

import java.util.Calendar;
import java.util.List;

/**
 * Created by zhangruiyu on 2018/1/25.
 */

public interface CUSTOMEZUIPlayerInterface {
    void setCallBack(EZUIPlayer.EZUIPlayerCallBack var1);

    void setUrl(String deviceSerial, String verifyCode, int cameraNo);

    int getStatus();

    void startPlay();

    void seekPlayback(Calendar var1);

    Calendar getOSDTime();

    void stopPlay();

    void pausePlay();

    void resumePlay();

    void releasePlayer();

    List getPlayList();

    void setSurfaceSize(int var1, int var2);

    void setLoadingView(View var1);
}
