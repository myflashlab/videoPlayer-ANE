# Video Player ANE (Android+iOS)
video player ANE supported on Android and iOS, lets you play video files in android or iOS players. your videos can be locally availble on your device or they can be online. in the sample codes we have also used our YouTube link parser found here: https://github.com/myflashlab/AS3-youtube-parser-video-link/ and with that you can easily play YouTube videos too.

[find the latest **asdoc** for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/player/package-detail.html)

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

	<!-- dependency ANEs -->
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.core</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.v4</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
</extensions>
```

# Requirements
* Android SDK 15+
* iOS 8.0+
* AIR SDK 30+

# Commercial Version
https://www.myflashlabs.com/product/video-player-ane-adobe-air-native-extension/

[![Video Player ANE](https://www.myflashlabs.com/wp-content/uploads/2015/11/product_adobe-air-ane-extension-video-player-2018-595x738.jpg)](https://www.myflashlabs.com/product/video-player-ane-adobe-air-native-extension/)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  

# Premium Support #
[![Premium Support package](https://www.myflashlabs.com/wp-content/uploads/2016/06/professional-support.jpg)](https://www.myflashlabs.com/product/myflashlabs-support/)
If you are an [active MyFlashLabs club member](https://www.myflashlabs.com/product/myflashlabs-club-membership/), you will have access to our private and secure support ticket system for all our ANEs. Even if you are not a member, you can still receive premium help if you purchase the [premium support package](https://www.myflashlabs.com/product/myflashlabs-support/).