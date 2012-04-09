/**
 * @class Background
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui
{
	import ch.futurecom.log.FucoLogger;
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.StageEvent;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Background extends Sprite
	{
		private var mcBg:Sprite;
		
		public function Background()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	
			//add listener
			setSizeAndPosition();
			StageUtils.stage.addEventListener(StageEvent.STAGERESIZE, onStageResize);
		}
		
		/* ----------------------------------------------------------------- */
		
		private function setSizeAndPosition():void
		{
			FucoLogger.debug(StageUtils.stageWidth);
			
			var bmp:BitmapData = new LibBg();
			
			var bgWidth:int = bmp.width * Math.ceil(StageUtils.stageWidth / bmp.width);
			var bgHeight:int = bmp.height * Math.ceil(StageUtils.stageHeight / bmp.height);
			
			FucoLogger.debug(bgWidth + " : " + bgHeight);
			
			mcBg = new Sprite();
			mcBg.graphics.beginBitmapFill(bmp);
			mcBg.graphics.drawRect(0, 0, bgWidth, bgHeight);
            mcBg.graphics.endFill();
			
			this.addChild(mcBg);
			
			this.x = Math.round(Math.min(0,(StageUtils.stageWidth - mcBg.width) * 0.5));
			this.y = Math.round(Math.min(0,(StageUtils.stageHeight - mcBg.height) * 0.5));
		}
		
		/* ----------------------------------------------------------------- */
	
		private function onStageResize(e:Event):void
		{
			setSizeAndPosition();
		}
	}
}