/**
 * @class Controls
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
	import ch.futurecom.utils.Delegate;
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.ControlEvent;
	import ch.zhaw.doppelpendel.event.StageEvent;
	import ch.zhaw.doppelpendel.gui.button.ColorButton;
	import ch.zhaw.doppelpendel.gui.button.ToggleButton;
	import ch.zhaw.doppelpendel.gui.form.TextInput;

	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.events.Event;

	public class Controls extends AssetControls
	{
		private var mcControls:MovieClip;
		private var mcBg:MovieClip;

		private var tPhi1:TextInput;
		private var tPhi2:TextInput;
		private var tOmega1:TextInput;
		private var tOmega2:TextInput;
		private var tLength1:TextInput;
		private var tLength2:TextInput;
		private var tMass1:TextInput;
		private var tMass2:TextInput;

		private var btnStartStop:ToggleButton;
		private var btnReset:ColorButton;

		public function Controls()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			mcControls = this.mc_controls;
			mcBg = this.mc_bg;

			initControls();

			// add listener
			setSizeAndPosition();
			StageUtils.stage.addEventListener(StageEvent.STAGERESIZE, onStageResize);
		}

		private function initControls():void
		{
			tPhi1 = new TextInput(mcControls.inp_phi_1);
			tPhi1.isNumericInput = true;
			tPhi1.maxLength = 10;
			tPhi1.restrict = "0-9.";

			tPhi2 = new TextInput(mcControls.inp_phi_2);
			tPhi2.isNumericInput = true;
			tPhi2.maxLength = 10;
			tPhi2.restrict = "0-9.";

			tOmega1 = new TextInput(mcControls.inp_omega_1);
			tOmega1.isNumericInput = true;
			tOmega1.maxLength = 10;
			tOmega1.restrict = "\\-0-9.";

			tOmega2 = new TextInput(mcControls.inp_omega_2);
			tOmega2.isNumericInput = true;
			tOmega2.maxLength = 10;
			tOmega2.restrict = "\\-0-9.";

			tLength1 = new TextInput(mcControls.inp_length_1);
			tLength1.isNumericInput = true;
			tLength1.minValue = 0;
			tLength1.maxLength = 10;
			tLength1.restrict = "0-9.";

			tLength2 = new TextInput(mcControls.inp_length_2);
			tLength2.isNumericInput = true;
			tLength2.minValue = 0;
			tLength2.maxLength = 10;
			tLength2.restrict = "0-9.";

			tMass1 = new TextInput(mcControls.inp_mass_1);
			tMass1.isNumericInput = true;
			tMass1.minValue = 0;
			tMass1.maxLength = 10;
			tMass1.restrict = "0-9.";

			tMass2 = new TextInput(mcControls.inp_mass_2);
			tMass2.isNumericInput = true;
			tMass2.minValue = 0;
			tMass2.maxLength = 10;
			tMass2.restrict = "0-9.";

			// set buttons
			btnStartStop = new ToggleButton(mcControls.btn_start);
			btnStartStop.setToggleLabel("Start", "Stop");
			btnStartStop.setRollover();
			btnStartStop.setOnClick(onStartStop);

			btnReset = new ColorButton(mcControls.btn_reset);
			btnReset.setLabel("Reset");
			btnReset.setRollover();
			btnReset.setOnClick(onReset);

			// add eventlisteners
			tPhi1.addEventListener(Event.CHANGE, Delegate.create(onUpdate, ControlEvent.ROTATION));
			tPhi2.addEventListener(Event.CHANGE, Delegate.create(onUpdate, ControlEvent.ROTATION));
			tOmega1.addEventListener(Event.CHANGE, Delegate.create(onUpdate, ControlEvent.OMEGA));
			tOmega2.addEventListener(Event.CHANGE, Delegate.create(onUpdate, ControlEvent.OMEGA));
			tLength1.addEventListener(Event.CHANGE, Delegate.create(onUpdate, ControlEvent.LENGTH));
			tLength2.addEventListener(Event.CHANGE, Delegate.create(onUpdate, ControlEvent.LENGTH));
			tMass1.addEventListener(Event.CHANGE, Delegate.create(onUpdate, ControlEvent.MASS));
			tMass2.addEventListener(Event.CHANGE, Delegate.create(onUpdate, ControlEvent.MASS));
		}

		/* ----------------------------------------------------------------- */

		private function onStartStop():void
		{
			TweenMax.killAll();

			if (btnStartStop.isToggled)
			{
				setFormEnabled(false);
				dispatchEvent(new ControlEvent(ControlEvent.START));
			}
			else
			{
				setFormEnabled(true);
				dispatchEvent(new ControlEvent(ControlEvent.STOP));
			}
		}

		private function onReset():void
		{
			resetControls();
			dispatchEvent(new ControlEvent(ControlEvent.RESET));
		}

		private function onUpdate(type:String, e:Event):void
		{
			dispatchEvent(new ControlEvent(ControlEvent.UPDATE, {update:type}));
		}

		/* ----------------------------------------------------------------- */

		public function resetControls():void
		{
			setFormEnabled(true);
			btnStartStop.reset();
		}

		private function setFormEnabled(b:Boolean):void
		{
			tPhi1.enabled = b;
			tPhi2.enabled = b;
			tOmega1.enabled = b;
			tOmega2.enabled = b;
			tLength1.enabled = b;
			tLength2.enabled = b;
			tMass1.enabled = b;
			tMass2.enabled = b;
		}

		/* ----------------------------------------------------------------- */

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

		/* ----------------------------------------------------------------- */

		public function get phi1():Number {
			return Number(tPhi1.text);
		}
		
		public function set phi1(n:Number):void {
			tPhi1.text = n.toFixed(4);
		}

		public function get phi2():Number {
			return Number(tPhi2.text);
		}
		
		public function set phi2(n:Number):void {
			tPhi2.text = n.toFixed(4);
		}
		
		public function get omega1():Number {
			return Number(tOmega1.text);
		}
		
		public function set omega1(n:Number):void {
			tOmega1.text = n.toFixed(4);
		}

		public function get omega2():Number {
			return Number(tOmega2.text);
		}
		
		public function set omega2(n:Number):void {
			tOmega2.text = n.toFixed(4);
		}
		
		public function get length1():Number {
			return Number(tLength1.text);
		}
		
		public function set length1(n:Number):void {
			tLength1.text = n.toFixed(4);
		}

		public function get length2():Number {
			return Number(tLength2.text);
		}
		
		public function set length2(n:Number):void {
			tLength2.text = n.toFixed(4);
		}
		
		public function get mass1():Number {
			return Number(tMass1.text);
		}
		
		public function set mass1(n:Number):void {
			tMass1.text = n.toFixed(4);
		}
		
		public function get mass2():Number {
			return Number(tMass2.text);
		}
		
		public function set mass2(n:Number):void {
			tMass2.text = n.toFixed(4);
		}
	}
}
