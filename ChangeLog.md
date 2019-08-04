Video Player Adobe Air Native Extension (Android + iOS)

*Aug 4, 2019 - V3.2.41*
* Added Android 64-bit support
* Supports iOS 10+

*Nov 18, 2018 - V3.2.3*
* Works with OverrideAir ANE V5.6.1 or higher
* Works with ANELAB V1.1.26 or higher

*Sep 24, 2018 - V3.2.2*
* Removed androidSupport dependency then added *androidSupport-core.ane* and *androidSupport-v4.ane*

*Jul 18, 2018 - V3.2.1*
* Removed the PermissionCheck ANE prerequisite from setup manifest used by [ANELAB sofwate](https://github.com/myflashlab/ANE-LAB/)

*Jul 17, 2018 - V3.2.0*
* On Android, supporting targetSdkVersion is now 26 like below. Lower versions work also but you are recommended to use V26
```xml
<uses-sdk android:targetSdkVersion="26"/>
```
* The [permission ANE](https://github.com/myflashlab/PermissionCheck-ANE/) is no longer requierd and you no longer need to ask for external access. **Remove** the following tag from your manifest: ```<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>```
* On Android, video files must be copied to ```File.cacheDirectory``` from now on. make sure you are updating your AS3 code.
* On Android, you must add the following ```<provider>``` tag under the ```<application>``` tag.
```xml
        <provider
            android:name="com.myflashlabs.videoPlayer.AneVideoProvider"
            android:authorities="[YOUR_PACKAGE_ID].provider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/video_player_ane_provider_paths"/>
        </provider>
```

*Apr 30, 2018 - V3.1.0*
* Updated core video player in iOS side to make sure it works with latest iOS versions also.
* Added listener ```VideoPlayerEvent.DISMISSED``` to know when the player is dismissed on the **iOS side**.

*Dec 15, 2017 - V3.0.3*
* optimized for [ANE-LAB sofwate](https://github.com/myflashlab/ANE-LAB).

*Mar 30, 2017 - V3.0.1*
* Updated the ANE with the latest version overrideAir. Even if you are building for iOS, you need to include this dependency.
* Min iOS version to support this ANE is 8.0 from now on.
* Include ```NSAppTransportSecurity``` in the manifest if you are trying to play videos on **http** addresses on the iOS side.

*Nov 08, 2016 - V3.0.0*
* Optimized for Android manual permissions if you are targeting AIR SDK 24+
* From now on, this ANE will depend on androidSupport.ane and overrideAir.ane on the Android side

*Jan 20, 2016 - V2.9.2*
* bypassing xCode 7.2 bug causing iOS conflict when compiling with AirSDK 20 without waiting on Adobe or Apple to fix the problem. This is a must have upgrade for your app to make sure you can compile multiple ANEs in your project with AirSDK 20 or greater. https://forums.adobe.com/thread/2055508 https://forums.adobe.com/message/8294948

*Dec 20, 2015 - V2.9.1*
* minor bug fixes

*Nov 03, 2015 - V2.9*
* doitflash devs merged into MyFLashLab Team

*Apr 21, 2015 - V2.2*
* removed android-support-v4.jar dependency in the android side

*Jan 27, 2015 - V2.1*
* added support for iOS 64-bit

*Nov 10, 2014 - V2.0*
* Added online video playback for iOS
* Supports youtube playback

*Nov 04, 2014 - V1.0*
* beginning of the journey!