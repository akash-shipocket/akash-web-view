package ${packageName}.util;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.Uri;
import android.os.Handler;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.view.ContextThemeWrapper;

import ${packageName}.R;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

public class Helper {

    public static String getHomePageUrl() {
        return "${homePageUrl}";
    }

    public static boolean isTrustedUrl(String url) {
        Uri uri = Uri.parse(getHomePageUrl());

        if (uri.getHost() != null) {
            return url.toLowerCase().contains(uri.getHost().toLowerCase());
        }
        return false;
    }


    public static boolean isNetworkAvailable(Context context) {
        final ConnectivityManager connectivityManager =
                ((ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE));
        return connectivityManager.getActiveNetworkInfo() != null &&
                connectivityManager.getActiveNetworkInfo().isConnected();
    }

    public static void showErr(Context context) {
        showErr(context, "Something Went Wrong while processing your request");
    }

    public static void showErr(Context context, String err) {
        if (context != null)
            Toast.makeText(context, err, Toast.LENGTH_LONG).show();
    }

    public static void showSuccess(Context context, String msg) {
        if (context != null)
            Toast.makeText(context, msg, Toast.LENGTH_LONG).show();
    }

    private static AlertDialog progressDialog = null;

    public static void showProgressDialog(Context context) {
        showProgressDialog(context, null, false, 0);
    }

    public static void showProgressDialog(Context context, String text) {
        showProgressDialog(context, text, false, 0);
    }

    public static void showProgressDialog(Context context, String text, boolean isCancelable) {
        showProgressDialog(context, text, isCancelable, 0);
    }

    public static void showProgressDialog(Context context, String text, boolean isCancelable,
                                          final int autoCloseAfterInMilli) {
        if (context == null)
            return;
        if (progressDialog == null)
            progressDialog = new AlertDialog.Builder(new ContextThemeWrapper(context, R.style.ProgressDialogTheme)).create();

        View dialogLayout = LayoutInflater.from(context).inflate(R.layout.progress_dialog_layout, null);
        if (!TextUtils.isEmpty(text))
            ((TextView) dialogLayout.findViewById(R.id.progress_dialog_text_view)).setText(text);
        progressDialog.setCancelable(isCancelable);
        progressDialog.setView(dialogLayout);
        progressDialog.show();

        if (autoCloseAfterInMilli > 0)
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    progressDialog.dismiss();
                }
            }, autoCloseAfterInMilli);
    }

    public static void hideProgressDialog() {
        if (progressDialog != null) {
            progressDialog.dismiss();
            progressDialog = null;
        }
    }

    public static String getTVal(Context context) {
        String tval = "";
        if (context != null) {
            SharedPreferences sp = context.getSharedPreferences("client_sp", Context.MODE_PRIVATE);
            tval = sp.getString("tval", "");
        }
        return tval;
    }

    public static void showMsg(Context context, String msg) {
        if (context == null)
            return;
        Toast
                .makeText(context, msg, Toast.LENGTH_LONG)
                .show();
    }

    public static void showNotInternetMsg(Context context) {
        showMsg(context, "Internet is Not available.");
    }

    public static boolean appInstalledOrNot(Context context, String uri) {
        PackageManager pm = context.getPackageManager();
        boolean app_installed;
        try {
            pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES);
            app_installed = true;
        } catch (PackageManager.NameNotFoundException e) {
            app_installed = false;
        }
        return app_installed;
    }

    public static String sharingUrl(Context context) {
        return "https://play.google.com/store/apps/details?id=" + context.getPackageName();
    }

    public static void shareApp(Context context) {
        Intent shareIntent = new Intent();
        shareIntent.setAction(Intent.ACTION_SEND);
        shareIntent.putExtra(Intent.EXTRA_TEXT,
                "Download ${appName} app on Google Play Store "
                        + sharingUrl(context));
        shareIntent.setType("text/plain");
        context.startActivity(shareIntent);
    }

    public static void handlePhoneCallLink(Context context, String url) {
        Intent intent = new Intent(Intent.ACTION_DIAL,
                Uri.parse(url));
        context.startActivity(intent);
    }

    public static void handleMailToLink(Context context, String url) {
        Intent intent = new Intent(Intent.ACTION_SENDTO);

        // For only email app handle this intent
        intent.setData(Uri.parse("mailto:"));

        // Extract the email address from mailto url
        String to = url.split("[:?]")[1];
        if (!TextUtils.isEmpty(to)) {
            String[] toArray = to.split(";");
            // Put the primary email addresses array into intent
            intent.putExtra(Intent.EXTRA_EMAIL, toArray);
        }

        // Extract the cc
        if (url.contains("cc=")) {
            String cc = url.split("cc=")[1];
            if (!TextUtils.isEmpty(cc)) {
                //cc = cc.split("&")[0];
                cc = cc.split("&")[0];
                String[] ccArray = cc.split(";");
                // Put the cc email addresses array into intent
                intent.putExtra(Intent.EXTRA_CC, ccArray);
            }
        }

        // Extract the bcc
        if (url.contains("bcc=")) {
            String bcc = url.split("bcc=")[1];
            if (!TextUtils.isEmpty(bcc)) {
                //cc = cc.split("&")[0];
                bcc = bcc.split("&")[0];
                String[] bccArray = bcc.split(";");
                // Put the bcc email addresses array into intent
                intent.putExtra(Intent.EXTRA_BCC, bccArray);
            }
        }

        // Extract the subject
        if (url.contains("subject=")) {
            String subject = url.split("subject=")[1];
            if (!TextUtils.isEmpty(subject)) {
                subject = subject.split("&")[0];
                // Encode the subject
                try {
                    subject = URLDecoder.decode(subject, "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                // Put the mail subject into intent
                intent.putExtra(Intent.EXTRA_SUBJECT, subject);
            }
        }

        // Extract the body
        if (url.contains("body=")) {
            String body = url.split("body=")[1];
            if (!TextUtils.isEmpty(body)) {
                body = body.split("&")[0];
                // Encode the body text
                try {
                    body = URLDecoder.decode(body, "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                // Put the mail body into intent
                intent.putExtra(Intent.EXTRA_TEXT, body);
            }
        } else {
        }

        // Email address not null or empty
        if (!TextUtils.isEmpty(to)) {
            if (intent.resolveActivity(context.getPackageManager()) != null) {
                // Finally, open the mail client activity
                context.startActivity(intent);
            } else {
                Toast.makeText(context, "No email client found.", Toast.LENGTH_SHORT).show();
            }
        }

    }

}
