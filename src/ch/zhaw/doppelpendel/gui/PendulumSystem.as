/**
 * @class PendulumSystem
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui
{
	import ch.futurecom.utils.StageUtils;
	import ch.futurecom.log.FucoLogger;
	import ch.futurecom.net.loader.FucoURLLoader;
	import ch.futurecom.utils.PathUtils;
	import ch.zhaw.doppelpendel.event.StageEvent;
	import ch.zhaw.doppelpendel.event.SystemEvent;
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
		private var mcFixpoint:Sprite;

		private var xmlLoader:FucoURLLoader;
		private var xmlData:XMLList;
		private var xmlPendulum:XMLList;

		private var gravity:Number;
		private var density:Number;

		private var arrPendulum:Vector.<Pendulum>;

		private var p1:Pendulum;
		private var p2:Pendulum;

		private var dPhi1:Number;
		private	var dPhi2:Number;

		private var dt:Number;
		private var timer:Timer;

		public function PendulumSystem()
		{
			this.visible = false;
			mcFixpoint = this.mc_fixpoint;

			// delta t
			dt = 1.0 / StageUtils.stage.frameRate;

			// init default system
			var defaultSystemUrl:String = PathUtils.baseURL + "_config/default.idp";
			loadSystem(defaultSystemUrl);
		}

		public function loadSystem(url:String):void
		{
			clearSystem();

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
			// set gravity
			gravity = xmlData.@gravity;
			density = xmlData.@density;

			xmlPendulum = xmlData.pendulum;
			arrPendulum = new Vector.<Pendulum>();

			if (xmlPendulum.length() == 2)
			{
				var currentP:Pendulum;
				
				for (var i:int = 0; i < xmlPendulum.length(); i++)
				{
					if (i == 0)
					{
						currentP = new Pendulum(density, xmlPendulum[i].@length, xmlPendulum[i].@phi, xmlPendulum[i].omega, xmlPendulum[i].@color);
						mcFixpoint.addChild(currentP);
					}
					else
					{
						var parentP:Pendulum = arrPendulum[i - 1];
						
						currentP = new Pendulum(density, xmlPendulum[i].@length, xmlPendulum[i].@phi, xmlPendulum[i].omega, xmlPendulum[i].@color, parentP);
						parentP.addChild(currentP);

						// set y for parentPendulum
						currentP.setPosition(parentP);
					}

					arrPendulum.push(currentP);
				}

				switch(xmlPendulum.length())
				{
					case 1:
						p1 = arrPendulum[0];
						dPhi1 = 0;

						break;
					case 2:
						p1 = arrPendulum[0];
						p2 = arrPendulum[1];

						dPhi1 = 0;
						dPhi2 = 0;
						break;
				}

				// setup timer
				timer = new Timer(dt * 1000);
				timer.addEventListener(TimerEvent.TIMER, onRedraw);

				// resize stage and set visible
				stage.dispatchEvent(new StageEvent(StageEvent.STAGERESIZE));
				this.visible = true;
			}
			else
			{
				// AlertWindow
				// system not supported
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

			dPhi1 = 0;
			dPhi2 = 0;

			dispatchEvent(new SystemEvent(SystemEvent.RESET));
		}

		public function updateSystem(e:ErrorEvent):void
		{

		}

		/* ----------------------------------------------------------------- */

		private function advance():void
		{
			// var theta_new:Number
			// var phi_new:Number;

			dPhi1 += (dt * (
			-(p1.pMass + p2.pMass) * gravity * Math.sin(p1.pPhi) / p1.pLength + p2.pMass * gravity * Math.cos(p1.pPhi - p2.pPhi) * Math.sin(p2.pPhi) / p1.pLength - p2.pMass * Math.pow(dPhi1, 2) * Math.sin(2 * (p1.pPhi - p2.pPhi)) / 2 - p2.pMass * Math.sin(p1.pPhi - p2.pPhi) * Math.pow(dPhi2, 2) * p2.pLength / p1.pLength
			) / (p1.pMass + p2.pMass * Math.pow(Math.sin(p1.pPhi - p2.pPhi), 2)) - p1.pOmega * dPhi1
			);

			dPhi2 += (dt * (
			(p1.pMass + p2.pMass) * gravity * Math.cos(p1.pPhi) * Math.sin(p1.pPhi - p2.pPhi) / p2.pLength + (p1.pMass + p2.pMass) * Math.sin(p1.pPhi - p2.pPhi) * Math.pow(dPhi1, 2) * p1.pLength / p2.pLength + p2.pMass * Math.pow(dPhi2, 2) * Math.sin(2 * (p1.pPhi - p2.pPhi)) / 2
			) / (p1.pMass + p2.pMass * Math.pow(Math.sin(p1.pPhi - p2.pPhi), 2)) - p2.pOmega * dPhi2
			);




		}

		private function modRadian(rad:Number):Number
		{
			while (rad > Math.PI)
			{
				rad -= 2 * Math.PI;
			}
			while (rad <= -Math.PI)
			{
				rad += 2 * Math.PI;
			}
			return rad;
		}

		private function reDraw():void
		{
			p1.pPhi = modRadian(p1.pPhi + dPhi1 * dt);
			p2.pPhi = modRadian(p2.pPhi + dPhi2 * dt);

			p1.updateRotation();
			p2.updateRotation();
			//			
			// p2.x = p1.x + p1.dLength * Math.sin(p1.pPhi);
			// p2.y = p1.y + p1.dLength * Math.cos(p1.pPhi);
		}

		/* ----------------------------------------------------------------- */

		private function onRedraw(e:TimerEvent):void
		{
			// arrPendulum[0].pPhi += 15;
			// arrPendulum[1].pPhi -= 20.4;

			advance();
			reDraw();

			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));
		}
	}
}
