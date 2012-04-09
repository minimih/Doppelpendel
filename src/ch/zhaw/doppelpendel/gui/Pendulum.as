/**
 * @class Pendulum
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui
{
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.StageEvent;

	import flash.events.Event;
	
	public class Pendulum extends AssetPendulum
	{
//		private var pendelA:Sprite;
//		private var pendelB:Sprite;
		
		public function Pendulum()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	
			//add listener
			setPosition();
			StageUtils.stage.addEventListener(StageEvent.STAGERESIZE, onStageResize);
		}
		
		
		// pendelA = new Sprite();
			// pendelB = new Sprite();
			//			
			// this.addChild(pendelA);
			// pendelA.addChild(pendelB);
			//			
			// pendelA.graphics.lineStyle(3,0x000000);
			// pendelA.graphics.moveTo(0,0);
			// pendelA.graphics.lineTo(0,100);
			//			
			// var rA:Sprite = new Sprite();
			// pendelA.addChild(rA);
			// rA.graphics.beginFill(0x00ffff);
			// rA.graphics.drawCircle(0, 0, 10);
			// rA.graphics.endFill();
			//
			// rA.x = 0;
			// rA.y = 100;
			//			
			// pendelB.graphics.lineStyle(3,0x000000);
			// pendelB.graphics.moveTo(0,0);
			// pendelB.graphics.lineTo(0,100);
			//
			// var rB:Sprite = new Sprite();
			// pendelB.addChild(rB);
			// rB.graphics.beginFill(0xff0000);
			// rB.graphics.drawCircle(0, 0, 10);
			// rB.graphics.endFill();
			//
			// rB.x = 0;
			// rB.y = 100;
			//
			// pendelA.x = Math.round(stage.stageWidth/2);
			// pendelA.y = Math.round(stage.stageHeight/2);
			//			
			// pendelB.x = 0;
			// pendelB.y = 100;
			//			
			// pendelA.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
//		private function onEnterFrame(e:Event):void
//		{
//			pendelA.rotation += 1;
//			pendelB.rotation -= 5;
//		}
		
		/* ----------------------------------------------------------------- */
		
		private function setPosition():void
		{
			this.x = Math.round(StageUtils.stageWidth * 0.5);
			this.y = Math.round(StageUtils.stageHeight * 0.25) ;
		}
		
		/* ----------------------------------------------------------------- */
	
		private function onStageResize(e:Event):void
		{
			setPosition();
		}
	}
}
