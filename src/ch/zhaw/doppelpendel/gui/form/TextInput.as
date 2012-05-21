/**
 * @class TextInput
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
package ch.zhaw.doppelpendel.gui.form
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	public class TextInput extends EventDispatcher
	{
		private var theClip:MovieClip;
		private var tfInput:TextField;
	
		private var _enabled:Boolean;

		private var _isNumericInput:Boolean;

		private var _minValue:Number = -Number.MAX_VALUE;
		private var _maxValue:Number = Number.MAX_VALUE;

		public function TextInput(target:MovieClip) 
		{
			theClip = target;
			
			tfInput = theClip.tf_input as TextField;
			tfInput.text = "";
			tfInput.tabEnabled = true;
			tfInput.addEventListener(Event.CHANGE, onChange);
		}

		public function kill():void
		{
			tfInput.removeEventListener(Event.CHANGE, onChange);
		}

		/* ----------------------------------------------------------------- */
		
		private function onChange(...args):void
		{
			if(isNumericInput){
				var num:Number = Number(tfInput.text);
				if(num <= _minValue || num >= _maxValue){
					return;
				}
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}

		/* ----------------------------------------------------------------- */

		public function set enabled(b:Boolean):void {
			_enabled = b;
			
			if(b){
				frame.alpha = 1;
			}else{
				frame.alpha = 0.5;				
			}
			
			back.visible = b;
			
			tfInput.selectable = b;
			
			if(b){
				tfInput.type = TextFieldType.INPUT;				
			}else{
				tfInput.type = TextFieldType.DYNAMIC;
			}
		}

		public function get enabled():Boolean {
			return _enabled;
		}
		
		public function get textField():TextField
		{
			return tfInput;
		}

		public function get back():Sprite
		{
			return theClip.mc_back as Sprite;
		}

		public function get backFill():Sprite
		{
			return theClip.mc_fill as Sprite;
		}
		
		public function get frame():Sprite
		{
			return theClip.mc_frame as Sprite;
		}

		public function set text(val:String):void
		{
			tfInput.text = val;
		}

		public function get text():String
		{
			return tfInput.text;
		}

		public function set maxLength(val:int):void
		{
			tfInput.maxChars = val;
		}

		public function get maxLength():int
		{
			return tfInput.maxChars;
		}
		
		public function set restrict(s:String):void {
			tfInput.restrict = s;
		}
		
		public function set selectable(val:Boolean):void {
			tfInput.selectable = val;
		}
		
		public function get selectable():Boolean
		{
			return tfInput.selectable;
		}
		
		/* ----------------------------------------------------------------- */
		
		public function set isNumericInput(b:Boolean):void {
			_isNumericInput = b;
		}

		public function get isNumericInput():Boolean {
			return _isNumericInput;
		}
		
		public function set minValue(n:Number):void
		{
			_minValue = n;
		}
		
		public function set maxValue(n:Number):void
		{
			_maxValue = n;
		}
	}
}
