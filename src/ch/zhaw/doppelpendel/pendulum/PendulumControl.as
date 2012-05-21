/**
 * @class PendulumControl
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
	import ch.zhaw.doppelpendel.event.ControlEvent;
	import ch.zhaw.doppelpendel.event.StageEvent;
	import ch.zhaw.doppelpendel.gui.button.ColorButton;
	import ch.zhaw.doppelpendel.gui.button.ToggleButton;
	import ch.zhaw.doppelpendel.pendulum.element.Control;

	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.events.Event;

	public class PendulumControl extends AssetControls
	{
		private var systemSize:int;

		private var mcControls:MovieClip;
		private var mcBg:MovieClip;

		private var arrControls:Vector.<Control>;

		private var btnStartStop:ToggleButton;
		private var btnReset:ColorButton;

		public function PendulumControl(systemSize:int)
		{
			this.systemSize = systemSize;

			mcControls = this.mc_controls;
			mcBg = this.mc_bg;

			initControls();

			// add listener
			setSizeAndPosition();
			StageUtils.stage.addEventListener(StageEvent.STAGERESIZE, onStageResize);
		}

		public function initControls():void
		{
			arrControls = new Vector.<Control>(systemSize, true);

			for (var i:int = 0; i < systemSize; i++)
			{
				arrControls[i] = new Control(mcControls["mc_control_" + (i + 1)]);
				arrControls[i].addEventListener(ControlEvent.UPDATE, onUpdate);
			}

			// set buttons
			btnStartStop = new ToggleButton(mcControls.btn_start);
			btnStartStop.setToggleLabel("Start", "Stop");
			btnStartStop.setRollover();
			btnStartStop.setOnClick(onStartStop);

			btnReset = new ColorButton(mcControls.btn_reset);
			btnReset.setLabel("Reset");
			btnReset.setRollover();
			btnReset.setOnClick(onReset);
		}

		/* ----------------------------------------------------------------- */

		private function onStartStop():void
		{
			TweenMax.killAll();

			if (btnStartStop.isToggled)
			{
				setControlEnabled(false);
				dispatchEvent(new ControlEvent(ControlEvent.START));
			}
			else
			{
				setControlEnabled(true);
				dispatchEvent(new ControlEvent(ControlEvent.STOP));
			}
		}

		private function onReset():void
		{
			resetControls();
			dispatchEvent(new ControlEvent(ControlEvent.RESET));
		}

		private function onUpdate(e:ControlEvent):void
		{
			dispatchEvent(new ControlEvent(ControlEvent.UPDATE, e.args));
		}

		/* ----------------------------------------------------------------- */

		public function resetControls():void
		{
			setControlEnabled(true);
			btnStartStop.reset();
		}

		public function setupControlColor(xml:XML):void
		{
			var pendulumColor:XMLList = xml.system.pendulum.@color;
			for (var i:int = 0; i < arrControls.length; i++)
			{
				arrControls[i].setColor(pendulumColor[i]);
			}
		}

		/* ----------------------------------------------------------------- */

		private function setControlEnabled(b:Boolean):void
		{
			for (var i:int = 0; i < arrControls.length; i++)
			{
				arrControls[i].setFormEnabled(b);
			}
		}
		
		public function getValuesAsArray():Array
		{
			var val:Array = new Array();
			for (var i:int = 0; i < arrControls.length; i++)
			{
				val.push(arrControls[i].getValues());
			}
			
			return val;
		}

		public function setValuesAsArray(val:Array):void
		{
			for (var i:int = 0; i < arrControls.length; i++)
			{
				arrControls[i].setValues(val[i]);
			}
		}
		
		public function getHeight():int
		{
			return mcBg.height;
		}

		/* ----------------------------------------------------------------- */

		private function setSizeAndPosition():void
		{
			this.y = StageUtils.stageHeight - this.height;

			mcBg.width = StageUtils.stageWidth;
			mcControls.x = Math.round(mcBg.width - mcControls.width) * 0.5;
		}

		private function onStageResize(e:Event):void
		{
			setSizeAndPosition();
		}
	}
}
