# Video Player ANE (Android+iOS)
video player ANE supported on Android and iOS 64-bit let's you play video files in android or iOS players. your videos can be locally availble on your device or they can be online. in the sample codes we have also used our YouTube link parser found here: https://github.com/myflashlab/AS3-youtube-parser-video-link/ and with that you can easily play YouTube videos too.

checkout here for the commercial version: http://myappsnippet.com/video-player-native-extension/
you may like to see the ANE in action? check this out: https://github.com/myflashlab/videoPlayer-ANE/raw/master/FD/dist/exVideoPlayer-demo.apk

**NOTICE: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.**

![Video Player ANE](http://myappsnippet.com/wp-content/uploads/2014/11/video-player-adobe-air-extension_preview.jpg)

# AS3 API:
```actionscript
import com.doitflash.air.extensions.player.VideoPlayer;
import com.doitflash.air.extensions.player.VideoType;

var _ex:VideoPlayer = new VideoPlayer();

// play from sdcard
var vid:File = File.documentsDirectory.resolvePath("exVideoPlayer.mp4");
_ex.play(vid.nativePath, VideoType.ON_SD_CARD); // in demo ANE, this method works only if you have hit the "ok" button in the demo dialog.

// or play online
_ex.play("http://myflashlab.com/showcase/Bully_Scholarship_Edition_Trailer.mp4", VideoType.ON_LINE);

// you can also play YouTube videos! please see the sample usage code for YouTube in the sample FlashDevelop project
```

This extension does not require any special setup in the air manifest .xml file