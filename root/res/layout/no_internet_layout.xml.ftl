<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@android:color/white"
    android:orientation="vertical">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_weight="1"
        android:fontFamily="sans-serif-condensed"
        android:gravity="center"
        android:text="We can not detect any internet connectivity. Please Check your internet connection and try again."
        android:textAlignment="center"
        android:textAppearance="@android:style/TextAppearance.DeviceDefault.Large" />

    <ImageView
        android:id="@+id/not_internet_icon"
        android:layout_width="wrap_content"
        android:layout_height="0dp"
        android:layout_centerInParent="true"
        android:layout_gravity="center"
        android:layout_weight="4"
        android:src="@drawable/ic_no_internet" />
    
    <Button
        android:id="@+id/retry_btn"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="center"
        android:layout_margin="@dimen/activity_vertical_margin"

        android:gravity="center"
        android:padding="@dimen/activity_vertical_margin"
        android:text="Retry" />

</LinearLayout>