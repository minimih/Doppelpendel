/**
 * @class Control
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
package ch.zhaw.doppelpendel.pendulum.element
{
	import ch.zhaw.doppelpendel.utils.Tabulator;
	import ch.futurecom.utils.Delegate;
	import ch.zhaw.doppelpendel.event.ControlEvent;
	import ch.zhaw.doppelpendel.gui.form.TextInput;
	import ch.zhaw.doppelpendel.utils.Geom;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;

	public class Control extends EventDispatcher
	{
		private var asset:MovieClip;

		private var tPhi:TextInput;
		private var tOmega:TextInput;
		private var tLength:TextInput;
		private var tMass:TextInput;

		public function Control(asset:MovieClip)
		{
			this.asset = asset;

			// add phi
			tPhi = new TextInput(asset.inp_phi);
			tPhi.isNumericInput = true;
			tPhi.fixPointLength = 3;
			tPhi.maxLength = 10;
			tPhi.restrict = "0-9.";
			tPhi.tabIndex = Tabulator.getIndex();

			tOmega = new TextInput(asset.inp_omega);
			tOmega.isNumericInput = true;
			tOmega.fixPointLength = 3;
			tOmega.maxLength = 10;
			tOmega.restrict = "\\-0-9.";
			tOmega.tabIndex = Tabulator.getIndex();

			tLength = new TextInput(asset.inp_length);
			tLength.isNumericInput = true;
			tLength.fixPointLength = 3;
			tLength.minValue = 0;
			tLength.maxLength = 10;
			tLength.restrict = "0-9.";
			tLength.tabIndex = Tabulator.getIndex();

			tMass = new TextInput(asset.inp_mass);
			tMass.isNumericInput = true;
			tMass.fixPointLength = 3;
			tMass.minValue = 0;
			tMass.maxLength = 10;
			tMass.restrict = "0-9.";
			tMass.tabIndex = Tabulator.getIndex();

			// add eventlisteners
			tPhi.addEventListener(Event.CHANGE, Delegate.create(onUpdate, ControlEvent.ROTATION));
			tOmega.addEventListener(Event.CHANGE, Delegate.create(onUpdate, ControlEvent.OMEGA));
			tLength.addEventListener(Event.CHANGE, Delegate.create(onUpdate, ControlEvent.LENGTH));
			tMass.addEventListener(Event.CHANGE, Delegate.create(onUpdate, ControlEvent.MASS));
		}

		/* ----------------------------------------------------------------- */

		private function onUpdate(type:String, e:Event):void
		{
			dispatchEvent(new ControlEvent(ControlEvent.UPDATE, {update:type}));
		}

		/* ----------------------------------------------------------------- */

		public function setColor(col:Number):void
		{
			var colTrans:ColorTransform = tPhi.backFill.transform.colorTransform;
			colTrans.color = col;
			
			tPhi.backFill.transform.colorTransform = colTrans;
			tOmega.backFill.transform.colorTransform = colTrans;
			tLength.backFill.transform.colorTransform = colTrans;
			tMass.backFill.transform.colorTransform = colTrans;
		}

		public function setFormEnabled(b:Boolean):void
		{
			tPhi.enabled = b;
			tOmega.enabled = b;
			tLength.enabled = b;
			tMass.enabled = b;
		}

		/* ----------------------------------------------------------------- */

		public function getValues():Array
		{
			return [phi, omega, length, mass];
		}

		public function setValues(val:Array):void
		{
			phi = val[0];
			omega = val[1];
			length = val[2];
			mass = val[3];
		}

		/* ----------------------------------------------------------------- */

		public function get phi():Number {
			return Number(tPhi.text);
		}

		public function set phi(n:Number):void {
			n = Geom.radToDeg(n);
			tPhi.text = n.toFixed(3);
		}

		public function get omega():Number {
			return Number(tOmega.text);
		}

		public function set omega(n:Number):void {
			tOmega.text = n.toFixed(3);
		}

		public function get length():Number {
			return Number(tLength.text);
		}

		public function set length(n:Number):void {
			tLength.text = n.toFixed(3);
		}

		public function get mass():Number {
			return Number(tMass.text);
		}

		public function set mass(n:Number):void {
			tMass.text = n.toFixed(3);
		}
	}
}
