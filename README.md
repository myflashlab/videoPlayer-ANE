# Video Player ANE V3.2.1 (Android+iOS)
video player ANE supported on Android and iOS, lets you play video files in android or iOS players. your videos can be locally availble on your device or they can be online. in the sample codes we have also used our YouTube link parser found here: https://github.com/myflashlab/AS3-youtube-parser-video-link/ and with that you can easily play YouTube videos too.

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/player/package-detail.html)

[Download demo ANE](https://github.com/myflashlab/videoPlayer-ANE/tree/master/AIR/lib)

# AIR Usage
For the complete AS3 code usage, see the [demo project here](https://github.com/myflashlab/videoPlayer-ANE/blob/master/AIR/src/MainFinal.as).

```actionscript
import com.myflashlab.air.extensions.player.*;

var _ex:VideoPlayer = new VideoPlayer();

// on Android, local videos must be in File.cacheDirectory. on iOS, they can be anywhere.
var vid:File = File.cacheDirectory.resolvePath("exVideoPlayer.mp4");
_ex.play(vid.nativePath, VideoType.LOCAL);

// or play online
_ex.play("https://myflashlabs.com/showcase/Bully_Scholarship_Edition_Trailer.mp4", VideoType.ONLINE);

// you can also play YouTube videos! please see the sample usage code for YouTube in the sample project
```

# AIR .xml manifest
```xml
<!--
FOR ANDROID:
-->
		<uses-sdk android:targetSdkVersion="26"/>
		
		<application>
			<!--
				Change [your-app-id] to your own applicationID but keep
				".provider" at the end. [your-app-id].provider
			-->
			<provider
				android:name="com.myflashlabs.videoPlayer.AneVideoProvider"
				android:authorities="[your-app-id].provider"
				android:exported="false"
				android:grantUriPermissions="true">
				<meta-data
					android:name="android.support.FILE_PROVIDER_PATHS"
					android:resource="@xml/video_player_ane_provider_paths"/>
			</provider>


			<activity>
				<intent-filter>
					<action android:name="android.intent.action.MAIN" />
					<category android:name="android.intent.category.LAUNCHER" />
				</intent-filter>
				<intent-filter>
					<action android:name="android.intent.action.VIEW" />
					<category android:name="android.intent.category.BROWSABLE" />
					<category android:name="android.intent.category.DEFAULT" />
				</intent-filter>
			</activity>
			
		</application>

		
<!--
FOR iOS:
-->
		<!-- Reqiered only if you are trying to load an online video with 'http' address -->
		<key>NSAppTransportSecurity</key>
		<dict>
			<key>NSAllowsArbitraryLoads</key>
			<true/>
		</dict>



<!--
Embedding the ANE:
-->
<extensions>
	<extensionID>com.myflashlab.air.extensions.videoPlayer</extensionID>
	
	<!-- The following dependency ANEs are only required when compiling for Android -->
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
  </extensions>
```

# Requirements
* This ANE is dependent on **androidSupport.ane** and **overrideAir.ane**. Download them from [here](https://github.com/myflashlab/common-dependencies-ANE).
* Android SDK 15 or higher
* iOS 8.0 or higher
* AIR SDK 29+

# Permissions
If you are targeting AIR 24 or higher, you need to [take care of the permissions mannually](http://www.myflashlabs.com/adobe-air-app-permissions-android-ios/). Below are the list of Permissions this ANE might require. (Note: *Necessary Permissions* are those that the ANE will NOT work without them and *Optional Permissions* are those which are needed only if you are using some specific features in the ANE.)

Check out the demo project available at this repository to see how we have used our [PermissionCheck ANE](http://www.myflashlabs.com/product/native-access-permission-check-settings-menu-air-native-extension/) to ask for the permissions.

**Necessary Permissions:**  
none

**Optional Permissions:**  
none

# Commercial Version
http://www.myflashlabs.com/product/video-player-ane-adobe-air-native-extension/

![Video Player ANE](https://www.myflashlabs.com/wp-content/uploads/2015/11/product_adobe-air-ane-extension-video-player-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  

# Changelog
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