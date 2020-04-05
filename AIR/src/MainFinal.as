package 
{
	import com.myflashlab.air.extensions.dependency.OverrideAir;
	import com.myflashlab.air.extensions.player.VideoPlayerEvent;

	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.net.URLVariables;
	
	import com.myflashlab.air.extensions.player.VideoPlayer;
	import com.myflashlab.air.extensions.player.VideoType;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.starling.utils.list.List;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Easing;
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	
	import com.doitflash.remote.youtube.YouTubeLinkParser;
	import com.doitflash.remote.youtube.YouTubeLinkParserEvent;
	import com.doitflash.remote.youtube.VideoType;
	import com.doitflash.remote.youtube.VideoQuality;
	
	import com.luaye.console.C;

import flash.utils.setTimeout;

/**
	 * ...
	 * @author Hadi Tavakoli - 11/4/2014 3:01 PM
	 */
	public class MainFinal extends Sprite 
	{
		private var _ex:VideoPlayer;
		private var _ytParser:YouTubeLinkParser;
		
		private const BTN_WIDTH:Number = 150;
		private const BTN_HEIGHT:Number = 60;
		private const BTN_SPACE:Number = 2;
		private var _txt:TextField;
		private var _body:Sprite;
		private var _list:List;
		private var _numRows:int = 1;
		
		public function MainFinal():void 
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			
			stage.addEventListener(Event.RESIZE, onResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			C.startOnStage(this, "`");
			C.commandLine = false;
			C.commandLineAllowed = false;
			C.x = 100;
			C.width = 500;
			C.height = 250;
			C.strongRef = true;
			C.visible = true;
			C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
			
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = false;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>VideoPlayer Extension V"+ VideoPlayer.VERSION +" (iOS + Android)</b></font>";
			_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			this.addChild(_txt);
			
			_body = new Sprite();
			this.addChild(_body);
			
			_list = new List();
			_list.holder = _body;
			_list.itemsHolder = new Sprite();
			_list.orientation = Orientation.VERTICAL;
			_list.hDirection = Direction.LEFT_TO_RIGHT;
			_list.vDirection = Direction.TOP_TO_BOTTOM;
			_list.space = BTN_SPACE;
			
			init();
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		private function handleActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function handleKeys(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
            {
				e.preventDefault();
				NativeApplication.nativeApplication.exit();
            }
		}
		
		private function onResize(e:*=null):void
		{
			if (_txt)
			{
				_txt.y = 150 * (1 / DeviceInfo.dpiScaleMultiplier);
				_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				
				C.x = 0;
				C.y = _txt.y + _txt.height + 0;
				C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				C.height = 300 * (1 / DeviceInfo.dpiScaleMultiplier);
			}
			
			if (_list)
			{
				_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
				_list.row = _numRows;
				_list.itemArrange();
			}
			
			if (_body)
			{
				_body.y = stage.stageHeight - _body.height;
			}
		}
		
		private function init():void
		{
			// Remove OverrideAir debugger in production builds
			OverrideAir.enableDebugger(function ($ane:String, $class:String, $msg:String):void
			{
				trace($ane+" ("+$class+") "+$msg);
			});
			
			// initialize the extension
			_ex = new VideoPlayer();
			
			/*
				The following listener works on iOS only.
				
				On Android, the ANE will check available players on your device and lets you play your content
				on each one you like. This means another third-party app will take care of playing your video.
				It is your job to check when your app gets activated when users cancels the video playback on
				the other app. You can do this with "Event.ACTIVATE" listener.
				
				On iOS, we are using the built-in AVPlayer class which means the video plays inside your app.
				Because of this, unlike Android, you will not receive any Event.ACTIVATE event simply because
				you have not left the app to begin with. To fix this problem on iOS, we will do this on the ANE
				side and as soon as the video player is dismissed, you will receive the event via the following
				listener: VideoPlayerEvent.DISMISSED
			*/
			if(OverrideAir.os == OverrideAir.IOS) _ex.addEventListener(VideoPlayerEvent.DISMISSED, onDismissed);
			
			// on Android, local videos must be in File.cacheDirectory. on iOS, they can be anywhere.
			var src:File = File.applicationDirectory.resolvePath("movie01.mp4");
			var dis:File = File.cacheDirectory.resolvePath("exVideoPlayer.mp4");
			if(!dis.exists) src.copyTo(dis);
			
			// ----------------------
			var btn1:MySprite = createBtn("play on File.cacheDirectory");
			btn1.addEventListener(MouseEvent.CLICK, playVideoOnCacheDirectory);
			_list.add(btn1);
			
			function playVideoOnCacheDirectory(e:MouseEvent):void
			{
				trace(dis.nativePath);
				_ex.play(dis.nativePath, com.myflashlab.air.extensions.player.VideoType.LOCAL);
			}
			
			// ----------------------
			var btn2:MySprite = createBtn("play online");
			btn2.addEventListener(MouseEvent.CLICK, toPlayVideoIntentOnline);
			_list.add(btn2);
			
			function toPlayVideoIntentOnline(e:MouseEvent):void
			{
				var address:String = "https://myflashlabs.com/showcase/Bully_Scholarship_Edition_Trailer.mp4";
				_ex.play(address, com.myflashlab.air.extensions.player.VideoType.ONLINE);
			}
			// ----------------------
			
			var btn3:MySprite = createBtn("play from YouTube");
			btn3.addEventListener(MouseEvent.CLICK, toPlayVideoIntentYouTube);
			_list.add(btn3);
			
			function toPlayVideoIntentYouTube(e:MouseEvent):void
			{
				C.log("connecting to youtube...");
				
				if(!_ytParser) _ytParser = new YouTubeLinkParser();
				_ytParser.addEventListener(YouTubeLinkParserEvent.COMPLETE, onComplete);
				_ytParser.addEventListener(YouTubeLinkParserEvent.ERROR, onError);
				_ytParser.parse("https://www.youtube.com/watch?v=QowwaefoCec");
				
			}
			
			function onError(e:YouTubeLinkParserEvent):void
			{
				_ytParser.removeEventListener(YouTubeLinkParserEvent.COMPLETE, onComplete);
				_ytParser.removeEventListener(YouTubeLinkParserEvent.ERROR, onError);
				
				C.log("Error: " + e.param.msg);
			}
			
			function onComplete(e:YouTubeLinkParserEvent):void
			{
				_ytParser.removeEventListener(YouTubeLinkParserEvent.COMPLETE, onComplete);
				_ytParser.removeEventListener(YouTubeLinkParserEvent.ERROR, onError);
				
				C.log("youTube parse completed...");
				C.log("video thumb: " + _ytParser.thumb);
				C.log("video title: " + _ytParser.title);
				C.log("possible found videos: " + _ytParser.videoFormats.length);
				
				C.log("you can only access youtube public videos... no age restriction for example!");
				C.log("some video formats may be null so you should check their availablily...");
				C.log("to make your job easier, I built another method called getHeaders() which will load video headers for you! you can know the video size using these header information :) ")
				
				// let's find the VideoType.VIDEO_MP4 video format in VideoQuality.MEDIUM for this video
				// NOTICE: you should find your own way of selecting a video format! as different videos may not have all formats or qualities available!
				
				var chosenVideo:String;
				for (var i:int = 0; i < _ytParser.videoFormats.length; i++) 
				{
					var currVideoData:Object = _ytParser.videoFormats[i];
					if (currVideoData.mimeType.indexOf(com.doitflash.remote.youtube.VideoType.VIDEO_MP4) > -1 && currVideoData.quality == VideoQuality.MEDIUM)
					{
						chosenVideo = currVideoData.url;
						break;
					}
				}
				
				// optionally you may validate if the url is valid:
				//_ytParser.addEventListener(YouTubeLinkParserEvent.VIDEO_HEADER_RECEIVED, onHeadersReceived);
				//_ytParser.addEventListener(YouTubeLinkParserEvent.VIDEO_HEADER_ERROR, onHeadersError);
				//_ytParser.getHeaders(chosenVideo);
				
				_ex.play(chosenVideo, com.myflashlab.air.extensions.player.VideoType.ONLINE);
			}
			
			// ----------------------
			
			
			
			// ----------------------
			
			
			
			// ----------------------
			
			
			
			// ----------------------
			
			
			onResize();
		}
		
		private function onDismissed(e:VideoPlayerEvent):void
		{
			trace("iOS video library dismissed!");
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function createBtn($str:String):MySprite
		{
			var sp:MySprite = new MySprite();
			sp.addEventListener(MouseEvent.MOUSE_OVER,  onOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT,  onOut);
			sp.addEventListener(MouseEvent.CLICK,  onOut);
			sp.bgAlpha = 1;
			sp.bgColor = 0xDFE4FF;
			sp.drawBg();
			sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
			sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
			
			function onOver(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xFFDB48;
				sp.drawBg();
			}
			
			function onOut(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xDFE4FF;
				sp.drawBg();
			}
			
			var format:TextFormat = new TextFormat("Arimo", 16, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
			
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.mouseEnabled = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
			txt.defaultTextFormat = format;
			txt.text = $str;
			
			txt.y = sp.height - txt.height >> 1;
			sp.addChild(txt);
			
			return sp;
		}
	}
	
}