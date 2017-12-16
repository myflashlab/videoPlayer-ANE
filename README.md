# Video Player ANE V3.0.3 (Android+iOS)
video player ANE supported on Android and iOS 64-bit lets you play video files in android or iOS players. your videos can be locally availble on your device or they can be online. in the sample codes we have also used our YouTube link parser found here: https://github.com/myflashlab/AS3-youtube-parser-video-link/ and with that you can easily play YouTube videos too.

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/player/package-detail.html)

[Download demo ANE](https://github.com/myflashlab/videoPlayer-ANE/tree/master/AIR/lib)

# AIR Usage
For the complete AS3 code usage, see the [demo project here](https://github.com/myflashlab/videoPlayer-ANE/blob/masterAIR/src/MainFinal.as).

```actionscript
import com.myflashlab.air.extensions.player.VideoPlayer;
import com.myflashlab.air.extensions.player.VideoType;

var _ex:VideoPlayer = new VideoPlayer();

// play from documentsDirectory
var vid:File = File.documentsDirectory.resolvePath("exVideoPlayer.mp4");
_ex.play(vid.nativePath, VideoType.ON_SD_CARD); // in demo ANE, this method works only if you have hit the "ok" button in the demo dialog.

// or play online
_ex.play("http://myflashlabs.com/showcase/Bully_Scholarship_Edition_Trailer.mp4", VideoType.ON_LINE);

// you can also play YouTube videos! please see the sample usage code for YouTube in the sample FlashDevelop project
```

# AIR .xml manifest
```xml
<!--
FOR ANDROID:
-->
		<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

		<!--The new Permission thing on Android works ONLY if you are targetting Android SDK 23 or higher-->
		<uses-sdk android:targetSdkVersion="23"/>
		
		

		
<!--
FOR iOS:
-->
		<!-- Reqiered if you are trying to load an online video with 'http' address -->
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
	
	<!-- Required if you are targeting AIR 24+ and have to take care of Permissions mannually -->
	<extensionID>com.myflashlab.air.extensions.permissionCheck</extensionID>
	
	<!-- The following dependency ANEs are only required when compiling for Android -->
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
  </extensions>
```

# Requirements
* This ANE is dependent on **androidSupport.ane** and **overrideAir.ane**. Download them from [here](https://github.com/myflashlab/common-dependencies-ANE).
* Android SDK 15 or higher
* iOS 8.0 or higher

# Permissions
If you are targeting AIR 24 or higher, you need to [take care of the permissions mannually](http://www.myflashlabs.com/adobe-air-app-permissions-android-ios/). Below are the list of Permissions this ANE might require. (Note: *Necessary Permissions* are those that the ANE will NOT work without them and *Optional Permissions* are those which are needed only if you are using some specific features in the ANE.)

Check out the demo project available at this repository to see how we have used our [PermissionCheck ANE](http://www.myflashlabs.com/product/native-access-permission-check-settings-menu-air-native-extension/) to ask for the permissions.

**Necessary Permissions:**  
none

**Optional Permissions:**  

1. PermissionCheck.SOURCE_STORAGE

# Commercial Version
http://www.myflashlabs.com/product/video-player-ane-adobe-air-native-extension/

![Video Player ANE](http://www.myflashlabs.com/wp-content/uploads/2015/11/product_adobe-air-ane-extension-video-player-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  

# Changelog
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