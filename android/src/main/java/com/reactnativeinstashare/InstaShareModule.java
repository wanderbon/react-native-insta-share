package com.reactnativeinstashare;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.support.v4.content.FileProvider;
import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;

import java.io.File;

@ReactModule(name = InstaShareModule.NAME)
public class InstaShareModule extends ReactContextBaseJavaModule {
    public static final String NAME = "InstaShare";
    ReactApplicationContext mContext;
    Promise mainPromise;

    String type = "image/*";

    public InstaShareModule(ReactApplicationContext reactContext) {
        super(reactContext);

        mContext = reactContext;
    }

    @Override
    @NonNull
    public String getName() {
        return NAME;
    }

    @ReactMethod
    public void share(String uri, Promise promise) {
      mainPromise = promise;
      try {
        createInstagramIntent(type, uri);
      } catch(Exception exception) {
        promise.reject(exception);
      }
    }

    private void createInstagramIntent(String type, String mediaPath){
      File media = new File(mediaPath);
      Uri uri = FileProvider.getUriForFile(
        mContext,
        mContext.getPackageName() + ".provider",
        media);

      Intent feedIntent = new Intent(Intent.ACTION_SEND);
      feedIntent.setType("image/*");
      feedIntent.putExtra(Intent.EXTRA_STREAM, uri);
      feedIntent.setPackage("com.instagram.android");

      Intent storiesIntent = new Intent("com.instagram.share.ADD_TO_STORY");
      storiesIntent.setDataAndType(uri, "jpg");
      storiesIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
      storiesIntent.setPackage("com.instagram.android");

      mContext.grantUriPermission(
        "com.instagram.android", uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);

      Intent chooserIntent = Intent.createChooser(feedIntent, mContext.getString(R.string.social_instagram));
      chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, new Intent[] {storiesIntent});
      chooserIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

      PackageManager packageManager = mContext.getPackageManager();
      if (feedIntent.resolveActivity(packageManager) != null) {
        mContext.startActivity(chooserIntent);
      } else {
        if(mainPromise != null) {
          mainPromise.reject("101", "app_not_install");
        }

        final String appPackageName = "com.instagram.android";
        Intent GooglePlayIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=" + appPackageName));
        Intent MarketIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + appPackageName));

        GooglePlayIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        MarketIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        try {
          mContext.startActivity(MarketIntent);
        } catch (android.content.ActivityNotFoundException anfe) {
          mContext.startActivity(GooglePlayIntent);
        }
      }
    }
}
