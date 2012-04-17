package ch.zhaw.doppelpendel
{
	import ch.futurecom.debug.FucoStats;
	import ch.futurecom.log.FucoLogger;
	import ch.futurecom.net.loader.FucoURLLoader;
	import ch.futurecom.system.contextmenu.CustomContextMenu;
	import ch.futurecom.utils.PathUtils;
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.StageEvent;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	// set SWF width, height, framerate and bg color
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#ffffff")]

	public class Main extends Sprite
	{
		// static constants
		public static const VERSION:String = "1.0.0";

		// debugging
		public static var DEBUG:Boolean = true;
		public static var STATS:Boolean = true;

		/* ----------------------------------------------------------------- */
		
		// imported values
		private var theParameters:Object;
		private var xmlURL:String;

		// xml stuff
		private var _xml:XML;
		private var xmlLoader:FucoURLLoader;
		
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			// do the stage tango
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// set fc context menu
			new CustomContextMenu(this);

			// get flash params
			theParameters = stage.loaderInfo.parameters;
			xmlURL = theParameters["xmlURL"];

			if (xmlURL == null)
			{
				xmlURL = "";
			}

			// get base
			var theRootClipURL:String = stage.loaderInfo.url;
			var tmpArr:Array = theRootClipURL.split("\\");
			var tmpBaseURL:String = tmpArr.join("/");

			PathUtils.baseURL = tmpBaseURL.substring(0, tmpBaseURL.lastIndexOf("/")) + "/".toLowerCase();
			
			// set debuggers
			if (Main.DEBUG)
			{
				// fuco logger
				FucoLogger.USE_MONSTER = true;
				FucoLogger.USE_XRAY = true;

				FucoLogger.DO_TRACE = false;
				FucoLogger.DO_LOG = true;
				FucoLogger.DO_UNPACK_OBJECTS = true;

				FucoLogger.getInstance(this);

				var fucoStats:FucoStats = new FucoStats();
				stage.addChild(fucoStats);
				fucoStats.alignToStage = StageAlign.TOP_RIGHT;
				fucoStats.addCustomField("Version", Main.VERSION);

				if (STATS)
				{
					fucoStats.show();
				}
				else
				{
					fucoStats.hide();
				}
			}

			// set stage
			StageUtils.stage = stage;
			
			// init stage resize listener
			onStageResize();
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			// loadXML
			loadXML();
		}
		
		/* ----------------------------------------------------------------- */

		private function loadXML():void
		{
			if (Main.DEBUG && xmlURL == "")
			{
				xmlURL = PathUtils.baseURL + "_xml/config.xml";
			}
			FucoLogger.debug("Main.loadXML: " + xmlURL);

			xmlLoader = new FucoURLLoader();
			xmlLoader.disableCache = true;
			xmlLoader.addEventListener(Event.COMPLETE, onXMLLoaded);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onXMLLoadError);
			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onXMLLoadError);
			xmlLoader.addEventListener(ErrorEvent.ERROR, onXMLLoadError);
			xmlLoader.loadURL(xmlURL);
		}

		private function onXMLLoadError(e:ErrorEvent):void
		{
			cleanXMLLoader();
			var msg:String = "loading of xml failed. fatal. exiting.....";
			FucoLogger.fatal("Main.onXMLLoadError. " + msg);
		}

		private function onXMLLoaded(e:Event):void
		{
			_xml = xmlLoader.xmlData();
			cleanXMLLoader();
			
			start();
		}

		/* ---------------------------------------------------------------- */

		private function cleanXMLLoader():void
		{
			if (xmlLoader != null)
			{
				xmlLoader.removeEventListener(Event.COMPLETE, onXMLLoaded);
				xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onXMLLoadError);
				xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onXMLLoadError);
				xmlLoader.removeEventListener(ErrorEvent.ERROR, onXMLLoadError);
				xmlLoader = null;
			}
		}

		/* ----------------------------------------------------------------- */

		private function start():void
		{
			FucoLogger.debug("Main.start");

			// call the model
			var model:Doppelpendel = Doppelpendel.getInstance();
			model.init(this);
		}
		
		/* ----------------------------------------------------------------- */
		
		private function onStageResize(event:Event = null):void
		{
			StageUtils.stageWidth = stage.stageWidth;
			StageUtils.stageHeight = stage.stageHeight;

			stage.dispatchEvent(new StageEvent(StageEvent.STAGERESIZE));
		}
		
		/* ----------------------------------------------------------------- */

		public function get xml():XML {
			return _xml;
		}
	}
}
