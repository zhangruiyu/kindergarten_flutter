package com.kindergarten.kindergarten.cameraplay;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.Point;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.OrientationEventListener;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.ezvizuikit.open.EZUIError;
import com.ezvizuikit.open.EZUIKit;
import com.ezvizuikit.open.EZUIPlayer;
import com.kindergarten.kindergarten.R;

import java.util.Calendar;

public final class PlayActivity extends Activity implements WindowSizeChangeNotifier.OnWindowSizeChangedListener, View.OnClickListener, EZUIPlayer.EZUIPlayerCallBack {
    private CustomEZUIPlayer mEZUIPlayer;
    private Button mBtnPlay;
    private boolean isResumePlay;
    private MyOrientationDetector mOrientationDetector;
    private String deviceSerial;
    private String verifyCode;
    private int cameraNo;
    private static final String TAG = "PlayActivity";
    private static final String DEVICESERIAL = "DEVICESERIAL";
    private static final String VERIFYCODE = "VERIFYCODE";
    private static final String CAMERANO = "CAMERANO";
    public static void startPlayActivity(Context context,String deviceSerial,String verifyCode,String cameraNo){
        Intent intent = new Intent(context, PlayActivity.class);
        intent.putExtra(DEVICESERIAL, deviceSerial);
        intent.putExtra(VERIFYCODE, verifyCode);
        intent.putExtra(CAMERANO, cameraNo);
        context.startActivity(intent);
    }
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_play);
        Intent intent = this.getIntent();
        this.deviceSerial = intent.getStringExtra(DEVICESERIAL);
        this.verifyCode = intent.getStringExtra(VERIFYCODE);
        this.cameraNo = intent.getIntExtra(CAMERANO, 1);
        if (TextUtils.isEmpty((CharSequence) this.deviceSerial)) {
            Toast.makeText((Context) this, (CharSequence) "deviceSerial is null", 1).show();
            this.finish();
        } else {
            this.mOrientationDetector = new PlayActivity.MyOrientationDetector((Context) this);
            new WindowSizeChangeNotifier((Activity) this, (WindowSizeChangeNotifier.OnWindowSizeChangedListener) this);

            mBtnPlay = findViewById(R.id.btn_play);

            //获取EZUIPlayer实例
            mEZUIPlayer = findViewById(R.id.player_ui);
            //设置加载需要显示的view
            mEZUIPlayer.setLoadingView(initProgressBar());
            mBtnPlay.setOnClickListener(this);
            mBtnPlay.setText("停止");
            this.preparePlay();
            this.setSurfaceSize();
            int mHideFlags = Build.VERSION.SDK_INT >= 19 ? 1543 : 1543;
            RelativeLayout activity_play = (RelativeLayout) this.findViewById(R.id.activity_play);
            activity_play.setSystemUiVisibility(mHideFlags);
        }
    }
    /**
     * 创建加载view
     * @return
     */
    private ProgressBar initProgressBar() {
        ProgressBar mProgressBar = new ProgressBar(this);
        RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        lp.addRule(RelativeLayout.CENTER_IN_PARENT);
        mProgressBar.setIndeterminateDrawable(getResources().getDrawable(R.drawable.progress));
        mProgressBar.setLayoutParams(lp);
        return mProgressBar;
    }
    /**
     * 准备播放资源参数
     */
    private void preparePlay() {
        //设置debug模式，输出log信息
        EZUIKit.setDebug(true);
        //设置播放资源参数
        mEZUIPlayer.setCallBack(this);
        mEZUIPlayer.setUrl(deviceSerial, verifyCode, cameraNo);
    }


    protected void onResume() {
        super.onResume();
        mOrientationDetector.enable();
        Log.d(TAG, "onResume");
        //界面stop时，如果在播放，那isResumePlay标志位置为true，resume时恢复播放
        if (isResumePlay) {
            isResumePlay = false;
            mBtnPlay.setText("停止");
            mEZUIPlayer.startPlay();
        }
    }

    protected void onPause() {
        super.onPause();
        mOrientationDetector.disable();
    }


    protected void onStop() {
        super.onStop();
        Log.d(TAG, "onStop + " + mEZUIPlayer.getStatus());
        //界面stop时，如果在播放，那isResumePlay标志位置为true，以便resume时恢复播放
        if (mEZUIPlayer.getStatus() != EZUIPlayer.STATUS_STOP) {
            isResumePlay = true;
        }
        //停止播放
        mEZUIPlayer.stopPlay();

    }

    protected void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "onDestroy");

        //释放资源
        mEZUIPlayer.releasePlayer();
    }
    public void  onPlaySuccess() {
        Log.d(TAG, "onPlaySuccess");
        // TODO: 2017/2/7 播放成功处理
        mBtnPlay.setText("暂停");
    }

    public void onPlayFail(EZUIError error) {
        Log.d(TAG,"onPlayFail");
        // TODO: 2017/2/21 播放失败处理
        if (error.getErrorString().equals(EZUIError.UE_ERROR_INNER_VERIFYCODE_ERROR)){

        }else if(error.getErrorString().equalsIgnoreCase(EZUIError.UE_ERROR_NOT_FOUND_RECORD_FILES)){
            // TODO: 2017/5/12
            //未发现录像文件
            Toast.makeText(this,"未找到录像文件",Toast.LENGTH_LONG).show();
        }

    }

    public void onVideoSizeChange(int width, int height) {
        Log.d(TAG, "onVideoSizeChange  width = " + width + "   height = " + height);
    }

    public void onPrepared() {
        Log.d(TAG, "onPrepared");
        //播放
        mEZUIPlayer.startPlay();
    }

    public void onPlayTime(@Nullable Calendar calendar) {
        Log.d(TAG, "onPlayTime");
        if (calendar != null) {
            // TODO: 2017/2/16 当前播放时间
            Log.d(TAG, "onPlayTime calendar = " + calendar.getTime().toString());
        }

    }

    public void onPlayFinish() {
        Log.d(TAG, "onPlayFinish");
    }

    /**
     * 屏幕旋转时调用此方法
     */
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        Log.d(TAG, "onConfigurationChanged");
        setSurfaceSize();
    }


    private void setSurfaceSize(){
        DisplayMetrics dm = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(dm);
        boolean isWideScrren = mOrientationDetector.isWideScrren();
        //竖屏
        if (!isWideScrren) {
            //竖屏调整播放区域大小，宽全屏，高根据视频分辨率自适应
            mEZUIPlayer.setSurfaceSize(dm.widthPixels, 0);
        } else {
            //横屏屏调整播放区域大小，宽、高均全屏，播放区域根据视频分辨率自适应
            mEZUIPlayer.setSurfaceSize(dm.widthPixels,dm.heightPixels);
        }
    }


    @Override
    public void onWindowSizeChanged(int w, int h, int oldW, int oldH) {
        if (mEZUIPlayer != null) {
            setSurfaceSize();
        }
    }

    @Override
    public void onClick(View view) {
        if (view == mBtnPlay){
            // TODO: 2017/2/14
            if (mEZUIPlayer.getStatus() == EZUIPlayer.STATUS_PLAY) {
                //播放状态，点击停止播放
                mBtnPlay.setText("播放");
                mEZUIPlayer.stopPlay();
            } else if (mEZUIPlayer.getStatus() == EZUIPlayer.STATUS_STOP) {
                //停止状态，点击播放
                mBtnPlay.setText("停止");
                mEZUIPlayer.startPlay();
            }
        }
    }

    public class MyOrientationDetector extends OrientationEventListener {

        private WindowManager mWindowManager;
        private int mLastOrientation = 0;

        public MyOrientationDetector(Context context) {
            super(context);
            mWindowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        }

        public boolean isWideScrren() {
            Display display = mWindowManager.getDefaultDisplay();
            Point pt = new Point();
            display.getSize(pt);
            return pt.x > pt.y;
        }
        @Override
        public void onOrientationChanged(int orientation) {
            int value = getCurentOrientationEx(orientation);
            if (value != mLastOrientation) {
                mLastOrientation = value;
                int current = getRequestedOrientation();
                if (current == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                        || current == ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE) {
                    setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR);
                }
            }
        }

        private int getCurentOrientationEx(int orientation) {
            int value = 0;
            if (orientation >= 315 || orientation < 45) {
                // 0度
                value = 0;
                return value;
            }
            if (orientation >= 45 && orientation < 135) {
                // 90度
                value = 90;
                return value;
            }
            if (orientation >= 135 && orientation < 225) {
                // 180度
                value = 180;
                return value;
            }
            if (orientation >= 225 && orientation < 315) {
                // 270度
                value = 270;
                return value;
            }
            return value;
        }
    }
}
