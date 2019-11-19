package ${packageName}.browse;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;

import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import ${packageName}.jsinterface.ActivityBrowserContract;
import ${packageName}.util.Helper;

import java.util.Objects;

public class ChromeBrowser extends WebChromeClient {
    private static final String TAG = "ChromeBrowser";

    private Context mContext;
    private ProgressBar progressBar;
    private SwipeRefreshLayout refreshLayout;
    private ActivityBrowserContract.Activity browserContract;

    public ChromeBrowser(Context mContext, ProgressBar progressBar, SwipeRefreshLayout refreshLayout,
                         ActivityBrowserContract.Activity browserContract) {
        this.mContext = mContext;
        this.progressBar = progressBar;
        this.refreshLayout = refreshLayout;
        this.browserContract = browserContract;
    }

    @Override
    public void onProgressChanged(WebView view, int newProgress) {
        super.onProgressChanged(view, newProgress);

        if (progressBar.getVisibility() != View.VISIBLE) {
            progressBar.setVisibility(View.VISIBLE);
            progressBar.setIndeterminate(false);
        }

        progressBar.setProgress(newProgress);

        if (newProgress == 100) {
            progressBar.setVisibility(View.GONE);
            progressBar.setIndeterminate(true);

            if (refreshLayout.isRefreshing())
                refreshLayout.setRefreshing(false);
        }

        if (newProgress > 80) {
            browserContract.onPageFinished();
        }

    }


    @SuppressLint("setJavaScriptEnabled")
    @Override
    public boolean onCreateWindow(WebView view, boolean isDialog, boolean isUserGesture, Message resultMsg) {

        Log.d(TAG, "onCreateWindow: isDialog? " + isDialog + "\tisUserGesture? " + isUserGesture);

        WebView.HitTestResult hitTestResult = view.getHitTestResult();
        int type = hitTestResult.getType();
        String url = hitTestResult.getExtra();

        if (TextUtils.isEmpty(url))
            return false;

        Log.d(TAG, "onCreateWindow: type: " + type + "\turl: " + url);

        if (Helper.isTrustedUrl(Objects.requireNonNull(url))) {

            WebView targetWebView = new WebView(mContext);
            targetWebView.setWebViewClient(new WebViewClient() {


            });

            WebView.WebViewTransport transport = (WebView.WebViewTransport) resultMsg.obj;
            transport.setWebView(targetWebView);
            resultMsg.sendToTarget();

            return true;

        } else {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setData(Uri.parse(url));
            mContext.startActivity(intent);

            return false;
        }
    }

}
