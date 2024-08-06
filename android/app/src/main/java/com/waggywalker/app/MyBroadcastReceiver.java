package com.example.background_service;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class MyBroadcastReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction()) || Intent.ACTION_MY_PACKAGE_REPLACED.equals(intent.getAction())) {
            Log.d("MyBroadcastReceiver", "onReceive: Boot completed or package replaced");
            Intent serviceIntent = new Intent(context, MyBackgroundService.class);
            context.startForegroundService(serviceIntent);
        }
    }
}
