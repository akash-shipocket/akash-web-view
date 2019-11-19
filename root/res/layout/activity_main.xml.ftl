<?xml version="1.0" encoding="utf-8"?>
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/webview_root_layout"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    app:layout_behavior="@string/appbar_scrolling_view_behavior"
    tools:mContext="MainActivity">

    <androidx.swiperefreshlayout.widget.SwipeRefreshLayout
        android:id="@+id/refresh_layout"
        android:layout_width="match_parent"
        android:layout_height="match_parent">

        <WebView
            android:id="@+id/main_web_view"
            android:layout_width="match_parent"
            android:layout_height="match_parent" />

    </androidx.swiperefreshlayout.widget.SwipeRefreshLayout>

    <ProgressBar
        android:id="@+id/progress_bar"
        style="@style/ProgressBarTheme"
        android:layout_width="match_parent"
        android:layout_height="2dp"
        android:layout_gravity="top"
        android:layout_margin="0dp"
        android:foregroundGravity="top"
        android:indeterminate="true"
        android:max="100"
        android:padding="0dp"
        android:visibility="gone" />

    <include
        android:id="@+id/full_page_loader"
        layout="@layout/full_page_loader" />

    <include
        android:id="@+id/no_internet_layout"
        layout="@layout/no_internet_layout"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:visibility="gone" />

</FrameLayout>
