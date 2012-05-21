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
	import ch.futurecom.net.loader.FucoURLLoader;
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.data.SystemData;
	import ch.zhaw.doppelpendel.event.ControlEvent;
	import ch.zhaw.doppelpendel.event.MenuEvent;
	import ch.zhaw.doppelpendel.event.SystemEvent;
	import ch.zhaw.doppelpendel.gui.Background;
	import ch.zhaw.doppelpendel.gui.Controls;
	import ch.zhaw.doppelpendel.gui.MenuBar;
	import ch.zhaw.doppelpendel.system.PendulumSystem;
	import ch.zhaw.doppelpendel.system.element.Pendulum;
	import ch.zhaw.doppelpendel.utils.Geom;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Doppelpendel extends EventDispatcher
	{
		private var _main:Main;

		private var background:Background;
		private var system:PendulumSystem;
		private var controls:Controls;

		private var menuBar:MenuBar;

		private var xmlLoader:FucoURLLoader;

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

			// create the menubar
			menuBar = new MenuBar();
			main.addChild(menuBar);

			// repos system
			system.setMargin(menuBar.getHeight(), controls.getHeight());

			// set listeners
			system.addEventListener(SystemEvent.UPDATE, onUpdateControls);

			controls.addEventListener(ControlEvent.START, onStartSystem);
			controls.addEventListener(ControlEvent.STOP, onStopSystem);
			controls.addEventListener(ControlEvent.RESET, onResetSystem);

			controls.addEventListener(ControlEvent.UPDATE, onUpdateSystem);

			menuBar.addEventListener(MenuEvent.LOAD, onLoadFile);

			// get default system data
			system.setupSystem(SystemData.defaultData());
		}

		/* ---------------------------------------------------------------- */

		private function onUpdateControls(e:SystemEvent):void
		{
			var p1:Pendulum = system.getP1();
			controls.phi1 = Geom.radToDeg(p1.pPhi);
			controls.omega1 = p1.pOmega;
			controls.length1 = p1.pLength;
			controls.mass1 = p1.pMass;

			var p2:Pendulum = system.getP2();
			controls.phi2 = Geom.radToDeg(p2.pPhi);
			controls.omega2 = p2.pOmega;
			controls.length2 = p2.pLength;
			controls.mass2 = p2.pMass;
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
			var p1:Pendulum = system.getP1();
			var p2:Pendulum = system.getP2();

			switch(e.args.update)
			{
				case ControlEvent.ROTATION:
					p1.pPhi = Geom.degToRad(controls.phi1);
					p2.pPhi = Geom.degToRad(controls.phi2);
					break;
				case ControlEvent.OMEGA:
					p1.pOmega = controls.omega1;
					p2.pOmega = controls.omega2;
					break;
				case ControlEvent.LENGTH:
					p1.pLength = controls.length1;
					p2.pLength = controls.length2;
					break;
				case ControlEvent.MASS:
					p1.pMass = controls.mass1;
					p2.pMass = controls.mass2;
					break;
			}

			system.updateSystem();
		}

		/* ---------------------------------------------------------------- */

		private function onLoadFile(e:MenuEvent):void
		{
			controls.resetControls();
			system.setupSystem((e.args.xml as XML));
		}

		/* ---------------------------------------------------------------- */

		public function getSystemAreaWidth():Number
		{
			return StageUtils.stage.stageWidth;
		}

		public function getSystemAreaHeight():Number
		{
			return (StageUtils.stage.stageHeight - menuBar.getHeight() - controls.getHeight());
		}

		/* ---------------------------------------------------------------- */

		public function get main():Main {
			return _main;
		}
	}
}
