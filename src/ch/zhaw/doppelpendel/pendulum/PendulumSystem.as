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
package ch.zhaw.doppelpendel.pendulum
{
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.StageEvent;
	import ch.zhaw.doppelpendel.event.SystemEvent;
	import ch.zhaw.doppelpendel.pendulum.element.Pendulum;
	import ch.zhaw.doppelpendel.solver.IODE;
	import ch.zhaw.doppelpendel.solver.IODESolver;
	import ch.zhaw.doppelpendel.solver.PendulumSolver;
	import ch.zhaw.doppelpendel.solver.RungeKutta;
	import ch.zhaw.doppelpendel.utils.Geom;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;


	public class PendulumSystem extends AssetPendulum implements ISystem
	{
		private var marginTop:Number;
		private var marginBottom:Number;

		private var systemSize:int;

		private var mcFixpoint:Sprite;

		private var xmlPendulum:XMLList;

		private var gravity:Number;
		private var density:Number;

		private var arrPendulum:Vector.<Pendulum>;
		
		private var dt:Number;
		private var timer:Timer;

		private var pendulumSolver:IODESolver;
		private var odeSolver:IODE;

		public function PendulumSystem(systemSize:int)
		{
			this.systemSize = systemSize;

			this.visible = false;

			mcFixpoint = this.mc_fixpoint;

			// delta t
			dt = 1.0 / StageUtils.stage.frameRate;

			marginTop = 0;
			marginBottom = 0;

			// add listener
			setSizeAndPosition();
			StageUtils.stage.addEventListener(StageEvent.STAGERESIZE, onStageResize);
		}

		/* ----------------------------------------------------------------- */

		/**
		 * Sets the margin top and bottom for the Pendulum System
		 * 
		 * @param marginTop
		 * @param marginBottom
		 */
		public function setMargin(marginTop:Number, marginBottom:Number):void
		{
			this.marginTop = marginTop;
			this.marginBottom = marginBottom;

			setSizeAndPosition();
		}

		/* ----------------------------------------------------------------- */

		/**
		 * Sets up the Pendulum System
		 * depending on the config xml
		 * 
		 * @param xml pendulum config xml
		 */
		public function setupSystem(xml:XML):void
		{
			clearSystem();

			// set gravity
			gravity = xml.system.@gravity;
			density = xml.system.@density;

			xmlPendulum = xml.system.pendulum;

			if (xmlPendulum.length() != systemSize)
			{
				// system not supported
				return;
			}

			arrPendulum = new Vector.<Pendulum>(systemSize, true);
			var currentP:Pendulum;

			for (var i:int = 0; i < systemSize; i++)
			{
				if (i == 0)
				{
					currentP = new Pendulum(density, xmlPendulum[i].@length, xmlPendulum[i].@phi, xmlPendulum[i].@omega, xmlPendulum[i].@color);
					mcFixpoint.addChild(currentP);
				}
				else
				{
					var parentP:Pendulum = arrPendulum[i - 1];

					currentP = new Pendulum(density, xmlPendulum[i].@length, xmlPendulum[i].@phi, xmlPendulum[i].@omega, xmlPendulum[i].@color, parentP);
					mcFixpoint.addChild(currentP);
				}

				arrPendulum[i] = currentP;
			}

			// setup timer
			timer = new Timer(dt * 1000);
			timer.addEventListener(TimerEvent.TIMER, onRedraw);

			// resize stage and set visible
			setSizeAndPosition();
			this.visible = true;

			// enable mouse drag and drop
			setupMouseControl();
			enableMouseControl();

			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));

			// pendulumsolver needs exactly 2 pendulum's
			pendulumSolver = new PendulumSolver(arrPendulum[0], arrPendulum[1], gravity);
			odeSolver = new RungeKutta(pendulumSolver);
		}

		/**
		 * Clears the Pendulum System.
		 * removes all elements and stops the timer
		 */
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
				for (var i:int = 0; i < arrPendulum.length; i++)
				{
					mcFixpoint.removeChild(arrPendulum[i]);
				}
				arrPendulum = null;
			}

			odeSolver = null;
			pendulumSolver = null;
		}

		/* ----------------------------------------------------------------- */

		public function startSystem():void
		{
			// disable mouse drag and drop
			disableMouseControl();

			pendulumSolver.reset();
			timer.start();

			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));
		}

		public function stopSystem():void
		{
			timer.stop();

			// enable mouse drag and drop
			enableMouseControl();

			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));
		}

		public function resetSystem():void
		{
			timer.stop();

			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				arrPendulum[i].reset(xmlPendulum[i].@length, xmlPendulum[i].@phi, xmlPendulum[i].@omega);
			}

			setSizeAndPosition();

			// enable mouse drag and drop
			enableMouseControl();

			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));
		}

		public function updateSystem():void
		{
			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				arrPendulum[i].update();
			}

			setSizeAndPosition();
			
			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));
		}

		public function getSystemSize():Number
		{
			var sSize:Number = 0;
			try
			{
				var pLen:Number = 0;
				for (var i:int = 0; i < arrPendulum.length; i++)
				{
					pLen += arrPendulum[i].dLength;
				}
				sSize = 2 * pLen;
			}
			catch(error:Error)
			{
				// nothing
			}
			return sSize;
		}

		/* ----------------------------------------------------------------- */

		public function getValuesAsArray():Array
		{
			var val:Array = new Array();
			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				val.push(arrPendulum[i].getValues());
			}
			
			return val;
		}
		
		public function setPhiAsArray(val:Array):void
		{
			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				arrPendulum[i].pPhi = Geom.degToRad(val[i][0]);
			}
		}

		public function setOmegaAsArray(val:Array):void
		{
			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				arrPendulum[i].pOmega = val[i][1];
			}
		}
		
		public function setLengthAsArray(val:Array):void
		{
			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				arrPendulum[i].pLength = val[i][2];
			}
		}
		
		public function setMassAsArray(val:Array):void
		{
			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				arrPendulum[i].pMass = val[i][3];
			}
		}

		/* ----------------------------------------------------------------- */

		/**
		 * setup of the drag and drop control for the pendulum 
		 */
		private function setupMouseControl():void
		{
			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				arrPendulum[i].setMouseControl(onMouseControlUpdate);
			}
		}

		/**
		 * enables drag and drop for the pendulum 
		 */
		private function enableMouseControl():void
		{
			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				arrPendulum[i].enableMouseControl();
			}
		}

		/**
		 * disables drag and drop for the pendulum 
		 */
		private function disableMouseControl():void
		{
			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				arrPendulum[i].disableMouseControl();
			}
		}

		private function onMouseControlUpdate(p:Pendulum):void
		{
			var pendulumPoint:Point = new Point(p.x, p.y);
			pendulumPoint = localToGlobal(pendulumPoint);

			var mousePoint:Point = new Point(this.mouseX, this.mouseY);
			mousePoint = localToGlobal(mousePoint);

			p.pPhi = (2 * Math.PI + Math.atan2(mousePoint.x - pendulumPoint.x, mousePoint.y - pendulumPoint.y)) % (2 * Math.PI);

			updateRotation();

			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));
		}

		/* ----------------------------------------------------------------- */

		private function onRedraw(e:TimerEvent):void
		{
			odeSolver.step(dt);
			pendulumSolver.update();

			updateRotation();

			dispatchEvent(new SystemEvent(SystemEvent.UPDATE));
		}

		private function updateRotation():void
		{
			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				arrPendulum[i].updateRotation();
			}
		}

		/* ----------------------------------------------------------------- */

		/**
		 * calculates the size of the system and scales it to fit in the stage
		 */
		private function setSizeAndPosition():void
		{
			var sw:int = StageUtils.stageWidth;
			var sh:int = (StageUtils.stageHeight - marginTop - marginBottom);

			// reset scale
			this.scaleX = this.scaleY = 1;

			// set scale
			var stageSize:int = Math.min(sw, sh);
			if (getSystemSize() > stageSize)
			{
				this.scaleX = this.scaleY = (stageSize / getSystemSize());
			}

			// set pos
			this.x = sw * 0.5;
			this.y = marginTop + (sh * 0.5);
		}

		private function onStageResize(e:Event):void
		{
			setSizeAndPosition();
		}
	}
}
