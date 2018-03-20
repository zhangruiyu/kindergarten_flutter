package com.kindergarten.kindergarten.cameraplay;


import android.content.Context;
import android.graphics.Color;
import android.graphics.Point;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.ezvizuikit.open.EZUIError;
import com.ezvizuikit.open.EZUIPlayer;
import com.videogo.errorlayer.ErrorInfo;
import com.videogo.openapi.EZPlayer;
import com.videogo.openapi.EzvizAPI;
import com.videogo.openapi.bean.EZCloudRecordFile;
import com.videogo.openapi.bean.EZRecordFile;
import com.videogo.util.LogUtil;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Created by zhangruiyu on 2018/1/25.
 */

public class CustomEZUIPlayer extends RelativeLayout implements CUSTOMEZUIPlayerInterface {
    private static final String TAG = "EZUIPlayer";
    private Context mContext;
    private SurfaceView mSurfaceView;
    private RelativeLayout mSurfaceFrame;
    private SurfaceHolder mHolder;
    private EZPlayer mEZPlayer;
    private EZUIPlayer.EZUIPlayerCallBack mEzUIPlayerCallBack;
    private View mLoadView;
    private TextView mErrorTextView;
    private int mWidth = 0;
    private int mHeight = 0;
    private int mDefaultWidth = 0;
    private int mDefaultHeight = 0;
    private int mVideoWidth = 0;
    private int mVideoHeight = 0;
    private int mStatus = 0;
    private AtomicBoolean isSurfaceInit = new AtomicBoolean(false);
    private boolean isOpenSound = true;
    public static final int STATUS_INIT = 0;
    public static final int STATUS_START = 1;
    public static final int STATUS_STOP = 2;
    public static final int STATUS_PLAY = 3;
    public static final int STATUS_PAUSE = 4;
    private EZPlayURLParams ezPlayURLParams = new EZPlayURLParams();
    private ArrayList<EZRecordFile> mRecordFiles;
    private ArrayList<EZRecordFile> mPlayRecordList;
    private int mCurrentIndex = 0;
    private boolean isPlayBack;
    private static final int MSG_UPDATE_OSD = 8888;
    private Calendar mSeekCalendar;
    private Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            String errorCodeStr;
            switch (msg.what) {
                case 102:
                case 205:
                    LogUtil.d("EZUIPlayer", "MSG_REALPLAY_PLAY_SUCCESS");
                    CustomEZUIPlayer.this.dismissomLoading();
                    CustomEZUIPlayer.this.optionSound();
                    if (CustomEZUIPlayer.this.mStatus != 2) {
                        CustomEZUIPlayer.this.setStatus(3);
                        CustomEZUIPlayer.this.mEzUIPlayerCallBack.onPlaySuccess();
                    }

                    this.sendEmptyMessage(8888);
                    break;
                case 103:
                case 206:
                    LogUtil.d("EZUIPlayer", "MSG_REALPLAY_PLAY_FAIL");
                    this.removeMessages(8888);
                    CustomEZUIPlayer.this.dismissomLoading();
                    if (CustomEZUIPlayer.this.mStatus != 2) {
                        errorCodeStr = "UE105";
                        if (msg.obj == null) {
                            ;
                        }

                        switch (((ErrorInfo) msg.obj).errorCode) {
                            case 110018:
                                errorCodeStr = "UE002";
                                break;
                            case 120001:
                                errorCodeStr = "UE004";
                                break;
                            case 120002:
                                errorCodeStr = "UE005";
                                break;
                            case 380045:
                            case 395410:
                                errorCodeStr = "UE101";
                                break;
                            case 395546:
                                errorCodeStr = "UE109";
                                break;
                            case 400002:
                                errorCodeStr = "UE006";
                                break;
                            case 400032:
                                errorCodeStr = "UE107";
                                break;
                            case 400034:
                                errorCodeStr = "UE103";
                                break;
                            case 400035:
                            case 400036:
                                errorCodeStr = "UE104";
                                break;
                            case 400901:
                                errorCodeStr = "UE102";
                                break;
                            case 400902:
                                errorCodeStr = "UE001";
                                break;
                            case 400903:
                                errorCodeStr = "UE106";
                                break;
                            case 410034:
                            default:
                                errorCodeStr = "UE105";
                        }

                        CustomEZUIPlayer.this.stopPlay();
                        CustomEZUIPlayer.this.mEzUIPlayerCallBack.onPlayFail(new EZUIError(errorCodeStr, ((ErrorInfo) msg.obj).errorCode));
                        CustomEZUIPlayer.this.showPlayError(errorCodeStr + "(" + ((ErrorInfo) msg.obj).errorCode + ")");
                    }
                    break;
                case 134:
                    LogUtil.d("EZUIPlayer", "MSG_VIDEO_SIZE_CHANGED");
                    CustomEZUIPlayer.this.dismissomLoading();

                    try {
                        errorCodeStr = (String) msg.obj;
                        String[] strings = errorCodeStr.split(":");
                        CustomEZUIPlayer.this.mEzUIPlayerCallBack.onVideoSizeChange(Integer.parseInt(strings[0]), Integer.parseInt(strings[1]));
                        CustomEZUIPlayer.this.mVideoWidth = Integer.parseInt(strings[0]);
                        CustomEZUIPlayer.this.mVideoHeight = Integer.parseInt(strings[1]);
                        CustomEZUIPlayer.this.setSurfaceSize(CustomEZUIPlayer.this.mWidth, CustomEZUIPlayer.this.mHeight);
                    } catch (Exception var4) {
                        var4.printStackTrace();
                    }
                    break;
                case 201:
                    LogUtil.d("EZUIPlayer", "MSG_REMOTEPLAYBACK_PLAY_FINISH");
                    CustomEZUIPlayer.this.handlePlayFinish();
                    break;
                case 8888:
                    this.removeMessages(8888);
                    if (CustomEZUIPlayer.this.mEzUIPlayerCallBack != null && CustomEZUIPlayer.this.mStatus == 3) {
                        CustomEZUIPlayer.this.mSeekCalendar = CustomEZUIPlayer.this.getOSDTime();
                        if (CustomEZUIPlayer.this.mSeekCalendar != null) {
                            CustomEZUIPlayer.this.mEzUIPlayerCallBack.onPlayTime((Calendar) CustomEZUIPlayer.this.mSeekCalendar.clone());
                        }

                        this.sendEmptyMessageDelayed(8888, 1000L);
                    }
            }

        }
    };

    private void setOpenSound(boolean openSound) {
        this.isOpenSound = openSound;
        this.optionSound();
    }

    private boolean isOpenSound() {
        return this.isOpenSound;
    }

    private void optionSound() {
        if (this.mEZPlayer != null) {
            if (this.isOpenSound()) {
                this.mEZPlayer.openSound();
            } else {
                this.mEZPlayer.closeSound();
            }
        }

    }

    public CustomEZUIPlayer(Context context) {
        super(context);
        this.mContext = context;
        this.initSurfaceView();
    }

    public CustomEZUIPlayer(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.mContext = context;
        this.initSurfaceView();
    }

    public CustomEZUIPlayer(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        this.mContext = context;
        this.initSurfaceView();
    }

    private void initSurfaceView() {
        if (this.mSurfaceView == null) {
            this.mSurfaceView = new SurfaceView(this.mContext);
            LayoutParams lp = new LayoutParams(-2, -2);
            lp.addRule(13);
            this.mSurfaceView.setLayoutParams(lp);
            this.addView(this.mSurfaceView);
        }

    }

    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        this.mDefaultWidth = MeasureSpec.getSize(widthMeasureSpec);
        this.mDefaultHeight = MeasureSpec.getSize(heightMeasureSpec);
        android.view.ViewGroup.LayoutParams layoutParams = this.getLayoutParams();
        if (layoutParams.height == -2) {
            this.mDefaultHeight = (int) ((double) this.mDefaultWidth * 0.562D);
        }

        LogUtil.d("EZUIPlayer", "onMeasure  mDefaultWidth = " + this.mDefaultWidth + "  mDefaultHeight= " + this.mDefaultHeight);
        widthMeasureSpec = MeasureSpec.makeMeasureSpec(this.mDefaultWidth, MeasureSpec.getMode(widthMeasureSpec));
        heightMeasureSpec = MeasureSpec.makeMeasureSpec(this.mDefaultHeight, MeasureSpec.getMode(heightMeasureSpec));
        if (this.mSurfaceView != null && this.mHolder == null) {
            this.mHolder = this.mSurfaceView.getHolder();
            this.mHolder.addCallback(new Callback() {
                public void surfaceCreated(SurfaceHolder holder) {
                    if (CustomEZUIPlayer.this.mEZPlayer != null) {
                        CustomEZUIPlayer.this.mEZPlayer.setSurfaceHold(holder);
                        CustomEZUIPlayer.this.mEZPlayer.setHandler(CustomEZUIPlayer.this.mHandler);
                    }

                    CustomEZUIPlayer.this.mHolder = holder;
                    if (!CustomEZUIPlayer.this.isSurfaceInit.getAndSet(true)) {
                        CustomEZUIPlayer.this.startPlay();
                    }

                }

                public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
                }

                public void surfaceDestroyed(SurfaceHolder holder) {
                    if (CustomEZUIPlayer.this.mEZPlayer != null) {
                        CustomEZUIPlayer.this.mEZPlayer.setSurfaceHold((SurfaceHolder) null);
                    }

                }
            });
        }

        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    public void setCallBack(EZUIPlayer.EZUIPlayerCallBack callBack) {
        this.mEzUIPlayerCallBack = callBack;
    }


    public void setUrl(String deviceSerial, String verifyCode, int cameraNo) {
        ezPlayURLParams.deviceSerial = (deviceSerial);
        ezPlayURLParams.verifyCode=(verifyCode);
        ezPlayURLParams.cameraNo =(cameraNo);
        if (this.mEZPlayer != null) {
            this.mEZPlayer.release();
            this.mEZPlayer = null;
            if (this.mRecordFiles != null) {
                this.mRecordFiles.clear();
            }
        }
        this.mEZPlayer = EzvizAPI.getInstance().createPlayer(this.ezPlayURLParams.deviceSerial, this.ezPlayURLParams.cameraNo);
        if (!TextUtils.isEmpty(this.ezPlayURLParams.verifyCode)) {
            this.mEZPlayer.setPlayVerifyCode(this.ezPlayURLParams.verifyCode);
        }

        this.mEZPlayer.setHandler(this.mHandler);
        if (this.mHolder != null) {
            this.mEZPlayer.setSurfaceHold(this.mHolder);
        }

        this.showLoading();
    }

    public List<EZRecordFile> getPlayList() {
        return this.mRecordFiles;
    }


    public int getStatus() {
        return this.mStatus;
    }

    private void setStatus(int status) {
        LogUtil.d("EZUIPlayer", "setStatus = " + status);
        this.mStatus = status;
    }

    public void startPlay() {
        if (!this.isPlayBack || this.mPlayRecordList != null && this.mPlayRecordList.size() != 0 && this.mCurrentIndex < this.mPlayRecordList.size()) {
            if (this.mStatus != 1 && this.mStatus != 3) {
                if (this.mEZPlayer == null) {
                    LogUtil.d("EZUIPlayer", "EZPlayer is null ,you can transfer createUIPlayer function");
                } else {
                    if (this.mEZPlayer != null && this.isSurfaceInit.get()) {
                        this.showLoading();
                        this.setStatus(1);
                        if (this.isPlayBack) {
                            EZRecordFile recordfile = (EZRecordFile) this.mPlayRecordList.get(this.mCurrentIndex);
                            Calendar start = Calendar.getInstance();
                            Calendar end = Calendar.getInstance();
                            start.setTimeInMillis(recordfile.getStartTime());
                            end.setTimeInMillis(recordfile.getEndTime());
                            if (recordfile.getRecType() == 1) {
                                EZCloudRecordFile e = new EZCloudRecordFile();
                                e.setDownloadPath(recordfile.getDownloadPath());
                                e.setEncryption(recordfile.getEncryption());
                                if (start.before(this.mSeekCalendar)) {
                                    start = (Calendar) this.mSeekCalendar.clone();
                                }

                                e.setStartTime(start);
                                e.setStopTime(end);
                                this.mEZPlayer.startPlayback(e);
                            } else if (recordfile.getRecType() == 2) {
                                if (start.before(this.mSeekCalendar)) {
                                    start = (Calendar) this.mSeekCalendar.clone();
                                }

                                this.mEZPlayer.startPlayback(start, end);
                            }
                        } else {
                            this.mEZPlayer.startRealPlay();
                        }
                    }

                }
            } else {
                LogUtil.d("EZUIPlayer", "status is start or play");
            }
        }
    }

    public void seekPlayback(Calendar calendar) {
        if (calendar != null) {
            Log.d("EZUIPlayer", "seekPlayback  = " + calendar.getTime().toString());
            if (this.mPlayRecordList != null && this.mPlayRecordList.size() > 0) {
                int index = this.getCurrentIndex(calendar);
                this.stopPlay();
                if (index < 0) {
                    this.dismissomLoading();
                    if (this.mEzUIPlayerCallBack != null) {
                        this.mEzUIPlayerCallBack.onPlayFinish();
                    }

                } else {
                    this.mSeekCalendar = (Calendar) calendar.clone();
                    this.mCurrentIndex = index;
                    this.startPlay();
                }
            }
        }
    }

    public Calendar getOSDTime() {
        return this.mEZPlayer != null ? this.mEZPlayer.getOSDTime() : null;
    }

    public void stopPlay() {
        this.mHandler.removeMessages(8888);
        if (this.mStatus != 2) {
            this.setStatus(2);
            if (this.mEZPlayer != null) {
                if (this.isPlayBack) {
                    this.mEZPlayer.stopPlayback();
                } else {
                    this.mEZPlayer.stopRealPlay();
                }
            }
        }

    }

    public void resumePlay() {
        if (!this.isPlayBack) {
            LogUtil.d("EZUIPlayer", "this is playback method");
        } else if (!this.isPlayBack || this.mPlayRecordList != null && this.mPlayRecordList.size() != 0 && this.mCurrentIndex < this.mPlayRecordList.size()) {
            if (this.mStatus != 1 && this.mStatus != 3) {
                if (this.mEZPlayer == null) {
                    LogUtil.d("EZUIPlayer", "EZPlayer is null ,you can transfer createUIPlayer function");
                } else {
                    LogUtil.debugLog("EZUIPlayer", "resumeRealPlay");
                    this.mHandler.sendEmptyMessage(8888);
                    this.mStatus = 3;
                    this.mEZPlayer.resumePlayback();
                }
            } else {
                LogUtil.d("EZUIPlayer", "status is start or play");
            }
        }
    }

    public void pausePlay() {
        LogUtil.debugLog("EZUIPlayer", "pausePlay");
        this.mHandler.removeMessages(8888);
        this.mStatus = 4;
        if (this.mEZPlayer != null) {
            this.mEZPlayer.pausePlayback();
        }

    }

    public void releasePlayer() {
        this.mHandler.removeMessages(8888);
        if (this.mEZPlayer != null) {
            this.mEZPlayer.release();
            this.mEZPlayer = null;
        }

    }

    private void handlePlayFinish() {
        this.mHandler.removeMessages(8888);
        ++this.mCurrentIndex;
        this.stopPlay();
        if (this.mCurrentIndex >= this.mPlayRecordList.size()) {
            if (this.mEzUIPlayerCallBack != null) {
                this.mEzUIPlayerCallBack.onPlayFinish();
            }
        } else {
            this.startPlay();
        }

    }

    public void setSurfaceSize(int width, int height) {
        this.mWidth = width;
        this.mHeight = height;
        android.view.ViewGroup.LayoutParams lp = this.getLayoutParams();
        if (lp == null) {
            lp = new android.view.ViewGroup.LayoutParams(width, height);
        } else if (this.mWidth == 0 && this.mHeight == 0) {
            this.mWidth = lp.width;
            this.mHeight = lp.height;
            if (lp.width == -1) {
                this.mWidth = this.getMeasuredWidth();
            }

            if (lp.height == -1) {
                this.mHeight = this.getMeasuredHeight();
            }
        } else {
            lp.width = width;
            lp.height = height;
        }

        Log.d("EZUIPlayer", "setSurfaceSize  mWidth = " + this.mWidth + "  mHeight = " + this.mHeight);
        if (width == 0 && height != 0) {
            if (this.mVideoHeight != 0 && this.mVideoWidth != 0) {
                lp.width = (int) ((float) (height * this.mVideoWidth) * 1.0F / (float) this.mVideoWidth);
            } else {
                lp.width = (int) ((double) height * 1.1778D);
            }
        }

        if (width != 0 && height == 0) {
            if (this.mVideoHeight != 0 && this.mVideoWidth != 0) {
                lp.height = (int) ((float) (width * this.mVideoHeight) * 1.0F / (float) this.mVideoWidth);
            } else {
                lp.height = (int) ((double) width * 0.562D);
            }
        }

        this.setLayoutParams(lp);
        this.changeSurfaceSize(this.mSurfaceView, this.mVideoWidth, this.mVideoHeight);
    }

    private void showPlayError(String errorInfo) {
        if (this.mLoadView != null) {
            this.mLoadView.setVisibility(GONE);
        }

        if (this.mErrorTextView == null) {
            this.mErrorTextView = new TextView(this.mContext);
            this.mErrorTextView.setText(errorInfo);
            this.mErrorTextView.setTextColor(Color.rgb(255, 255, 255));
            LayoutParams lp = new LayoutParams(-2, -2);
            lp.addRule(13);
            this.mErrorTextView.setLayoutParams(lp);
            this.addView(this.mErrorTextView);
        }

        this.mErrorTextView.setVisibility(VISIBLE);
    }

    public void setLoadingView(View view) {
        this.mLoadView = view;
    }

    private void showLoading() {
        if (this.mErrorTextView != null) {
            this.mErrorTextView.setVisibility(GONE);
        }

        if (this.mLoadView != null) {
            if (this.mLoadView.getParent() == null) {
                this.addView(this.mLoadView);
            }

            this.mLoadView.setVisibility(VISIBLE);
        } else {
            this.mLoadView = new ProgressBar(this.mContext);
            LayoutParams lp = new LayoutParams(-2, -2);
            lp.addRule(13);
            this.mLoadView.setLayoutParams(lp);
            this.addView(this.mLoadView);
            this.mLoadView.setVisibility(VISIBLE);
        }

    }

    private void dismissomLoading() {
        if (this.mLoadView != null) {
            this.mLoadView.setVisibility(GONE);
        }

    }

    private Point getSurfaceSize(SurfaceView surface, int videoWidth, int videoHeight) {
        Point pt = null;
        if (surface == null) {
            return pt;
        } else {
            if (videoWidth == 0 || videoHeight == 0) {
                videoWidth = 16;
                videoHeight = 9;
            }

            int sw = this.mWidth;
            int sh = this.mHeight;
            LogUtil.d("EZUIPlayer", "sw =  " + sw + "  sh = " + sh);
            double dw = (double) sw;
            double dh = (double) sh;
            if (dw * dh != 0.0D && videoWidth * videoHeight != 0) {
                double vw = (double) videoWidth;
                double ar = (double) videoWidth / (double) videoHeight;
                double dar = dw / dh;
                if (dar < ar) {
                    dh = dw / ar;
                } else {
                    dw = dh * ar;
                }

                int w = (int) Math.ceil(dw * (double) videoWidth / (double) videoWidth);
                int h = (int) Math.ceil(dh * (double) videoHeight / (double) videoHeight);
                pt = new Point(w, h);
                Log.d("EZUIPlayer", "Point w=  " + w + "  h = " + h);
                return pt;
            } else {
                return pt;
            }
        }
    }

    private void changeSurfaceSize(SurfaceView surface, int videoWidth, int videoHeight) {
        if (surface != null) {
            SurfaceHolder holder = surface.getHolder();
            Point size = this.getSurfaceSize(surface, videoWidth, videoHeight);
            if (size != null) {
                holder.setFixedSize(videoWidth, videoHeight);
                android.view.ViewGroup.LayoutParams lp = surface.getLayoutParams();
                int oldH = lp.height;
                lp.width = size.x;
                lp.height = size.y;
                Log.d("EZUIPlayer", "changeSurfaceSize  width =  " + lp.width + "  height = " + lp.height);
                surface.setLayoutParams(lp);
            }
        }
    }

    private int getCurrentIndex(Calendar calendar) {
        if (this.mPlayRecordList != null && this.mPlayRecordList.size() > 0) {
            for (int i = 0; i < this.mPlayRecordList.size(); ++i) {
                EZRecordFile recordFile = (EZRecordFile) this.mPlayRecordList.get(i);
                boolean var10000 = calendar.getTimeInMillis() > recordFile.getEndTime() ? true : true;
                if (calendar.getTimeInMillis() < recordFile.getEndTime()) {
                    return i;
                }
            }

            return -1;
        } else {
            return -1;
        }
    }

}