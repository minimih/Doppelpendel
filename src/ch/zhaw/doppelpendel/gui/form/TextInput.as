/**
 * @class TextInput
 *
 * @author 		mih
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
	}
}
