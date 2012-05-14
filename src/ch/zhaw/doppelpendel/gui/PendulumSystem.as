/**
 * @class PendulumSystem
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * Contact Information:
 * ZHAW - Zurich University of Applied Sciences
 * School of Engineering
 * Lagerstrasse 41
 * Postfach
 * 8021 Zurich 
 * 
 * Michael Hoehn (mih) - hoehnmic@students.zhaw.ch
 * Stefan Hauenstein (haui) - hauenst@students.zhaw.ch
 * 
 * @author mih
 */
package ch.zhaw.doppelpendel.gui
{
	import ch.futurecom.log.FucoLogger;
	import ch.futurecom.net.loader.FucoURLLoader;
	import ch.futurecom.utils.PathUtils;
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.StageEvent;
	import ch.zhaw.doppelpendel.event.SystemEvent;
	import ch.zhaw.doppelpendel.gui.element.Pendulum;
	import ch.zhaw.doppelpendel.solver.IODE;
	import ch.zhaw.doppelpendel.solver.PendulumSolver;
	import ch.zhaw.doppelpendel.solver.RungeKutta;

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
		private var time
		private var timer:Timer;
		
		private var odeSolver:IODE;

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

			odeSolver = new RungeKutta(new PendulumSolver(p1, p2));
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
			odeSolver.step(dt);
			reDraw();

			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));
		}
	}
}
