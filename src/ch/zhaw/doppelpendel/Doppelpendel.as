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
package ch.zhaw.doppelpendel
{
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.data.SystemData;
	import ch.zhaw.doppelpendel.event.ControlEvent;
	import ch.zhaw.doppelpendel.event.MenuEvent;
	import ch.zhaw.doppelpendel.event.SystemEvent;
	import ch.zhaw.doppelpendel.gui.Background;
	import ch.zhaw.doppelpendel.gui.MenuBar;
	import ch.zhaw.doppelpendel.pendulum.PendulumControl;
	import ch.zhaw.doppelpendel.pendulum.PendulumSystem;

	import flash.events.EventDispatcher;

	public class Doppelpendel extends EventDispatcher
	{
		private var _main:Main;

		// set pendulum to 2
		private const pendulumSystemSize:int = 2;

		private var background:Background;

		private var system:PendulumSystem;
		private var control:PendulumControl;

		private var menuBar:MenuBar;

		/* ---------------------------------------------------------------- */

		public function Doppelpendel(main:Main)
		{
			_main = main;

			// add bg
			background = new Background();
			main.addChild(background);

			// add system
			system = new PendulumSystem(pendulumSystemSize);
			main.addChild(system);

			control = new PendulumControl(pendulumSystemSize);
			main.addChild(control);

			// create the menubar
			menuBar = new MenuBar();
			main.addChild(menuBar);

			// repos system
			system.setMargin(menuBar.getHeight(), control.getHeight());

			// set listeners
			system.addEventListener(SystemEvent.UPDATE, onUpdateControls);

			control.addEventListener(ControlEvent.START, onStartSystem);
			control.addEventListener(ControlEvent.STOP, onStopSystem);
			control.addEventListener(ControlEvent.RESET, onResetSystem);
			control.addEventListener(ControlEvent.UPDATE, onUpdateSystem);

			menuBar.addEventListener(MenuEvent.LOAD, onLoadFile);

			// get default system data
			setupSystem(SystemData.defaultData());
		}

		/* ---------------------------------------------------------------- */

		private function onUpdateControls(e:SystemEvent):void
		{
			var val:Array = system.getValuesAsArray();
			control.setValuesAsArray(val);
		}

		/* ---------------------------------------------------------------- */

		private function onStartSystem(e:ControlEvent):void
		{
			system.startSystem();
		}

		private function onStopSystem(e:ControlEvent):void
		{
			system.stopSystem();
		}

		private function onResetSystem(e:ControlEvent):void
		{
			system.resetSystem();
		}

		private function onUpdateSystem(e:ControlEvent):void
		{
			var val:Array = control.getValuesAsArray();

			switch(e.args.update)
			{
				case ControlEvent.ROTATION:
					system.setPhiAsArray(val);
					break;
				case ControlEvent.OMEGA:
					system.setOmegaAsArray(val);
					break;
				case ControlEvent.LENGTH:
					system.setLengthAsArray(val);
					break;
				case ControlEvent.MASS:
					system.setMassAsArray(val);
					break;
			}

			system.updateSystem();
		}

		/* ---------------------------------------------------------------- */

		private function onLoadFile(e:MenuEvent):void
		{
			var xml:XML = (e.args.xml as XML);
			setupSystem(xml);
		}

		/* ---------------------------------------------------------------- */

		private function setupSystem(xml:XML):void
		{
			control.resetControls();
			control.setupControlColor(xml);

			system.setupSystem(xml);
		}

		/* ---------------------------------------------------------------- */

		public function getSystemAreaWidth():Number
		{
			return StageUtils.stage.stageWidth;
		}

		public function getSystemAreaHeight():Number
		{
			return (StageUtils.stage.stageHeight - menuBar.getHeight() - control.getHeight());
		}

		/* ---------------------------------------------------------------- */

		public function get main():Main {
			return _main;
		}
	}
}
