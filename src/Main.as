package 
{
	import ch.futurecom.debug.FucoStats;
	import ch.futurecom.log.FucoLogger;

	import mx.core.Application;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	// set SWF width, height, framerate and bg color
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#ffffff")]
	
	public class Main extends Sprite
	{
		// debugging
		public static var DEBUG:Boolean = true;
		public static var STATS:Boolean = true;
		
		private var pendelA:Sprite;
		private var pendelB:Sprite;
		
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

				if (STATS)
				{
					fucoStats.show();
				}
				else
				{
					fucoStats.hide();
				}
			}
			
			
			
			pendelA = new Sprite();
			pendelB = new Sprite();
			
			this.addChild(pendelA);
			pendelA.addChild(pendelB);
			
			pendelA.graphics.lineStyle(3,0x000000);
			pendelA.graphics.moveTo(0,0);
			pendelA.graphics.lineTo(0,100);
			
			var rA:Sprite = new Sprite();
			pendelA.addChild(rA);
			rA.graphics.beginFill(0x00ffff);
			rA.graphics.drawCircle(0, 0, 10);
			rA.graphics.endFill();

			rA.x = 0;
			rA.y = 100;
			
			pendelB.graphics.lineStyle(3,0x000000);
			pendelB.graphics.moveTo(0,0);
			pendelB.graphics.lineTo(0,100);

			var rB:Sprite = new Sprite();
			pendelB.addChild(rB);
			rB.graphics.beginFill(0xff0000);
			rB.graphics.drawCircle(0, 0, 10);
			rB.graphics.endFill();

			rB.x = 0;
			rB.y = 100;

			pendelA.x = Math.round(stage.stageWidth/2);
			pendelA.y = Math.round(stage.stageHeight/2);
			
			pendelB.x = 0;
			pendelB.y = 100;
			
			pendelA.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			pendelA.rotation += 1;
			pendelB.rotation -= 5;
		}
	}
}
