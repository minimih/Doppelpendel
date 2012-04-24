/**
 * @class PendulumSystem
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui
{
	import ch.zhaw.doppelpendel.event.PendulumEvent;
	import ch.zhaw.doppelpendel.gui.element.Pendulum;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class PendulumSystem extends AssetPendulum
	{
		private var xmlData:XMLList;
		private var xmlPendulum:XMLList;

		private var gravity:Number;
		private var density:Number;

		private var arrPendulum:Vector.<Pendulum>;

		private var mcFixpoint:Sprite;
		
		private var timer:Timer;
		
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
			// set gravity
			gravity = xmlData.@gravity;
			density = xmlData.@density;

			mcFixpoint = this.mc_fixpoint;

			xmlPendulum = xmlData.pendulum;
			if (xmlPendulum.length() >= 1 && xmlPendulum.length() <= 2)
			{
				arrPendulum = new Vector.<Pendulum>();

				for (var i:int = 0; i < xmlPendulum.length(); i++)
				{
					var currentP:Pendulum = new Pendulum(density, xmlPendulum[i].@length, xmlPendulum[i].@phi, xmlPendulum[i].omega, xmlPendulum[i].@color);
					arrPendulum.push(currentP);

					if (i == 0)
					{
						mcFixpoint.addChild(currentP);
					}
					else
					{
						var parentP:Pendulum = arrPendulum[i - 1];
						parentP.addChild(currentP);
						// set y for parentPendulum
						currentP.setPosition(parentP);
					}
				}

				// setup timer
				timer = new Timer(1000/60);
				timer.addEventListener(TimerEvent.TIMER, onRedraw);
			}
			else
			{
				// not supported
			}
		}
		
		/* ----------------------------------------------------------------- */

		public function getPendulum():Vector.<Pendulum>
		{
			return arrPendulum;
		}

		/* ----------------------------------------------------------------- */

		public function startSystem():void
		{
			timer.start();
		}

		public function stopSystem():void
		{
			timer.stop();
		}

		public function resetSystem():void
		{
			timer.stop();
			
			for (var i:int = 0; i < xmlPendulum.length(); i++)
			{
				arrPendulum[i].reset(xmlPendulum[i].@length, xmlPendulum[i].@phi, xmlPendulum[i].@omega);
			}
		}

		public function updateSystem():void
		{
			
		}

		/* ----------------------------------------------------------------- */

		private function onRedraw(e:TimerEvent):void
		{
			arrPendulum[0].pPhi += 200;
			arrPendulum[1].pPhi += 31;
			
			dispatchEvent(new PendulumEvent(PendulumEvent.UPDATE));
		}
	}
}
