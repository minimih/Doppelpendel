/**
 * @class Controls
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui {
	import com.bit101.components.Label;
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.StageEvent;

	import com.bit101.components.NumericStepper;

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
			
			init();
			
			//add listener
			setSizeAndPosition();
			StageUtils.stage.addEventListener(StageEvent.STAGERESIZE, onStageResize);
		}
		
		private function init():void
		{
			var phi1:NumericStepper = new NumericStepper();
			phi1.labelPrecision = 1;
			phi1.minimum = 0;
			phi1.maximum = 360;
			phi1.step = 1;
			
			phi1.x = 30;
			phi1.y = 37;
			addChild(phi1);

			var phi2:NumericStepper = new NumericStepper();
			phi1.labelPrecision = 1;
			phi1.minimum = 0;
			phi1.maximum = 360;
			phi1.step = 1;
			
			phi2.x = 231;
			phi2.y = 37;
			addChild(phi2);

			var omega1:NumericStepper = new NumericStepper();
			omega1.labelPrecision = 1;
			omega1.minimum = 0;
			omega1.maximum = 360;
			omega1.step = 1;
			
			omega1.x = 422;
			omega1.y = 37;
			addChild(omega1);

			var omega2:NumericStepper = new NumericStepper();
			omega2.labelPrecision = 1;
			omega2.minimum = 0;
			omega2.maximum = 360;
			omega2.step = 1;
			
			omega2.x = 612;
			omega2.y = 37;
			addChild(omega2);
			
			
		}
		
		/* ----------------------------------------------------------------- */
		
		private function setSizeAndPosition():void
		{
			//this.width = StageUtils.stageWidth;
			
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
