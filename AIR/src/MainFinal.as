package 
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.events.StatusEvent;
	import flash.text.AntiAliasType;
	import flash.text.AutoCapitalize;
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
	
	import com.myflashlab.air.extensions.nativePermissions.PermissionCheck;
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
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 11/4/2014 3:01 PM
	 */
	public class MainFinal extends Sprite 
	{
		private var _ex:VideoPlayer;
		private var _exPermissions:PermissionCheck = new PermissionCheck();
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
			
			checkPermissions();
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
		
		private function checkPermissions():void
		{
			// first you need to make sure you have access to the Strorage if you are on Android?
			var permissionState:int = _exPermissions.check(PermissionCheck.SOURCE_STORAGE);
			
			if (permissionState == PermissionCheck.PERMISSION_UNKNOWN || permissionState == PermissionCheck.PERMISSION_DENIED)
			{
				_exPermissions.request(PermissionCheck.SOURCE_STORAGE, onRequestResult);
			}
			else
			{
				init();
			}
			
			function onRequestResult($state:int):void
			{
				if ($state != PermissionCheck.PERMISSION_GRANTED)
				{
					C.log("You did not allow the app the required permissions!");
				}
				else
				{
					init();
				}
			}
		}
		
		private function init():void
		{
			// initialize the extension
			_ex = new VideoPlayer();
			
			// copy test video to sdcard
			var src:File = File.applicationDirectory.resolvePath("movie01.mp4");
			var dis:File = File.documentsDirectory.resolvePath("exVideoPlayer.mp4");
			if(!dis.exists) src.copyTo(dis);
			
			// ----------------------
			var btn1:MySprite = createBtn("play on sdcard");
			btn1.addEventListener(MouseEvent.CLICK, toPlayVideoIntentOnSdcard);
			_list.add(btn1);
			
			function toPlayVideoIntentOnSdcard(e:MouseEvent):void
			{
				var address:String = dis.nativePath;
				_ex.play(address, com.myflashlab.air.extensions.player.VideoType.ON_SD_CARD);
			}
			
			// ----------------------
			var btn2:MySprite = createBtn("play online");
			btn2.addEventListener(MouseEvent.CLICK, toPlayVideoIntentOnline);
			_list.add(btn2);
			
			function toPlayVideoIntentOnline(e:MouseEvent):void
			{
				var address:String = "http://myflashlabs.com/showcase/Bully_Scholarship_Edition_Trailer.mp4";
				_ex.play(address, com.myflashlab.air.extensions.player.VideoType.ON_LINE);
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
				
				var currVideoData:URLVariables;
				var chosenVideo:String;
				for (var i:int = 0; i < _ytParser.videoFormats.length; i++) 
				{
					currVideoData = _ytParser.videoFormats[i];
					if (currVideoData.type == com.doitflash.remote.youtube.VideoType.VIDEO_MP4 && currVideoData.quality == VideoQuality.MEDIUM)
					{
						chosenVideo = currVideoData.url;
						break;
					}
				}
				
				// optionally you may validate if the url is valid:
				//_ytParser.addEventListener(YouTubeLinkParserEvent.VIDEO_HEADER_RECEIVED, onHeadersReceived);
				//_ytParser.addEventListener(YouTubeLinkParserEvent.VIDEO_HEADER_ERROR, onHeadersError);
				//_ytParser.getHeaders(chosenVideo);
				
				_ex.play(chosenVideo, com.myflashlab.air.extensions.player.VideoType.ON_LINE);
			}
			
			// ----------------------
			
			
			
			// ----------------------
			
			
			
			// ----------------------
			
			
			
			// ----------------------
			
			
			onResize();
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