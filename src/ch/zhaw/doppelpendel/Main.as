package ch.zhaw.doppelpendel
{
	import ch.futurecom.debug.FucoStats;
	import ch.futurecom.log.FucoLogger;
	import ch.futurecom.system.contextmenu.CustomContextMenu;
	import ch.futurecom.utils.PathUtils;
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.StageEvent;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	// set SWF width, height, framerate and bg color
	[SWF(width="1024", height="768", frameRate="40", backgroundColor="#ffffff")]

	public class Main extends Sprite
	{
		// static constants
		public static const VERSION:String = "1.0.0";

		// debugging
		public static var DEBUG:Boolean = true;
		public static var STATS:Boolean = false;

		/* ----------------------------------------------------------------- */
		
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
			
			// create the model
			new Doppelpendel(this);
		}
		
		/* ----------------------------------------------------------------- */
		
		private function onStageResize(event:Event = null):void
		{
			StageUtils.stageWidth = stage.stageWidth;
			StageUtils.stageHeight = stage.stageHeight;

			stage.dispatchEvent(new StageEvent(StageEvent.STAGERESIZE));
		}
	}
}
