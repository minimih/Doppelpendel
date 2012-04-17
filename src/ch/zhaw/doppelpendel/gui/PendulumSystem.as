/**
 * @class PendulumSystem
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui
{
	import ch.zhaw.doppelpendel.gui.element.Pendulum;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class PendulumSystem extends AssetPendulum
	{
		private var xmlData:XMLList;
		
		private var gravity:Number;
		private var density:Number;
		
		private var arrPendulum:Vector.<Pendulum>;		
		
		private var mcFixpoint:Sprite;
		
		public function PendulumSystem(xml:XMLList)
		{
			xmlData = xml;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			setupSystem();
		}
		
		/**
		 * Sets up the Pendulum System
		 * depending on the Config file
		 */
		private function setupSystem():void
		{
			//set gravity
			gravity = xmlData.@gravity;
			density = xmlData.@density;
			
			mcFixpoint = this.mc_fixpoint;
			
			var xmlPendulum:XMLList = xmlData.pendulum;
			if(xmlPendulum.length() >= 1 && xmlPendulum.length() <= 2){
				
				arrPendulum = new Vector.<Pendulum>();
				
				for (var i : int = 0; i < xmlPendulum.length(); i++) {
					var currentP:Pendulum = new Pendulum(density, xmlPendulum[i].@length, xmlPendulum[i].@phi, xmlPendulum[i].@color);
					arrPendulum.push(currentP);
					
					if(i == 0){
						mcFixpoint.addChild(currentP);
					}else{
						var parentP:Pendulum = arrPendulum[i-1];
						parentP.addChild(currentP);
						//set y for parentPendulum
						currentP.y = parentP.pLength - (2 * parentP.pOffset);
					}
				}
				
				//startTimer
				startTimer();
			}else{
				//not supported
			}
		} 
		
		private function startTimer():void
		{
			var timer:Timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, timerHandler); 
			timer.start();
		}
		
		private function timerHandler(e:TimerEvent):void
		{
			arrPendulum[0].rotation += 10;
			arrPendulum[1].rotation -= 25;
		}
	}
}
