package ${packageName};

<#--import ${superClassFqcn}; // it will import androidx.appcompat.app.AppCompatActivity -->

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.webkit.WebBackForwardList;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ProgressBar;

import androidx.appcompat.app.AppCompatActivity;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import ${packageName}.browse.ChromeBrowser;
import ${packageName}.browse.WebViewBrowser;
import ${packageName}.jsinterface.ActivityBrowserContract;
import ${packageName}.util.ConnectivityReceiver;
import ${packageName}.util.Helper;
import ${packageName}.util.ObservableObject;

import java.util.Observable;
import java.util.Observer;

public class MainActivity extends AppCompatActivity implements Observer, ActivityBrowserContract.Activity {
    private static final String TAG = "MainActivity";

    private SwipeRefreshLayout refreshLayout;

    private FrameLayout rootLayout;
    private WebView mainWebView;

    private ProgressBar progressBar;
    private ConnectivityReceiver connectivityReceiver;
    private View firstTimeLoadingView;
    private View noInternetView;
    private Button retryBtn;
    private Animation fadeInAnim;
    private Animation fadeOutAnim;

    private ChromeBrowser chromeBrowser;
    private String setItemOnLocalStorageJsFun;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        init(savedInstanceState);
    }

    @SuppressLint({"SetJavaScriptEnabled", "JavascriptInterface"})
    private void init(Bundle savedInstanceState) {

        rootLayout = findViewById(R.id.webview_root_layout);

        progressBar = findViewById(R.id.progress_bar);

        refreshLayout = findViewById(R.id.refresh_layout);

        mainWebView = findViewById(R.id.main_web_view);

        WebSettings webSettings = mainWebView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        webSettings.setDomStorageEnabled(true);
        webSettings.setSupportMultipleWindows(true);
        webSettings.setLoadWithOverviewMode(true);
        webSettings.setUseWideViewPort(true);
        webSettings.setBuiltInZoomControls(false);
        webSettings.setDatabaseEnabled(true);
        webSettings.setCacheMode(WebSettings.LOAD_DEFAULT);
        webSettings.setAppCacheEnabled(true);
        webSettings.setAllowUniversalAccessFromFileURLs(true);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }

        mainWebView.setWebViewClient(new WebViewBrowser(this));
        mainWebView.setWebChromeClient(new ChromeBrowser(this, progressBar, refreshLayout, this));
        mainWebView.setScrollBarStyle(View.SCROLLBARS_INSIDE_OVERLAY);

        firstTimeLoadingView = findViewById(R.id.full_page_loader);
        noInternetView = findViewById(R.id.no_internet_layout);

        retryBtn = noInternetView.findViewById(R.id.retry_btn);

        retryBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Helper.isNetworkAvailable(MainActivity.this))
                    hideNoInternetView();
                else
                    showNoInternetView();
            }
        });

        // Observer connection changes, while app is running
        ObservableObject.getInstance().addObserver(this);

        fadeInAnim = AnimationUtils.loadAnimation(MainActivity.this, R.anim.no_internet_fade_in);
        fadeOutAnim = AnimationUtils.loadAnimation(MainActivity.this, R.anim.no_internet_fade_out);

        fadeInAnim.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                noInternetView.setVisibility(View.VISIBLE);
            }

            @Override
            public void onAnimationEnd(Animation animation) {

            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });

        fadeOutAnim.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                noInternetView.setVisibility(View.GONE);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });

        refreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                mainWebView.reload();
            }
        });

        mainWebView.loadUrl(Helper.getHomePageUrl());
    }

    @Override
    protected void onStart() {
        super.onStart();

        connectivityReceiver = new ConnectivityReceiver();
        IntentFilter filter = new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION);
        filter.addAction(getPackageName() + "android.net.conn.CONNECTIVITY_CHANGE");

        registerReceiver(connectivityReceiver, filter);
    }

    @Override
    protected void onStop() {
        super.onStop();
        this.unregisterReceiver(connectivityReceiver);
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        Bundle bundle = new Bundle();
        mainWebView.saveState(bundle);
        outState.putBundle("web_view_state", bundle);
    }

    @Override
    public void update(Observable observable, Object arg) {
        Intent data = (Intent) arg;
        boolean connected = data.getBooleanExtra("connected", false);

        if (connected)
            hideNoInternetView();
        else
            showNoInternetView();
    }

    private void showNoInternetView() {

        if (noInternetView.getVisibility() == View.VISIBLE)
            return;

        noInternetView.startAnimation(fadeInAnim);
    }

    private void hideNoInternetView() {
        if (noInternetView.getVisibility() == View.GONE)
            return;

        mainWebView.reload();

        new Handler().post(new Runnable() {
            @Override
            public void run() {
                noInternetView.startAnimation(fadeOutAnim);
            }
        });
    }

    @Override
    public void onBackPressed() {
        boolean safeToGoBack = true;
        WebBackForwardList webBackForwardList = mainWebView.copyBackForwardList();

        if (webBackForwardList.getCurrentItem() == null || webBackForwardList.getCurrentItem().getUrl() == null) {
            safeToGoBack = false; // let the Android OS handle the backpress, most probably app close

        } else if (webBackForwardList.getCurrentItem().getUrl().equalsIgnoreCase(Helper.getHomePageUrl())) {
            // check if home page, if yes don't let the user go back,
            // let the system handle this backpress (close the app)
            safeToGoBack = false;
        }


        if (mainWebView.canGoBack() && safeToGoBack) {
            mainWebView.goBack();
        } else
            super.onBackPressed();
    }

    @Override
    public void onPageFinished() {
        if (firstTimeLoadingView.getVisibility() == View.VISIBLE)
            firstTimeLoadingView.setVisibility(View.GONE);
    }
}
