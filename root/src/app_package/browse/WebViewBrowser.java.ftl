package ${packageName}.browse;

import android.content.Context;
import android.net.Uri;
import android.os.Build;
import android.view.KeyEvent;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.annotation.RequiresApi;

import ${packageName}.util.Helper;

import java.util.Objects;

public class WebViewBrowser extends WebViewClient {
    private static final String TAG = "WebViewBrowser";
    private Context context;

    public WebViewBrowser(Context context) {
        this.context = context;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {

        Uri uri = request.getUrl();
        String url = uri.toString();

        return getShouldOverrideUrl(view, uri, url);
    }

    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String url) {

        Uri uri = Uri.parse(url);

        return getShouldOverrideUrl(view, uri, url);
    }

    private boolean getShouldOverrideUrl(WebView view, Uri uri, String url) {

        if (Helper.isTrustedUrl(Objects.requireNonNull(uri.getHost()))) {
            view.loadUrl(url);
            return true;
        }

        if (url.startsWith("tel:")) {

            Helper.handlePhoneCallLink(context, url);
            return true;

        } else if (url.startsWith("mailto")) {

            Helper.handleMailToLink(context, url);
            return true;
        }

        return false;
    }

    @Override
    public boolean shouldOverrideKeyEvent(WebView webView, KeyEvent event) {
        if (event.getAction() == KeyEvent.KEYCODE_BACK && webView.canGoBack()) {
            webView.goBack();
            return true;
        }

        return super.shouldOverrideKeyEvent(webView, event);
    }
}
