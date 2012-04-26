/**
 * @class PendulumSystem
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui
{
	import ch.futurecom.log.FucoLogger;
	import ch.futurecom.net.loader.FucoURLLoader;
	import ch.futurecom.utils.PathUtils;
	import ch.zhaw.doppelpendel.event.SystemEvent;
	import ch.zhaw.doppelpendel.event.StageEvent;
	import ch.zhaw.doppelpendel.gui.element.Pendulum;

	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class PendulumSystem extends AssetPendulum
	{
		private var xmlLoader:FucoURLLoader;

		private var xmlData:XMLList;
		private var xmlPendulum:XMLList;

		private var gravity:Number;
		private var density:Number;

		private var arrPendulum:Vector.<Pendulum>;

		private var mcFixpoint:Sprite;

		private var timer:Timer;

		public function PendulumSystem()
		{
			this.visible = false;
			mcFixpoint = this.mc_fixpoint;
			
			//init default system
			var defaultSystemUrl:String = PathUtils.baseURL + "_config/default.idp";
			loadSystem(defaultSystemUrl);
		}

		public function loadSystem(url:String):void
		{
			FucoLogger.debug("PendulumSystem.loadSystem: " + url);

			xmlLoader = new FucoURLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, onSystemLoaded);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onloadSystemError);
			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onloadSystemError);
			xmlLoader.addEventListener(ErrorEvent.ERROR, onloadSystemError);
			xmlLoader.loadURL(url);
		}

		private function onloadSystemError(e:ErrorEvent):void
		{
			cleanSystemLoader();
			FucoLogger.fatal("PendulumSystem.onXMLLoadError. " + e.text);
		}

		private function onSystemLoaded(e:Event):void
		{
			xmlData = xmlLoader.xmlData().system;
			cleanSystemLoader();
			
			setupSystem();
		}

		private function cleanSystemLoader():void
		{
			if (xmlLoader != null)
			{
				xmlLoader.removeEventListener(Event.COMPLETE, onSystemLoaded);
				xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onloadSystemError);
				xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onloadSystemError);
				xmlLoader.removeEventListener(ErrorEvent.ERROR, onloadSystemError);
				xmlLoader = null;
			}
		}

		/* ----------------------------------------------------------------- */

		/**
		 * Sets up the Pendulum System
		 * depending on the Config file
		 */
		private function setupSystem():void
		{
			clearSystem();
			
			// set gravity
			gravity = xmlData.@gravity;
			density = xmlData.@density;

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
				timer = new Timer(1000 / stage.frameRate);
				timer.addEventListener(TimerEvent.TIMER, onRedraw);

				//resize stage and set visible
				stage.dispatchEvent(new StageEvent(StageEvent.STAGERESIZE));
				this.visible = true;
			}
			
			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));
		}

		private function clearSystem():void
		{
			this.visible = false;
			
			// clear timer
			if (timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onRedraw);
				timer = null;
			}

			// clear pendulum
			if (arrPendulum)
			{
				mcFixpoint.removeChild(arrPendulum[0]);
				arrPendulum = null;
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
			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));
		}

		public function stopSystem():void
		{
			timer.stop();
			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));
		}

		public function resetSystem():void
		{
			timer.stop();

			for (var i:int = 0; i < xmlPendulum.length(); i++)
			{
				arrPendulum[i].reset(xmlPendulum[i].@length, xmlPendulum[i].@phi, xmlPendulum[i].@omega);
			}
			
			dispatchEvent(new SystemEvent(SystemEvent.RESET));
		}

		public function updateSystem(e:ErrorEvent):void
		{

		}

		/* ----------------------------------------------------------------- */

		private function onRedraw(e:TimerEvent):void
		{
			arrPendulum[0].pPhi += 15;
			arrPendulum[1].pPhi -= 20.4;

			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));
		}
	}
}
