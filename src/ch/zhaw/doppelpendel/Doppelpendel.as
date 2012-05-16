/**
 * @class Doppelpendel
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
package ch.zhaw.doppelpendel {
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.ControlEvent;
	import ch.zhaw.doppelpendel.event.MenuEvent;
	import ch.zhaw.doppelpendel.event.StageEvent;
	import ch.zhaw.doppelpendel.event.SystemEvent;
	import ch.zhaw.doppelpendel.gui.Background;
	import ch.zhaw.doppelpendel.gui.Controls;
	import ch.zhaw.doppelpendel.system.PendulumSystem;
	import ch.zhaw.doppelpendel.system.element.Pendulum;
	import flash.events.Event;
	import flash.events.EventDispatcher;


	public class Doppelpendel extends EventDispatcher
	{
		private var _main:Main;

		private var background:Background;
		private var system:PendulumSystem;
		private var controls:Controls;
		
		//private var menuBar:MenuBar;

		/* ---------------------------------------------------------------- */

		public function Doppelpendel(main:Main)
		{
			_main = main;

			// add bg
			background = new Background();
			main.addChild(background);

			// add system
			system = new PendulumSystem();
			main.addChild(system);

			controls = new Controls();
			main.addChild(controls);
			
			//create the menubar
			//menuBar = new MenuBar();
			
			// set listeners
			system.addEventListener(SystemEvent.UPDATE, onUpdateControls);
			system.addEventListener(SystemEvent.RESET, onResetControls);
			
			controls.addEventListener(ControlEvent.START, onStartSystem);
			controls.addEventListener(ControlEvent.STOP, onStopSystem);
			controls.addEventListener(ControlEvent.RESET, onResetSystem);

			controls.addEventListener(ControlEvent.UPDATE, onUpdateSystem);
			
			//menuBar.addEventListener(MenuEvent.LOAD, onLoadFile);

			// init stage resize listener
			onStageResize();
			StageUtils.stage.addEventListener(StageEvent.STAGERESIZE, onStageResize);
		}
		
		/* ---------------------------------------------------------------- */	

		private function onUpdateControls(e:SystemEvent):void
		{
			var arrPendulum:Vector.<Pendulum> = system.getPendulum();
			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				controls.updateControls(i, arrPendulum[i].pPhi, arrPendulum[i].pOmega, arrPendulum[i].pLength, arrPendulum[i].pMass);
			}
		}
		
		private function onResetControls(e:SystemEvent):void
		{
			var arrPendulum:Vector.<Pendulum> = system.getPendulum();
			for (var i:int = 0; i < arrPendulum.length; i++)
			{
				controls.updateControls(i, arrPendulum[i].rPhi, arrPendulum[i].rOmega, arrPendulum[i].rLength, arrPendulum[i].rMass);
			}
		}

		/* ---------------------------------------------------------------- */

		private function onStartSystem(e:Event):void
		{
			system.startSystem();
		}

		private function onStopSystem(e:Event):void
		{
			system.stopSystem();
		}

		private function onResetSystem(e:Event):void
		{
			system.resetSystem();
		}

		private function onUpdateSystem(e:Event):void
		{
			//controls.
			//system.updateSystem();
		}

		/* ---------------------------------------------------------------- */

		private function onLoadFile(e:MenuEvent):void
		{
			var configUrl:String = e.args.file;
			
			controls.resetControls();
			
			system.loadSystem(configUrl);
		}	

		/* ---------------------------------------------------------------- */

		private function onStageResize(event:Event = null):void
		{
			var sw:Number = StageUtils.stage.stageWidth;
			var sh:Number = StageUtils.stage.stageHeight;

			StageUtils.stageWidth = sw;
			StageUtils.stageHeight = sh;

			// calc pos
			system.x = sw * 0.5;
			system.y = (sh - controls.height) * 0.5;
		}

		/* ---------------------------------------------------------------- */

		public function get main():Main {
			return _main;
		}
	}
}
