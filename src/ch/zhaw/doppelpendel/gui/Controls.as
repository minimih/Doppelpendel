/**
 * @class Controls
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui
{
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.StageEvent;

	import flash.events.Event;
	
	public class Controls extends AssetControls
	{
		
		public function Controls()
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
			this.x = Math.round(StageUtils.stageWidth - this.width) * 0.5;
			this.y = StageUtils.stageHeight - this.height;
		}
		
		/* ----------------------------------------------------------------- */
	
		private function onStageResize(e:Event):void
		{
			setSizeAndPosition();
		}
	}
}
