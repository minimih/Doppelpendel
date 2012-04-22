/**
 * @class Doppelpendel
 *
 * @author 		mih
 */
package ch.zhaw.doppelpendel
{
	import ch.futurecom.log.FucoLogger;
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.ControlEvent;
	import ch.zhaw.doppelpendel.event.StageEvent;
	import ch.zhaw.doppelpendel.gui.Background;
	import ch.zhaw.doppelpendel.gui.Controls;
	import ch.zhaw.doppelpendel.gui.PendulumSystem;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Doppelpendel extends EventDispatcher
	{
		// singleton
		private static var _instance:Doppelpendel = new Doppelpendel();

		private var _main:Main;

		private var background:Background;
		private var system:PendulumSystem;
		private var controls:Controls;

		/* ---------------------------------------------------------------- */

		public function Doppelpendel()
		{
			if ( _instance ) throw new Error("Doppelpendel can only be accessed through Doppelpendel.getInstance()");
		}

		// getInstance
		public static function getInstance():Doppelpendel
		{
			return _instance;
		}

		/* ---------------------------------------------------------------- */

		public function init(main:Main):void
		{
			FucoLogger.debug("Doppelpendel.init");

			_main = main;

			// add bg
			background = new Background();
			main.addChild(background);

			// add system
			system = new PendulumSystem(xml.system);
			main.addChild(system);

			controls = new Controls();
			main.addChild(controls);

			// set listeners
			controls.addEventListener(ControlEvent.START, onStartSystem);
			controls.addEventListener(ControlEvent.STOP, onStopSystem);
			controls.addEventListener(ControlEvent.RESET, onResetSystem);

			// init stage resize listener
			onStageResize();
			StageUtils.stage.addEventListener(StageEvent.STAGERESIZE, onStageResize);
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

		public function get xml():XML {
			return main.xml;
		}
	}
}
